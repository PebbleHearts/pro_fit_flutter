import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/screens/history_screen/record_item.dart';

class HistoryItem extends StatelessWidget {
  final HistoryItemDataModel historyData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const HistoryItem({
    super.key,
    required this.historyData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(historyData.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: onEdit,
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        )),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...historyData.records.asMap().entries.map(
                (e) => RecordItem(
                    index: e.key,
                    data: e.value,
                    showDivider: e.key != historyData.records.length - 1),
              )
        ],
      ),
    );
  }
}
