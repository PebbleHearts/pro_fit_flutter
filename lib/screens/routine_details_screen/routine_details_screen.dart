import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/data-model/common.dart';
import 'package:pro_fit_flutter/components/routine_detail_item_card/routine_detail_item_card.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/routine_details_screen/routine_category_exercise_listing_bottom_sheet.dart';
import 'package:pro_fit_flutter/screens/routine_details_screen/routine_category_listing_bottom_sheet.dart';

class RoutineDetailsScreen extends StatefulWidget {
  final String routineId;
  final String routineName;
  const RoutineDetailsScreen({
    super.key,
    required this.routineId,
    required this.routineName,
  });

  @override
  State<RoutineDetailsScreen> createState() => _RoutineDetailsScreenState();
}

class _RoutineDetailsScreenState extends State<RoutineDetailsScreen> {
  List<CategoryData> _categories = [];
  String _selectedCategoryId = '';
  List<ExerciseData> _selectedCategoryExercises = [];
  List<RoutineDetailItemWithExercise> _routineDetailItems = [];

  Future<List<RoutineDetailItemWithExercise>> _loadRoutineDetailItems() async {
    // final query = database.select(database.routineDetailItem)
    //   ..where(
    //     (tbl) => tbl.routineId.equals(widget.routineId),
    //   );
    // final exerciseItems = query.map((row) => row).get();
    // return exerciseItems;

    final query = database.select(database.routineDetailItem).join([
      drift.innerJoin(
          database.exercise,
          database.routineDetailItem.exerciseId
              .equalsExp(database.exercise.id)),
    ])
      ..where(
        database.routineDetailItem.routineId.equals(widget.routineId),
      );
    return query.map((row) {
      return RoutineDetailItemWithExercise(
          row.readTable(database.routineDetailItem),
          row.readTable(
            database.exercise,
          ));
    }).get();
  }

  void _fetchRoutineDetailItems() async {
    List<RoutineDetailItemWithExercise> routineDetailItems =
        await _loadRoutineDetailItems();
    setState(() {
      _routineDetailItems = routineDetailItems;
    });
  }

  Future<List<CategoryData>> _loadCategories() async {
    final query = database.select(database.category)..where((tbl) => tbl.status.equals('created'));
    List<CategoryData> allCategoryItems = await query.map((p0) => p0).get();
    return allCategoryItems;
  }

  void _fetchCategories() async {
    List<CategoryData> allCategoryItems = await _loadCategories();
    print(allCategoryItems);
    setState(() {
      _categories = allCategoryItems;
    });
  }

  Future<List<ExerciseData>> _fetchCategoryExercises(categoryId) async {
    final query = database.select(database.exercise)
      ..where((tbl) => tbl.categoryId.equals(categoryId))..where((tbl) => tbl.status.equals('created'));
    final categoryExerciseItems = query.map((row) => row).get();
    return categoryExerciseItems;
  }

  void _handleAddExercisesToRoutine(List<ExerciseData> selectedItems) async {
    for (int i = 0; i < selectedItems.length; i++) {
      await database.into(database.routineDetailItem).insert(
            RoutineDetailItemCompanion.insert(
              routineId: widget.routineId,
              exerciseId: selectedItems[i].id,
            ),
          );
    }
    _fetchRoutineDetailItems();
  }

  void _showExerciseBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return RoutineCategoryExerciseListingBottomSheet(
          exercises: _selectedCategoryExercises,
          selectedExercisesForRoutine: _routineDetailItems
              .where((element) =>
                  element.exercise!.categoryId == _selectedCategoryId)
              .map((e) => e.exercise)
              .toList(),
          handleSubmit: _handleAddExercisesToRoutine,
        );
      },
    );

    setState(() {
      _selectedCategoryExercises = [];
    });
  }

  void _handleBottomSheetCategoryItemClick(String categoryId) async {
    final List<ExerciseData> categoryExerciseItems =
        await _fetchCategoryExercises(categoryId);

    setState(() {
      _selectedCategoryId = categoryId;
      _selectedCategoryExercises = categoryExerciseItems;
    });

    _showExerciseBottomSheet(context);
  }

  void _showCustomBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return RoutineCategoryListingBottomSheet(
            categories: _categories,
            onCategoryClick: _handleBottomSheetCategoryItemClick);
      },
    );
  }

  void _handleRoutineDetailsItemDelete(String routineDetailItemId) {
    print(routineDetailItemId);
    (database.delete(database.routineDetailItem)
          ..where(
            (tbl) => tbl.id.equals(routineDetailItemId),
          ))
        .go();

    _fetchRoutineDetailItems();
  }

  @override
  void initState() {
    super.initState();
    _fetchRoutineDetailItems();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleTheme.primary,
        foregroundColor: Colors.white,
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
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            widget.routineName,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ..._routineDetailItems
                          .asMap()
                          .entries
                          .map(
                            (e) => Column(
                              children: [
                                RoutineDetailItemCard(
                                  name: e.value.exercise!.name,
                                  displayCta: true,
                                  onTap: () => {},
                                  onDelete: () =>
                                      _handleRoutineDetailsItemDelete(
                                          e.value.routineDetailItem.id),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          )
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
            _fetchCategories();
            _showCustomBottomSheet(context);
          }),
    );
  }
}
