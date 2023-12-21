import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const CategoryCard({
    super.key,
    required this.name,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
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
