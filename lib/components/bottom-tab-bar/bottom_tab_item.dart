import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/constants/theme.dart';

class BottomTabItem extends StatelessWidget {
  final CustomBottomTabItem tabItem;
  final bool isSelected;
  final VoidCallback onPress;
  const BottomTabItem({
    super.key,
    required this.tabItem,
    required this.isSelected,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: purpleTheme.primary,
        child: InkWell(
          onTap: onPress,
          highlightColor: purpleTheme.primary.withOpacity(0.5),
          splashColor: Colors.white.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tabItem.icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 22,
              ),
              Text(
                tabItem.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
