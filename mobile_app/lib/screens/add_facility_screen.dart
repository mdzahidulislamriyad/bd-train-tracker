import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/station_facility.dart';
import '../services/facility_service.dart';
import '../theme/app_theme.dart';
import 'facility_pin_picker_screen.dart';

class AddFacilityScreen extends StatefulWidget {
  final String stationName;
  final String stationNameBn;
  final LatLng stationCoords;

  const AddFacilityScreen({
    super.key,
    required this.stationName,
    required this.stationNameBn,
    required this.stationCoords,
  });

  @override
  State<AddFacilityScreen> createState() => _AddFacilityScreenState();
}

class _AddFacilityScreenState extends State<AddFacilityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _platformController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();

  FacilityCategory _selectedCategory = FacilityCategory.drinkingWater;
  bool _isFree = true;
  LatLng? _pinnedLocation;

  @override
  void initState() {
    super.initState();
    _pinnedLocation = widget.stationCoords;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newFacility = StationFacility(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      stationName: widget.stationName,
      stationNameBn: widget.stationNameBn,
      category: _selectedCategory,
      titleBn: _titleController.text.trim(),
      platform: _platformController.text.trim(),
      locationHint: _hintController.text.trim(),
      lat: _pinnedLocation?.latitude ?? widget.stationCoords.latitude,
      lng: _pinnedLocation?.longitude ?? widget.stationCoords.longitude,
      isFree: _isFree,
      upvotes: 1,
      isVerified: false, // User submitted, verified by crowd votes
    );

    FacilityService().addFacility(newFacility);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppTheme.primaryGreen,
        content: Text('ধন্যবাদ! আপনার যোগ করা সুবিধাটি পর্যালোচনায় জমা হয়েছে।'),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('স্টেশন সুবিধা যোগ করুন'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Station Header Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_city, color: AppTheme.primaryGreen),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'স্টেশনের নাম',
                            style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                          Text(
                            widget.stationNameBn,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Category Dropdown
              const Text(
                'সুবিধার ধরন নির্বাচন করুন *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<FacilityCategory>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                items: FacilityCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Text(cat.iconAsset, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(cat.labelBn),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),

              const SizedBox(height: 16),

              // Title input
              const Text(
                'সুবিধার নাম / শিরোনাম *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'যেমন: আধুনিক পানির ফিল্টার বুথ, মসজিদ...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'শিরোনাম প্রদান করুন' : null,
              ),

              const SizedBox(height: 16),

              // Platform input
              const Text(
                'প্ল্যাটফর্ম নম্বর বা অবস্থান *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _platformController,
                decoration: InputDecoration(
                  hintText: 'যেমন: প্ল্যাটফর্ম ২ এর মাঝামাঝি, ওভারব্রিজের নিচে...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'প্ল্যাটফর্ম উল্লেখ করুন' : null,
              ),

              const SizedBox(height: 16),

              // Location hint directions
              const Text(
                'খুঁজে পাওয়ার বিস্তারিত নির্দেশনা',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _hintController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'যাত্রীদের সুবিধার জন্য কীভাবে সহজে পাওয়া যাবে তা লিখুন...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Map Pin Selector Action Button
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pin_drop, color: Colors.red, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ম্যাপে সুনির্দিষ্ট অবস্থান',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            _pinnedLocation != null
                                ? 'পিন নির্ধারণ করা হয়েছে (${_pinnedLocation!.latitude.toStringAsFixed(4)}, ${_pinnedLocation!.longitude.toStringAsFixed(4)})'
                                : 'ম্যাপে ট্যাপ করে সঠিক জায়গা চিহ্নিত করুন',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      child: const Text('পিন করুন'),
                      onPressed: () async {
                        final result = await Navigator.push<LatLng>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FacilityPinPickerScreen(
                              initialCenter: _pinnedLocation ?? widget.stationCoords,
                              stationName: widget.stationNameBn,
                              isPickerMode: true,
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() => _pinnedLocation = result);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('সুবিধা যুক্ত করুন'),
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
