import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CTAItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isLoading;
  final VoidCallback onTap;
  const CTAItem({
    super.key,
    required this.label,
    required this.icon,
    required this.description,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null: onTap,
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              )
          ],
        ),
      ),
    );
  }
}
