import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/bottom_sheet.dart';
import 'package:pro_fit_flutter/components/custom-text-field/custom_text_field.dart';
import 'package:pro_fit_flutter/components/custom_elevated_button/custom_elevated_button.dart';
import 'package:pro_fit_flutter/database/database.dart';

class RoutineBottomSheet extends StatefulWidget {
  final ValueSetter<String> handleSubmit;
  final RoutineData? editingRoutine;
  final bool isEditing;
  const RoutineBottomSheet({
    super.key,
    required this.handleSubmit,
    this.editingRoutine,
    required this.isEditing,
  });

  @override
  State<RoutineBottomSheet> createState() => _RoutineBottomSheetState();
}

class _RoutineBottomSheetState extends State<RoutineBottomSheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _nameController.text = widget.editingRoutine!.name;
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
              child: CustomElevatedButton(
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
