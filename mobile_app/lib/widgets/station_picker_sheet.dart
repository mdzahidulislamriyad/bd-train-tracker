import 'package:flutter/material.dart';
import '../models/station.dart';
import '../services/railway_data_service.dart';
import '../theme/app_theme.dart';

class StationPickerSheet extends StatefulWidget {
  final String title;
  final ValueChanged<Station> onStationSelected;

  const StationPickerSheet({
    super.key,
    required this.title,
    required this.onStationSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required ValueChanged<Station> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StationPickerSheet(
        title: title,
        onStationSelected: onSelected,
      ),
    );
  }

  @override
  State<StationPickerSheet> createState() => _StationPickerSheetState();
}

class _StationPickerSheetState extends State<StationPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Station> _filteredStations = [];
  final RailwayDataService _dataService = RailwayDataService();

  final List<String> _popularStationCodes = [
    'Dhaka',
    'Chattogram',
    'Sylhet',
    'Rajshahi',
    'Khulna',
    'Coxs Bazar',
  ];

  @override
  void initState() {
    super.initState();
    _filteredStations = _dataService.stations;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredStations = _dataService.searchStations(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.train, color: AppTheme.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'স্টেশনের নাম খুঁজুন (বাংলা বা ইংরেজি)...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGreen),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.backgroundGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Popular shortcuts
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: _popularStationCodes.map((name) {
                final match = _dataService.stations.firstWhere(
                  (s) => s.name.toLowerCase().contains(name.toLowerCase()),
                  orElse: () => _dataService.stations.first,
                );
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: Text(match.nameBn.isNotEmpty ? match.nameBn : match.name),
                    backgroundColor: AppTheme.lightGreen,
                    labelStyle: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () {
                      widget.onStationSelected(match);
                      Navigator.pop(context);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          // Station List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStations.length,
              itemBuilder: (context, index) {
                final station = _filteredStations[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.lightGreen,
                    child: Icon(Icons.location_on, color: AppTheme.primaryGreen, size: 20),
                  ),
                  title: Text(
                    station.nameBn.isNotEmpty ? station.nameBn : station.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${station.name} (${station.code})'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    widget.onStationSelected(station);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
