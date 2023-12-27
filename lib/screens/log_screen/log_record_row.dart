import 'package:pro_fit_flutter/components/custom-text-field/custom_text_field.dart';
import 'package:flutter/material.dart';

typedef OnChangeFunction = void Function(int index, String param1, String param2);

class LogRecordRow extends StatefulWidget {
  final int index;
  final double weight;
  final int repetitions;
  final OnChangeFunction onChange;
  const LogRecordRow({
    super.key,
    required this.index,
    required this.weight,
    required this.repetitions,
    required this.onChange,
  });

  @override
  State<LogRecordRow> createState() => _LogRecordRowState();
}

class _LogRecordRowState extends State<LogRecordRow> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.text = '${widget.weight}';
    _repetitionsController.text = '${widget.repetitions}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Set ${widget.index + 1}'),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
            controller: _weightController,
            onChanged: (text) => widget.onChange(widget.index, 'weight' , text),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
            controller: _repetitionsController,
            onChanged: (text) => widget.onChange(widget.index ,'repetitions', text),
          ),
        ),
      ],
    );
  }
}
