import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/bottom_sheet.dart';
import 'package:pro_fit_flutter/components/custom-text-field/custom_text_field.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/database.dart';

class CategoryBottomSheet extends StatefulWidget {
  final ValueSetter<String> handleSubmit;
  final CategoryData? editingCategory;
  final bool isEditing;
  const CategoryBottomSheet({
    super.key,
    required this.handleSubmit,
    this.editingCategory,
    required this.isEditing,
  });

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _nameController.text = widget.editingCategory!.name;
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
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    backgroundColor:
                        MaterialStatePropertyAll(purpleTheme.primary),
                    overlayColor: MaterialStatePropertyAll(
                        purpleTheme.primary.withOpacity(0.5))),
                child: const Text('Create'),
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
