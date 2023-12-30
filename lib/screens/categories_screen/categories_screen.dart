import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/components/category-card/category_card.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/categories_screen/category_bottom_sheet.dart';
import 'package:pro_fit_flutter/screens/exercises_screen/exercises_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryData> _categories = [];
  CategoryData? _editingCategory;

  Future<List<CategoryData>> _loadCategories() async {
    final query = database.select(database.category)
      ..where((tbl) => tbl.status.equals('created'));
    List<CategoryData> allCategoryItems = await query.map((row) => row).get();
    return allCategoryItems;
  }

  void _fetchCategories() async {
    List<CategoryData> allCategoryItems = await _loadCategories();
    setState(() {
      _categories = allCategoryItems;
    });
  }

  void _handleCategoryBottomSheetSubmission(String categoryName) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_editingCategory != null) {
      (database.update(database.category)
            ..where(
              (t) => t.id.equals(_editingCategory!.id),
            ))
          .write(
        CategoryCompanion(
          name: drift.Value(categoryName),
        ),
      );
      setState(() {
        _editingCategory = null;
      });
    } else {
      await database.into(database.category).insert(
            CategoryCompanion.insert(
              name: categoryName,
            ),
          );
    }

    _fetchCategories();
  }

  void _showCustomBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return CategoryBottomSheet(
          isEditing: _editingCategory != null,
          editingCategory: _editingCategory,
          handleSubmit: _handleCategoryBottomSheetSubmission,
        );
      },
    );
    if (_editingCategory != null) {
      setState(() {
        _editingCategory = null;
      });
    }
  }

  void _handleCategoryCardClick(String categoryId, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExercisesScreen(categoryId: categoryId, categoryName: name),
      ),
    );
  }

  void _handleCategoryItemDelete(String categoryId) {
    (database.update(database.category)
          ..where(
            (t) => t.id.equals(categoryId),
          ))
        .write(
      const CategoryCompanion(
        status: drift.Value("deleted"),
      ),
    );

    _fetchCategories();
  }

  void _handleCategoryItemEditClick(String categoryId) {
    CategoryData item =
        _categories.firstWhere((element) => element.id == categoryId);
    setState(() {
      _editingCategory = item;
    });
    _showCustomBottomSheet(context);
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('ProFit'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: purpleTheme.background,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 47, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ..._categories
                          .asMap()
                          .entries
                          .map((e) => Column(
                                children: [
                                  CategoryCard(
                                    name: e.value.name,
                                    onTap: () => _handleCategoryCardClick(
                                        e.value.id, e.value.name),
                                    onDelete: () =>
                                        _handleCategoryItemDelete(e.value.id),
                                    onEdit: () => _handleCategoryItemEditClick(
                                        e.value.id),
                                    displayCta: true,
                                  ),
                                  const SizedBox(height: 7)
                                ],
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
          heroTag: null,
          backgroundColor: purpleTheme.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          onPressed: () {
            _showCustomBottomSheet(context);
          }),
    );
  }
}
