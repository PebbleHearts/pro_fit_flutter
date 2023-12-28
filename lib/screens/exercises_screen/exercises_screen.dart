import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/components/exercise-card/exercise_card.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
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
    final query = database.select(database.exercise)
      ..where(
        (tbl) => tbl.categoryId.equals(widget.categoryId),
      );
    final exerciseItems = query.map((row) => row).get();
    return exerciseItems;
  }

  void _fetchExercises() async {
    List<ExerciseData> exerciseItems = await _loadExercises();
    setState(() {
      _exercises = exerciseItems;
    });
  }

  void _handleExerciseBottomSheetSubmission(String exerciseName) async {
    WidgetsFlutterBinding.ensureInitialized();
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
        backgroundColor: purpleTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.deepPurple.withOpacity(0.1),
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
                            widget.categoryName,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ..._exercises
                          .asMap()
                          .entries
                          .map(
                            (e) => Column(
                              children: [
                                ExerciseCard(
                                  name: e.value.name,
                                  onTap: () => _handleExerciseCardClick(
                                      e.value.id, e.value.name),
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
            _showCustomBottomSheet(context);
          }),
    );
  }
}
