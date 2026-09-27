import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const BloodDonorFinderApp());
}

class BloodDonorFinderApp extends StatelessWidget {
  const BloodDonorFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFFC62828); // blood-red seed for the theme

    return MaterialApp(
      title: 'Blood Donor Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
