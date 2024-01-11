import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/data-model/common.dart';
import 'package:pro_fit_flutter/components/routine-card/routine_card.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/routine_details_screen/routine_details_screen.dart';
import 'package:pro_fit_flutter/screens/routines_screen/routines_bottom_sheet.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  List<RoutineData> _routines = [];
  RoutineData? _editingRoutine;

  void _fetchRoutines() async {
    List<RoutineData> allRoutineItems =
        await database.routineDao.getAllRoutines();
    setState(() {
      _routines = allRoutineItems;
    });
  }

  void _handleRoutineBottomSheetSubmission(String routineName) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_editingRoutine != null) {
      database.routineDao.updateRoutine(
        RoutineCompanion(name: drift.Value(routineName)),
        _editingRoutine!.id,
      );
      setState(() {
        _editingRoutine = null;
      });
    } else {
      database.routineDao.createRoutine(routineName);
    }

    _fetchRoutines();
  }

  void _showCustomBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return RoutineBottomSheet(
          isEditing: _editingRoutine != null,
          editingRoutine: _editingRoutine,
          handleSubmit: _handleRoutineBottomSheetSubmission,
        );
      },
    );
    if (_editingRoutine != null) {
      setState(() {
        _editingRoutine = null;
      });
    }
  }

  void _handleRoutineCardClick(String routineId, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutineDetailsScreen(
          routineId: routineId,
          routineName: name,
        ),
      ),
    );
  }

  void _handleRoutineItemDelete(String routineId) {
    (database.delete(database.routine)
          ..where(
            (tbl) => tbl.id.equals(routineId),
          ))
        .go();
    _fetchRoutines();
  }

  void _handleRoutineItemEditClick(String routineId) {
    RoutineData item =
        _routines.firstWhere((element) => element.id == routineId);
    setState(() {
      _editingRoutine = item;
    });
    _showCustomBottomSheet(context);
  }

  @override
  void initState() {
    super.initState();
    _fetchRoutines();
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
                            'Routines',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ..._routines
                          .asMap()
                          .entries
                          .map((e) => Column(
                                children: [
                                  RoutineCard(
                                    name: e.value.name,
                                    onTap: () => _handleRoutineCardClick(
                                        e.value.id, e.value.name),
                                    onDelete: () =>
                                        _handleRoutineItemDelete(e.value.id),
                                    onEdit: () =>
                                        _handleRoutineItemEditClick(e.value.id),
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
