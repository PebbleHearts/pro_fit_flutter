import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/components/category-card/category_card.dart';
import 'package:pro_fit_flutter/database/converters.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/daily_exercise_selection_screen/exercise_selection_bottom_sheet.dart';

class DailyExerciseSelectionScreen extends StatefulWidget {
  final String selectedDate;
  const DailyExerciseSelectionScreen({super.key, required this.selectedDate});

  @override
  State<DailyExerciseSelectionScreen> createState() =>
      _DailyExerciseSelectionScreenState();
}

class _DailyExerciseSelectionScreenState
    extends State<DailyExerciseSelectionScreen> {
  List<CategoryData> _categories = [];
  List<ExerciseData> _selectedCategoryExercises = [];
  List<ExerciseData> _selectedExercisesForTheDay = [];

  Future<List<CategoryData>> _loadCategories() async {
    List<CategoryData> allCategoryItems =
        await database.select(database.category).get();
    return allCategoryItems;
  }

  void _fetchCategories() async {
    List<CategoryData> allCategoryItems = await _loadCategories();
    setState(() {
      _categories = allCategoryItems;
    });
  }

  Future<List<ExerciseData>> _fetchCategoryExercises(categoryId) async {
    final query = database.select(database.exercise)
      ..where((tbl) => tbl.categoryId.equals(categoryId));
    final categoryExerciseItems = query.map((row) => row).get();
    return categoryExerciseItems;
  }

  void _handleCategoryCardClick(id, name) async {
    final List<ExerciseData> categoryExerciseItems =
        await _fetchCategoryExercises(id);
    setState(() {
      _selectedCategoryExercises = categoryExerciseItems;
    });
    _showCustomBottomSheet(context);
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _showCustomBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ExerciseSelectionBottomSheet(
          categoryExercises: _selectedCategoryExercises,
          onAddClick: (value) {
            setState(() {
              _selectedExercisesForTheDay = value;
            });
          },
        );
      },
    );
    setState(() {
      _selectedCategoryExercises = [];
    });
  }

  void _handleWorkoutLogBottomSheetSubmission() async {
    WidgetsFlutterBinding.ensureInitialized();

    await database.into(database.exerciseLog).insert(
          ExerciseLogCompanion.insert(
            exerciseId: _selectedExercisesForTheDay[0].id,
            logDate: widget.selectedDate,
            description: "some description 2",
            workoutRecords:
                WorkoutRecord([WorkoutSet(10, 8), WorkoutSet(10, 12)]),
            order: 4,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.deepPurple.withOpacity(0.1),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'Choose Exercises',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ..._categories
                          .asMap()
                          .entries
                          .map(
                            (e) => CategoryCard(
                              name: e.value.name,
                              onTap: () => _handleCategoryCardClick(
                                  e.value.id, e.value.name),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.deepPurple.withOpacity(0.1),
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.deepPurple),
                    overlayColor:
                        MaterialStatePropertyAll(Colors.deepPurpleAccent)),
                child: const Text('Add'),
                onPressed: _handleWorkoutLogBottomSheetSubmission,
              ),
            ),
          )
        ],
      ),
    );
  }
}
