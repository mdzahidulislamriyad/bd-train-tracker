import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/station.dart';
import '../models/station_facility.dart';
import '../services/facility_service.dart';
import '../services/railway_data_service.dart';
import '../theme/app_theme.dart';
import '../widgets/station_picker_sheet.dart';
import 'facility_pin_picker_screen.dart';
import 'add_facility_screen.dart';

class StationFacilitiesScreen extends StatefulWidget {
  final Station? initialStation;

  const StationFacilitiesScreen({super.key, this.initialStation});

  @override
  State<StationFacilitiesScreen> createState() => _StationFacilitiesScreenState();
}

class _StationFacilitiesScreenState extends State<StationFacilitiesScreen> {
  final FacilityService _facilityService = FacilityService();
  final RailwayDataService _dataService = RailwayDataService();

  late Station _selectedStation;
  FacilityCategory? _selectedCategoryFilter;

  @override
  void initState() {
    super.initState();
    if (widget.initialStation != null) {
      _selectedStation = widget.initialStation!;
    } else {
      _selectedStation = _dataService.stations.firstWhere(
        (s) => s.name.toLowerCase() == 'dhaka',
        orElse: () => _dataService.stations.first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allStationFacilities =
        _facilityService.getFacilitiesForStation(_selectedStation.name);

    final filteredList = _selectedCategoryFilter == null
        ? allStationFacilities
        : allStationFacilities
            .where((f) => f.category == _selectedCategoryFilter)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('স্টেশন সুবিধা ও ডিরেক্টরি'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text('সুবিধা যোগ করুন', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddFacilityScreen(
                stationName: _selectedStation.name,
                stationNameBn: _selectedStation.nameBn.isNotEmpty
                    ? _selectedStation.nameBn
                    : _selectedStation.name,
                stationCoords: LatLng(_selectedStation.lat, _selectedStation.lng),
              ),
            ),
          );
          if (added == true) setState(() {});
        },
      ),
      body: Column(
        children: [
          // 1. Station Selector Header Card
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    StationPickerSheet.show(
                      context: context,
                      title: 'স্টেশন নির্বাচন করুন',
                      onSelected: (station) {
                        setState(() {
                          _selectedStation = station;
                          _selectedCategoryFilter = null;
                        });
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.train, color: AppTheme.primaryGreen),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'নির্বাচিত স্টেশন',
                                style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                              ),
                              Text(
                                _selectedStation.nameBn.isNotEmpty
                                    ? _selectedStation.nameBn
                                    : _selectedStation.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // "View all on map" Action Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('স্টেশনের ম্যাপে সব সুবিধা দেখুন'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      side: const BorderSide(color: AppTheme.primaryGreen),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FacilityPinPickerScreen(
                            initialCenter: LatLng(
                              _selectedStation.lat,
                              _selectedStation.lng,
                            ),
                            stationName: _selectedStation.nameBn,
                            existingFacilities: allStationFacilities,
                            isPickerMode: false,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 2. Horizontal Filter Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: const Text('সকল'),
                    selected: _selectedCategoryFilter == null,
                    selectedColor: AppTheme.lightGreen,
                    onSelected: (_) => setState(() => _selectedCategoryFilter = null),
                  ),
                ),
                ...FacilityCategory.values.map((cat) {
                  final isSelected = _selectedCategoryFilter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text('${cat.iconAsset} ${cat.labelBn}'),
                      selected: isSelected,
                      selectedColor: AppTheme.lightGreen,
                      onSelected: (_) => setState(() => _selectedCategoryFilter = cat),
                    ),
                  );
                }),
              ],
            ),
          ),

          const Divider(height: 1),

          // 3. Facility List
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.room_service_outlined, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 10),
                        const Text(
                          'এই ক্যাটাগরিতে এখনো কোনো তথ্য যুক্ত হয়নি',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'নিচের বাটনে ট্যাপ করে আপনিও প্রথম সুবিধা যোগ করতে পারেন!',
                          style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _buildFacilityCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(StationFacility item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.lightGreen,
                  radius: 20,
                  child: Text(item.category.iconAsset, style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.titleBn,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          if (item.isVerified)
                            const Icon(Icons.verified, color: Colors.blue, size: 16),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.amber[300]!),
                        ),
                        child: Text(
                          item.platform,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.locationHint,
              style: const TextStyle(fontSize: 13, color: AppTheme.textDark, height: 1.3),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      item.openHours,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.isFree ? '• বিনামূল্যে' : '• ফি প্রযোজ্য',
                      style: TextStyle(
                        fontSize: 11,
                        color: item.isFree ? Colors.green[700] : Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Upvotes / confirmed chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.thumb_up_alt_outlined, size: 12, color: AppTheme.primaryGreen),
                      const SizedBox(width: 4),
                      Text(
                        '${item.upvotes}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
