import 'package:flutter/material.dart';

import 'navigation/main_navigation.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FinanzasPersonalesApp());
}

class FinanzasPersonalesApp extends StatelessWidget {
  const FinanzasPersonalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanzas Personales',
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}