import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/category-card/category_card.dart';
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

  Future<List<CategoryData>> _loadCategories() async {
    final database = AppDatabase();
    List<CategoryData> allCategoryItems =
        await database.select(database.category).get();
    return allCategoryItems;
  }

  void _fetchCategories() async {
    List<CategoryData> allCategoryItems = await _loadCategories();
    print(allCategoryItems);
    setState(() {
      _categories = allCategoryItems;
    });
  }

  void _handleCategoryBottomSheetSubmission(String categoryName) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = AppDatabase();

    await database.into(database.category).insert(
          CategoryCompanion.insert(
            name: categoryName,
          ),
        );

    _fetchCategories();
  }

  void _showCustomBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CategoryBottomSheet(
          handleSubmit: _handleCategoryBottomSheetSubmission,
        );
      },
    );
  }

  void _handleCategoryCardClick(String categoryId, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisesScreen(
          categoryId: categoryId,
          categoryName: name
        ),
      ),
    );
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
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text('Categories'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.deepPurple.withOpacity(0.1),
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ..._categories
                  .asMap()
                  .entries
                  .map((e) => CategoryCard(
                      name: e.value.name,
                      onTap: () => _handleCategoryCardClick(e.value.id, e.value.name)))
                  .toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.add),
          onPressed: () {
            _showCustomBottomSheet(context);
          }),
    );
  }
}


// [CategoryData(id: cc278cd0-17bc-417b-a89f-e7187334278d, name: Category 1), CategoryData(id: 575c4072-8aaf-4708-b492-821d67422319, name: category 2), CategoryData(id: 487d160f-3a9e-420f-9b01-de015b71bcde, name: category 3)]