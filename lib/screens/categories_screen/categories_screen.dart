import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/screens/categories_screen/category_bottom_sheet.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _handleCategoryBottomSheetSubmission() {
    print("called");
  }

  void _showCustomBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CategoryBottomSheet(handleSubmit: _handleCategoryBottomSheetSubmission,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text('Categories'),
      ),
      body: const Text('Categories'),
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.add),
          onPressed: () {
            _showCustomBottomSheet(context);
          }),
    );
  }
}
