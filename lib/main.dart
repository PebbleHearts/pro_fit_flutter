import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/navigators/tab-navigator/tab_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProFit Flutter',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TabNavigator(),
    );
  }
}
