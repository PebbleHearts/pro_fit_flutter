import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/components/bottom-tab-bar/bottom_tab_item.dart';
import 'package:pro_fit_flutter/constants/theme.dart';

class BottomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function handleIndexChange;
  BottomTabBar({
    super.key,
    required this.currentIndex,
    required this.handleIndexChange,
  });

  final _tabs = [
    CustomBottomTabItem(icon: Icons.history, label: 'Log'),
    CustomBottomTabItem(icon: Icons.category, label: 'Categories'),
    CustomBottomTabItem(icon: Icons.group_work, label: 'Routines'),
    CustomBottomTabItem(icon: Icons.settings, label: 'Settings')
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: purpleTheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _tabs
            .asMap()
            .entries
            .map(
              (entry) => BottomTabItem(
                tabItem: entry.value,
                isSelected: currentIndex == entry.key,
                onPress: () => handleIndexChange(entry.key),
              ),
            )
            .toList(),
      ),
    );
  }
}
