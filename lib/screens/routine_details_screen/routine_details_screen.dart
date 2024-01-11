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

  void _fetchRoutineDetailItems() async {
    List<RoutineDetailItemWithExercise> routineDetailItems = await database
        .routineDetailItemDao
        .getRoutineDetailItems(widget.routineId);
    setState(() {
      _routineDetailItems = routineDetailItems;
    });
  }

  void _fetchCategories() async {
    List<CategoryData> allCategoryItems =
        await database.categoryDao.getAllCategories();
    print(allCategoryItems);
    setState(() {
      _categories = allCategoryItems;
    });
  }

  void _handleAddExercisesToRoutine(List<ExerciseData> selectedItems) async {
    for (int i = 0; i < selectedItems.length; i++) {
      await database.routineDetailItemDao
          .createRoutineDetailItem(widget.routineId, selectedItems[i].id);
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
        await database.exerciseDao.getCategoryExercises(categoryId);

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
    database.routineDetailItemDao.deleteRoutineDetailItem(routineDetailItemId);
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
