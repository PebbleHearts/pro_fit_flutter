import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/bottom_sheet.dart';
import 'package:pro_fit_flutter/components/custom_elevated_button/custom_elevated_button.dart';
import 'package:pro_fit_flutter/components/exercise-card/exercise_card.dart';
import 'package:pro_fit_flutter/database/database.dart';

class ExerciseSelectionBottomSheet extends StatefulWidget {
  final List<ExerciseData> categoryExercises;
  final List<ExerciseData> selectedExercisesForTheDay;
  final ValueSetter<List<ExerciseData>> onAddClick;
  final List<ExerciseLogData> currentDayWorkoutLogItems;
  const ExerciseSelectionBottomSheet({
    super.key,
    required this.categoryExercises,
    required this.selectedExercisesForTheDay,
    required this.currentDayWorkoutLogItems,
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

  @override
  void initState() {
    super.initState();
    _selectedExercises =  widget.selectedExercisesForTheDay;
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
            const Text('Select Exercise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height: 10),
            ...widget.categoryExercises.asMap().entries.map(
              (e) {
                final isSelected = _selectedExercises
                    .any((element) => element.id == e.value.id);
                final isDisabled = widget.currentDayWorkoutLogItems
                    .any((element) => element.exerciseId == e.value.id);
                return Column(
                  children: [
                    ExerciseCard(
                      name: e.value.name,
                      isSelected: isSelected,
                      isDisabled: isDisabled,
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
              child: CustomElevatedButton(
                child: const Text('Update'),
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
