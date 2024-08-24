import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-tab-bar/bottom_tab_bar.dart';
import 'package:pro_fit_flutter/screens/categories_screen/categories_screen.dart';
import 'package:pro_fit_flutter/screens/log_screen/log_screen.dart';
import 'package:pro_fit_flutter/screens/routines_screen/routines_screen.dart';
import 'package:pro_fit_flutter/screens/settings_screen/settings_screen.dart';

class TabNavigator extends StatefulWidget {
  const TabNavigator({super.key});

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;

  final _pages = [
    const HistoryScreen(),
    const CategoriesScreen(),
    const RoutinesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomTabBar(
          currentIndex: _currentIndex,
          handleIndexChange: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
