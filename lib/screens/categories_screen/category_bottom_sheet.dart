import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/BottomSheet.dart';
import 'package:pro_fit_flutter/components/custom-text-field/custom_text_field.dart';

class CategoryBottomSheet extends StatefulWidget {
  final VoidCallback handleSubmit;
  const CategoryBottomSheet({super.key, required this.handleSubmit});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final TextEditingController _nameController = TextEditingController();

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
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                    overlayColor:
                        MaterialStatePropertyAll(Colors.deepPurpleAccent)),
                child: const Text('Create'),
                onPressed: () {
                  widget.handleSubmit();
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
