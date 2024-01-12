import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/database/schema/category.dart';
import 'package:drift/drift.dart' as drift;

part 'category_dao.g.dart';

@DriftAccessor(tables: [Category])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  Future<List<CategoryData>> getAllCategoriesIncludeDeleted() async {
    final query = select(category);
    List<CategoryData> allCategoryItems = await query.map((row) => row).get();
    return allCategoryItems;
  }

  Future<List<CategoryData>> getAllCategories() async {
    final query = select(category)
      ..where((tbl) => tbl.status.equals('created'));
    List<CategoryData> allCategoryItems = await query.map((row) => row).get();
    return allCategoryItems;
  }

  void updateCategory(
    CategoryCompanion companionData,
    String categoryId,
  ) async {
    (update(category)..where((t) => t.id.equals(categoryId))).write(
      companionData,
    );
  }

  void createCategory(String categoryName) async {
    await into(category).insert(CategoryCompanion.insert(name: categoryName));
  }

  void insertCategoryRow(
    CategoryCompanion companionData,
  ) async {
    await into(category).insert(companionData);
  }

  void deleteCategoryItem(String categoryId) {
    (update(category)
          ..where(
            (t) => t.id.equals(categoryId),
          ))
        .write(
      const CategoryCompanion(
        status: drift.Value("deleted"),
      ),
    );
  }
}
