import 'package:flutter/material.dart';
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

  final _tabIcons = [
    Icons.history,
    Icons.category,
    Icons.group_work,
    Icons.settings
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: purpleTheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _tabIcons
            .asMap()
            .entries
            .map(
              (entry) => BottomTabItem(
                icon: entry.value,
                isSelected: currentIndex == entry.key,
                onPress: () => handleIndexChange(entry.key),
              ),
            )
            .toList(),
      ),
    );
  }
}
