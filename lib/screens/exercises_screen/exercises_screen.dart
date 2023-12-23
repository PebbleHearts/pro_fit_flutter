import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/exercise-card/exercise_card.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/exercises_screen/exercise_bottom_sheet.dart';

class ExercisesScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ExercisesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<ExerciseData> _exercises = [];

  Future<List<ExerciseData>> _loadExercises() async {
    final database = AppDatabase();
    final query = database.select(database.exercise)
      ..where(
        (tbl) => tbl.categoryId.equals(widget.categoryId),
      );
    final exerciseItems = query.map((row) => row).get();
    print(exerciseItems);
    return exerciseItems;
  }

  void _fetchExercises() async {
    List<ExerciseData> exerciseItems = await _loadExercises();
    print(exerciseItems);
    setState(() {
      _exercises = exerciseItems;
    });
  }

  void _handleExerciseBottomSheetSubmission(String exerciseName) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = AppDatabase();
    print('the id is : ${widget.categoryId}');
    await database.into(database.exercise).insert(
          ExerciseCompanion.insert(
            name: exerciseName,
            categoryId: widget.categoryId,
          ),
        );

    _fetchExercises();
  }

  void _showCustomBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ExerciseBottomSheet(
          handleSubmit: _handleExerciseBottomSheetSubmission,
        );
      },
    );
  }

  void _handleExerciseCardClick(String categoryId, String name) {}

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.deepPurple.withOpacity(0.1),
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    widget.categoryName,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ..._exercises
                  .asMap()
                  .entries
                  .map(
                    (e) => ExerciseCard(
                      name: e.value.name,
                      onTap: () =>
                          _handleExerciseCardClick(e.value.id, e.value.name),
                    ),
                  )
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
