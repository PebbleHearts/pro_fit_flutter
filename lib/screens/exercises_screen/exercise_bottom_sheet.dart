import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/bottom_sheet.dart';
import 'package:pro_fit_flutter/components/custom-text-field/custom_text_field.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/database.dart';

class ExerciseBottomSheet extends StatefulWidget {
  final bool isEditing;
  final ExerciseData? editingExercise;
  final ValueSetter<String> handleSubmit;
  const ExerciseBottomSheet({
    super.key,
    required this.isEditing,
    required this.handleSubmit,
    this.editingExercise,
  });

  @override
  State<ExerciseBottomSheet> createState() => _ExerciseBottomSheetState();
}

class _ExerciseBottomSheetState extends State<ExerciseBottomSheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _nameController.text = widget.editingExercise!.name;
    }
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
            CustomTextField(controller: _nameController),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  backgroundColor:
                      MaterialStatePropertyAll(purpleTheme.primary),
                  overlayColor: MaterialStatePropertyAll(
                      purpleTheme.primary.withOpacity(0.5)),
                ),
                child: Text(widget.isEditing ? 'Save' : 'Create'),
                onPressed: () {
                  widget.handleSubmit(_nameController.text);
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
