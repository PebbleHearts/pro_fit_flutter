import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/BottomSheet.dart';

class CategoryBottomSheet extends StatefulWidget {
  final VoidCallback handleSubmit;
  const CategoryBottomSheet({super.key, required this.handleSubmit});

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    @override
    void dispose() {
      nameController.dispose();
    }

    return CustomBottomSheet(
      bottomSheetContent: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: nameController,
          ),
          const SizedBox(
            height: 5,
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
    );
  }
}
