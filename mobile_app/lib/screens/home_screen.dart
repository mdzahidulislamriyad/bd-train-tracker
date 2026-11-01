import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/train_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/station_picker_sheet.dart';
import '../widgets/train_card.dart';
import '../widgets/voice_search_sheet.dart';
import 'station_facilities_screen.dart';
import 'lost_found_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrainProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('বিডি ট্রেন গাইড ও ট্র্যাকার'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            tooltip: 'ভয়েস সার্চ',
            onPressed: () => VoiceSearchSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined),
            tooltip: 'হারানো ও প্রাপ্তি',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LostFoundScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.room_service_outlined),
            tooltip: 'স্টেশন সুবিধা',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StationFacilitiesScreen(
                    initialStation: provider.fromStation,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentOrange,
        tooltip: 'মুখে বলুন (ভয়েস সার্চ)',
        child: const Icon(Icons.mic, color: Colors.white, size: 28),
        onPressed: () => VoiceSearchSheet.show(context),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Search Box Card
                  _buildSearchCard(context, provider),

                  // 2. Quick Services Shortcut Banners (Station Facilities & Lost/Found)
                  _buildQuickServicesRow(context, provider),

                  const SizedBox(height: 8),

                  // 3. Popular Routes Shortcuts
                  _buildPopularRoutes(context, provider),

                  const SizedBox(height: 12),

                  // 4. Trains Result Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'উপলব্ধ ট্রেন (${provider.searchResults.length}টি)',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM, yyyy').format(provider.travelDate),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Results List
                  if (provider.searchResults.isEmpty)
                    _buildEmptyState()
                  else
                    ...provider.searchResults.map((train) => TrainCard(train: train)),

                  const SizedBox(height: 70), // padding for FAB
                ],
              ),
            ),
    );
  }

  Widget _buildQuickServicesRow(BuildContext context, TrainProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          // Station Facilities Card
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StationFacilitiesScreen(
                      initialStation: provider.fromStation,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: const Row(
                  children: [
                    Text('🕌💧', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'স্টেশন সুবিধা',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            'নামাজ, পানি ও টয়লেট',
                            style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Lost and Found Card
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LostFoundScreen()),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: const Row(
                  children: [
                    Text('🎒📢', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'হারানো ও প্রাপ্তি',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            'ট্রেনে ফেলে যাওয়া বস্তু',
                            style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context, TrainProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Station Selection Row
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  // From Station
                  _buildStationTile(
                    label: 'যাওয়ার স্টেশন (From)',
                    stationName: provider.fromStation?.nameBn ?? 'স্টেশন নির্বাচন করুন',
                    icon: Icons.trip_origin,
                    iconColor: Colors.blue,
                    onTap: () {
                      StationPickerSheet.show(
                        context: context,
                        title: 'যাওয়ার স্টেশন নির্বাচন করুন',
                        onSelected: provider.setFromStation,
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 40),
                  // To Station
                  _buildStationTile(
                    label: 'গন্তব্য স্টেশন (To)',
                    stationName: provider.toStation?.nameBn ?? 'স্টেশন নির্বাচন করুন',
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    onTap: () {
                      StationPickerSheet.show(
                        context: context,
                        title: 'গন্তব্য স্টেশন নির্বাচন করুন',
                        onSelected: provider.setToStation,
                      );
                    },
                  ),
                ],
              ),
              // Swap Button
              Positioned(
                right: 8,
                child: FloatingActionButton.small(
                  heroTag: 'swapBtn',
                  backgroundColor: AppTheme.lightGreen,
                  elevation: 1,
                  onPressed: provider.swapStations,
                  child: const Icon(
                    Icons.swap_vert,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Date Selector Row
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: provider.travelDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (picked != null) {
                provider.setTravelDate(picked);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppTheme.primaryGreen),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'যাত্রার তারিখ',
                        style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy').format(provider.travelDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Search Button & Voice Mic Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('ট্রেন খুঁজুন'),
                  onPressed: provider.searchTrains,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.mic, color: AppTheme.primaryGreen),
                  tooltip: 'ভয়েস সার্চ',
                  onPressed: () => VoiceSearchSheet.show(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStationTile({
    required String label,
    required String stationName,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stationName,
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
    );
  }

  Widget _buildPopularRoutes(BuildContext context, TrainProvider provider) {
    final routes = [
      {'from': 'Dhaka', 'to': 'Chattogram', 'title': 'ঢাকা ➔ চট্টগ্রাম'},
      {'from': 'Dhaka', 'to': 'Coxs Bazar', 'title': 'ঢাকা ➔ কক্সবাজার'},
      {'from': 'Dhaka', 'to': 'Sylhet', 'title': 'ঢাকা ➔ সিলেট'},
      {'from': 'Dhaka', 'to': 'Rajshahi', 'title': 'ঢাকা ➔ রাজশাহী'},
      {'from': 'Dhaka', 'to': 'Khulna', 'title': 'ঢাকা ➔ খুলনা'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'জনপ্রিয় রুটসমূহ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: routes.map((r) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(r['title']!),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  onSelected: (_) {
                    provider.searchTrains();
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.directions_railway_outlined, size: 54, color: Colors.grey[400]),
          const SizedBox(height: 12),
          const Text(
            'এই রুটে কোনো ট্রেন পাওয়া যায়নি',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'অনুগ্রহ করে স্টেশন বা তারিখ পরিবর্তন করে আবার চেষ্টা করুন।',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
