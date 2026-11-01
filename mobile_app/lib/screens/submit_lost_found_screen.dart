import 'package:flutter/material.dart';
import '../models/lost_found_item.dart';
import '../services/lost_found_service.dart';
import '../theme/app_theme.dart';

class SubmitLostFoundScreen extends StatefulWidget {
  const SubmitLostFoundScreen({super.key});

  @override
  State<SubmitLostFoundScreen> createState() => _SubmitLostFoundScreenState();
}

class _SubmitLostFoundScreenState extends State<SubmitLostFoundScreen> {
  final _formKey = GlobalKey<FormState>();

  ReportType _selectedType = ReportType.lost;
  ItemCategory _selectedCategory = ItemCategory.bag;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _trainController = TextEditingController();
  final TextEditingController _compartmentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newItem = LostFoundItem(
      id: 'lf_${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType,
      category: _selectedCategory,
      title: _titleController.text.trim(),
      trainName: _trainController.text.trim(),
      trainCode: '',
      compartment: _compartmentController.text.trim(),
      date: DateTime.now(),
      description: _descriptionController.text.trim(),
      contactName: _nameController.text.trim(),
      contactPhone: _phoneController.text.trim(),
    );

    LostFoundService().addItem(newItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.primaryGreen,
        content: Text(
          _selectedType == ReportType.lost
              ? 'আপনার হারানো বিজ্ঞপ্তির পোস্ট প্রকাশিত হয়েছে।'
              : 'ধন্যবাদ! আপনার প্রাপ্তির বিজ্ঞপ্তি প্রকাশিত হয়েছে।',
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('হারানো ও প্রাপ্তি রিপোর্ট'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Report Type Switcher (Lost vs Found)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = ReportType.lost),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedType == ReportType.lost
                                ? Colors.red[600]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'আমি কিছু হারিয়েছি (Lost)',
                            style: TextStyle(
                              color: _selectedType == ReportType.lost
                                  ? Colors.white
                                  : AppTheme.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = ReportType.found),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedType == ReportType.found
                                ? AppTheme.primaryGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'আমি কিছু পেয়েছি (Found)',
                            style: TextStyle(
                              color: _selectedType == ReportType.found
                                  ? Colors.white
                                  : AppTheme.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Category Selector
              const Text(
                'পণ্যের ধরন (Category) *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<ItemCategory>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ItemCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Text(cat.iconEmoji, style: const TextStyle(fontSize: 18)),
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

              // Title
              const Text(
                'সংক্ষিপ্ত শিরোনাম *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'যেমন: কালো রঙের ব্যাকপ্যাক, পাসপোর্ট...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'শিরোনাম প্রদান করুন' : null,
              ),

              const SizedBox(height: 16),

              // Train Name
              const Text(
                'ট্রেনের নাম *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _trainController,
                decoration: InputDecoration(
                  hintText: 'যেমন: সুবর্ণ এক্সপ্রেস, সোনার বাংলা, পারাবত...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'ট্রেনের নাম লিখুন' : null,
              ),

              const SizedBox(height: 16),

              // Compartment / Seat
              const Text(
                'বগি ও সম্ভাব্য সিট নম্বর',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _compartmentController,
                decoration: InputDecoration(
                  hintText: 'যেমন: বগি খ, সিট ৩৪ এর কাছে...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                'বিস্তারিত বিবরণ *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'পণ্যটির বিশেষ কোনো চিহ্ন, রঙ বা শনাক্তকারী বিবরণ লিখুন...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'বিবরণ লিখুন' : null,
              ),

              const SizedBox(height: 16),

              // Contact Name & Phone
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'আপনার নাম *',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'নাম লিখুন',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty) ? 'নাম লিখুন' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'যোগাযোগের নম্বর *',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '01XXXXXXXXX',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (val) =>
                              (val == null || val.trim().isEmpty) ? 'নম্বর লিখুন' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('রিপোর্ট পোস্ট করুন'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedType == ReportType.lost
                        ? Colors.red[600]
                        : AppTheme.primaryGreen,
                  ),
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
