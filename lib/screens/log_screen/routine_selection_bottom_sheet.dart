import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/bottom_sheet.dart';
import 'package:pro_fit_flutter/components/custom_elevated_button/custom_elevated_button.dart';
import 'package:pro_fit_flutter/components/routine-card/routine_card.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/database.dart';

class RoutineSelectionBottomSheet extends StatefulWidget {
  final List<RoutineData> routines;
  final ValueSetter<String> onRoutineStart;
  const RoutineSelectionBottomSheet({
    super.key,
    required this.onRoutineStart,
    required this.routines,
  });

  @override
  State<RoutineSelectionBottomSheet> createState() =>
      _RoutineSelectionBottomSheetState();
}

class _RoutineSelectionBottomSheetState
    extends State<RoutineSelectionBottomSheet> {
  String _selectedRoutineId = '';

  void _handleRoutineTap(String routineId) {
    setState(() {
      _selectedRoutineId = routineId;
    });
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
              'Select a Routine',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...widget.routines.asMap().entries.map(
              (e) {
                final isSelected = e.value.id == _selectedRoutineId;
                return Column(
                  children: [
                    RoutineCard(
                      name: e.value.name,
                      displayCta: false,
                      isSelected: isSelected,
                      onTap: () => _handleRoutineTap(e.value.id),
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              },
            ).toList(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: CustomElevatedButton(
                child: const Text('Execute'),
                onPressed: () {
                  widget.onRoutineStart(_selectedRoutineId);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
