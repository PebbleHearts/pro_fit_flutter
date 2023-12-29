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
    return Container(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(80),
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 25,
              height: 25,
              child: IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.close,
                  size: 20,
                ),
                padding: const EdgeInsets.all(0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
