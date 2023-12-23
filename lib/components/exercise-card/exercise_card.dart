import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  const ExerciseCard({
    super.key,
    required this.name,
    this.isSelected = false,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.deepPurple.withOpacity(0.4) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)],
          ),
        ),
      ),
    );
  }
}
