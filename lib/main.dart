import 'package:flutter/material.dart';
import 'package:tractian/screens/home/view/home_screen.view.dart';
import 'package:tractian/src/app_theme.dart';

void main() {
  runApp(
    const TractianApp(),
  );
}

class TractianApp extends StatelessWidget {
  const TractianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
