import 'package:flutter/material.dart';

class DailyExerciseSelectionSelectedCard extends StatelessWidget {
  final String name;
  final VoidCallback onRemove;
  const DailyExerciseSelectionSelectedCard({
    super.key,
    required this.name,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(80),
      ),
      margin: const EdgeInsets.all(0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
                width: 25,
                height: 25,
                child: IconButton(
                    onPressed: onRemove,
                    icon: const Icon(
                      Icons.close,
                    ),
                    padding: EdgeInsets.all(0)))
          ],
        ),
      ),
    );
  }
}
