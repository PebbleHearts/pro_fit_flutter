import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/bottom_sheet.dart';
import 'package:pro_fit_flutter/components/exercise-card/exercise_card.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/database.dart';

class RoutineCategoryExerciseListingBottomSheet extends StatefulWidget {
  final List<ExerciseData> exercises;
  final ValueSetter<List<ExerciseData>> handleSubmit;
  const RoutineCategoryExerciseListingBottomSheet({
    super.key,
    required this.exercises,
    required this.handleSubmit,
  });

  @override
  State<RoutineCategoryExerciseListingBottomSheet> createState() =>
      _RoutineCategoryExerciseListingBottomSheetState();
}

class _RoutineCategoryExerciseListingBottomSheetState
    extends State<RoutineCategoryExerciseListingBottomSheet> {
  List<ExerciseData> _selectedExercises = [];

  void _handleExerciseTap(ExerciseData exercise) {
    final isExistingItem = _selectedExercises.any(
      (element) => element.id == exercise.id,
    );
    if (isExistingItem) {
      setState(() {
        _selectedExercises.removeWhere((element) => element.id == exercise.id);
      });
    } else {
      setState(() {
        _selectedExercises = [..._selectedExercises, exercise];
      });
    }
  }

  void _handleSubmit() {
    widget.handleSubmit(_selectedExercises);
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
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...widget.exercises.asMap().entries.map(
              (e) {
                final isSelected = _selectedExercises
                    .any((element) => element.id == e.value.id);
                return Column(
                  children: [
                    ExerciseCard(
                      name: e.value.name,
                      isSelected: isSelected,
                      displayCta: false,
                      onTap: () => _handleExerciseTap(e.value),
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ).toList(),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    backgroundColor:
                        MaterialStatePropertyAll(purpleTheme.primary),
                    // TODO: Change the overlay color for this
                    overlayColor: MaterialStatePropertyAll(
                        purpleTheme.primary.withOpacity(0.5))),
                child: const Text('Add'),
                onPressed: () {
                  _handleSubmit();
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
