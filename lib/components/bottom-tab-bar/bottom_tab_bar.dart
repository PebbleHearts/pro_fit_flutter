import 'package:flutter/material.dart';

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
      color: Colors.deepPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _tabIcons.asMap().entries.map((entry) =>   IconButton(
            icon: Icon(entry.value),
            onPressed: () {
              handleIndexChange(entry.key);
            },
            color: currentIndex == entry.key ? Colors.white : Colors.grey,
          ),).toList(),
      ),
    );
  }
}
