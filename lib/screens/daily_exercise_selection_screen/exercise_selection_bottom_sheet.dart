import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/BottomSheet.dart';
import 'package:pro_fit_flutter/components/exercise-card/exercise_card.dart';
import 'package:pro_fit_flutter/database/database.dart';

class ExerciseSelectionBottomSheet extends StatefulWidget {
  final List<ExerciseData> categoryExercises;
  final ValueSetter<List<ExerciseData>> onAddClick;
  const ExerciseSelectionBottomSheet({
    super.key,
    required this.categoryExercises,
    required this.onAddClick,
  });

  @override
  State<ExerciseSelectionBottomSheet> createState() =>
      _ExerciseSelectionBottomSheetState();
}

class _ExerciseSelectionBottomSheetState
    extends State<ExerciseSelectionBottomSheet> {
  List<ExerciseData> _selectedExercises = [];

  void _handleExerciseTap(ExerciseData exercise) {
    setState(() {
      _selectedExercises = [exercise];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      bottomSheetContent: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('something'),
            ...widget.categoryExercises.asMap().entries.map(
              (e) {
                final isSelected = _selectedExercises
                    .any((element) => element.id == e.value.id);
                return ExerciseCard(
                  name: e.value.name,
                  isSelected: isSelected,
                  onTap: () => _handleExerciseTap(e.value),
                );
              },
            ).toList(),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple),
                    overlayColor:
                        MaterialStatePropertyAll(Colors.deepPurpleAccent)),
                child: const Text('Add'),
                onPressed: () {
                  widget.onAddClick(_selectedExercises);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
