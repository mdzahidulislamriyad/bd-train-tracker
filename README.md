# 🚆 BD Train Tracker (বিডি ট্রেন ট্র্যাকার)

A modern, cross-platform live train tracking and passenger community platform for Bangladesh Railway.

## 🏗️ Architecture

```
bd-train-tracker/
├── data/                               # Master Railway Datasets
│   ├── stations.json                   # 506 Bangladesh Railway stations with Lat/Lng & Bengali names
│   ├── railway_nodes.json              # 6,002 track nodes for GPS snapping
│   ├── railway_edges.json              # 6,010 track line segments
│   └── trains.json                     # Major intercity trains with schedules & off-days
├── mobile_app/                         # Flutter Mobile App (Android & iOS)
│   ├── lib/
│   │   ├── models/                     # Station, Train, LiveLocation models
│   │   ├── services/                   # RailwayDataService & offline datasets loader
│   │   ├── providers/                  # TrainProvider (State Management)
│   │   ├── theme/                      # AppTheme (Bangladesh Railway green & dark navy palette)
│   │   ├── widgets/                    # StationPickerSheet, TrainCard
│   │   ├── screens/                    # HomeScreen, LiveMapScreen (OpenStreetMap)
│   │   └── main.dart                   # Application Entrypoint
│   └── pubspec.yaml                    # Flutter dependencies (flutter_map, latlong2, provider)
└── backend/                            # Real-time Crowdsourced Backend (Node.js & Socket.io)
    ├── server.js                       # REST API & WebSocket Hub
    └── package.json
```

## 🚀 Running the Project

### 1. Backend Server
```bash
cd backend
pnpm install
node server.js
```
The server starts on `http://localhost:3000` with WebSockets enabled.

### 2. Flutter Mobile App
```bash
cd mobile_app
flutter pub get
flutter run
```
Runs seamlessly on Android, iOS, and Web.
