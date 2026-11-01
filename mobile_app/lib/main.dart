import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/train_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BdTrainTrackerApp());
}

class BdTrainTrackerApp extends StatelessWidget {
  const BdTrainTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TrainProvider()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'বিডি ট্রেন ট্র্যাকার',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
