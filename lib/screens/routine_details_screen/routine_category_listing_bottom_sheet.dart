import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/bottom_sheet.dart';
import 'package:pro_fit_flutter/components/category-card/category_card.dart';
import 'package:pro_fit_flutter/database/database.dart';

class RoutineCategoryListingBottomSheet extends StatefulWidget {
  final List<CategoryData> categories;
  final ValueSetter<String> onCategoryClick;
  const RoutineCategoryListingBottomSheet({
    super.key,
    required this.onCategoryClick,
    required this.categories,
  });

  @override
  State<RoutineCategoryListingBottomSheet> createState() =>
      _RoutineCategoryListingBottomSheetState();
}

class _RoutineCategoryListingBottomSheetState
    extends State<RoutineCategoryListingBottomSheet> {
  void _handleCategoryTap(CategoryData category) {
    widget.onCategoryClick(category.id);
    Navigator.pop(context);
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
            ...widget.categories.asMap().entries.map(
              (e) {
                return Column(
                  children: [
                    CategoryCard(
                      name: e.value.name,
                      displayCta: false,
                      onTap: () => _handleCategoryTap(e.value),
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}
