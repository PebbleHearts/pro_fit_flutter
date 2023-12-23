import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/database/converters.dart';

class RecordItem extends StatelessWidget {
  final int index;
  final WorkoutSet data;
  final bool showDivider;
  const RecordItem(
      {super.key,
      required this.index,
      required this.data,
      required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Set ${index + 1}')),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${data.weight}Kg"),
                    Text("Reps: ${data.repetitions}"),
                  ],
                ),
              )
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          )
      ],
    );
  }
}
