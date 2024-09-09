import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian/screens/assets_screen/model/store/assets_screen_store.dart';
import 'package:tractian/screens/assets_screen/model/store/search_store.dart';
import 'package:tractian/screens/home_screen/view/home_screen.view.dart';
import 'package:tractian/src/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => SearchStore()),
        Provider(create: (_) => AssetsScreenStore()),
      ],
      child: const TractianApp(),
    ),
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
