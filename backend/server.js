import express from 'express';
import http from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: '*' },
});

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Load Railway Master Data
const dataDir = path.join(__dirname, '../data');
let stations = [];
let trains = [];

try {
  stations = JSON.parse(fs.readFileSync(path.join(dataDir, 'stations.json'), 'utf-8'));
  trains = JSON.parse(fs.readFileSync(path.join(dataDir, 'trains.json'), 'utf-8'));
  console.log(`[Data] Loaded ${stations.length} stations and ${trains.length} trains.`);
} catch (err) {
  console.error('[Data Error] Could not load JSON files:', err.message);
}

// In-Memory Live Train Location State
// Map<trainCode, { lat, lng, speed, nearestStation, nextStation, lastUpdated, reporterCount }>
const activeTrains = new Map();

// In-Memory Recent Chat Messages per Train
// Map<trainCode, Array<{ id, user, text, time, reactions }>>
const trainChats = new Map();

// --- REST Endpoints ---

app.get('/health', (req, res) => {
  res.json({
    status: 'online',
    service: 'BD Train Tracker Real-Time API',
    uptimeSeconds: Math.floor(process.uptime()),
    activeLiveTrains: activeTrains.size,
  });
});

app.get('/api/stations', (req, res) => {
  const { query } = req.query;
  if (!query) {
    return res.json(stations);
  }
  const q = query.trim().toLowerCase();
  const filtered = stations.filter(
    (s) =>
      s.name.toLowerCase().includes(q) ||
      s.name_bn.includes(q) ||
      s.code.toLowerCase().includes(q)
  );
  res.json(filtered);
});

app.get('/api/trains', (req, res) => {
  const { from, to } = req.query;
  if (from && to) {
    const fromQ = from.trim().toLowerCase();
    const toQ = to.trim().toLowerCase();
    const matched = trains.filter(
      (t) =>
        (t.origin.toLowerCase().includes(fromQ) || fromQ.includes(t.origin.toLowerCase())) &&
        (t.destination.toLowerCase().includes(toQ) || toQ.includes(t.destination.toLowerCase()))
    );
    return res.json(matched);
  }
  res.json(trains);
});

app.get('/api/trains/:code/live', (req, res) => {
  const { code } = req.params;
  const live = activeTrains.get(code);
  if (!live) {
    return res.status(404).json({
      trainCode: code,
      isLive: false,
      message: 'No active passengers are currently reporting live location for this train.',
    });
  }
  res.json({
    trainCode: code,
    isLive: true,
    ...live,
  });
});

// REST Fallback for Location Submission
app.post('/api/trains/:code/report-location', (req, res) => {
  const { code } = req.params;
  const { lat, lng, speed = 0, reporterName = 'Anonymous' } = req.body;

  if (lat == null || lng == null) {
    return res.status(400).json({ error: 'lat and lng are required.' });
  }

  // Update in-memory state
  const current = activeTrains.get(code) || { reporterCount: 0 };
  const updated = {
    lat: Number(lat),
    lng: Number(lng),
    speed: Number(speed),
    nearestStation: 'নিকটবর্তী স্টেশন',
    nextStation: 'পরবর্তী স্টেশন',
    lastUpdated: new Date().toISOString(),
    reporterCount: (current.reporterCount || 0) + 1,
  };

  activeTrains.set(code, updated);

  // Broadcast to all Socket.io clients watching this train
  io.to(`train:${code}`).emit('train:location_update', {
    trainCode: code,
    ...updated,
  });

  res.json({ success: true, updated });
});

// --- Real-time Socket.io Hub ---

io.on('connection', (socket) => {
  console.log(`[Socket] Client connected: ${socket.id}`);

  // Join a train room
  socket.on('train:join', ({ trainCode }) => {
    if (!trainCode) return;
    const room = `train:${trainCode}`;
    socket.join(room);
    console.log(`[Socket] ${socket.id} joined ${room}`);

    // Send latest live location if available
    const live = activeTrains.get(trainCode);
    if (live) {
      socket.emit('train:location_update', { trainCode, ...live });
    }

    // Send recent chat messages
    const recent = trainChats.get(trainCode) || [];
    socket.emit('train:recent_chat', recent.slice(-30));
  });

  // Passenger reporting location
  socket.on('train:share_location', ({ trainCode, lat, lng, speed = 0, userName = 'Passenger' }) => {
    if (!trainCode || lat == null || lng == null) return;

    const updated = {
      lat: Number(lat),
      lng: Number(lng),
      speed: Number(speed),
      nearestStation: 'লাইভ ট্র্যাক',
      nextStation: 'চলমান',
      lastUpdated: new Date().toISOString(),
      reporterCount: 1,
    };

    activeTrains.set(trainCode, updated);

    // Broadcast to room
    io.to(`train:${trainCode}`).emit('train:location_update', {
      trainCode,
      ...updated,
    });
  });

  // Passenger sending chat message
  socket.on('train:send_chat', ({ trainCode, userName = 'Passenger', text }) => {
    if (!trainCode || !text?.trim()) return;

    const message = {
      id: Date.now().toString(),
      user: userName,
      text: text.trim(),
      time: new Date().toLocaleTimeString('bn-BD', { hour: '2-digit', minute: '2-digit' }),
    };

    if (!trainChats.has(trainCode)) {
      trainChats.set(trainCode, []);
    }
    const chatList = trainChats.get(trainCode);
    chatList.push(message);
    if (chatList.length > 100) chatList.shift(); // retain last 100

    io.to(`train:${trainCode}`).emit('train:new_message', message);
  });

  socket.on('disconnect', () => {
    console.log(`[Socket] Client disconnected: ${socket.id}`);
  });
});

// Start Server
server.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 BD Train Tracker Backend Server running on http://localhost:${PORT}`);
  console.log(`📡 WebSocket Hub ready on ws://localhost:${PORT}`);
});
