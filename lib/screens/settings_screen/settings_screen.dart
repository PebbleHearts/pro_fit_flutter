import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/constants/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('ProFit'),
      ),
      body: const Text('Settings'),
    );
  }
}