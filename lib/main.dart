import 'package:flutter/material.dart';
import 'coach_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'League Center',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        primarySwatch: Colors.orange,
        useMaterial3: true,
        fontFamily: 'Roboto', // Defaulting to Roboto, but can be customized
      ),
      home: const CoachDashboardScreen(),
    );
  }
}
