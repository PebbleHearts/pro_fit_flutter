import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateItem extends StatelessWidget {
  final DateTime dateObject;
  const DateItem({
    super.key,
    required this.dateObject,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEE').format(dateObject); // Weekday
    String formattedDay =
        DateFormat('d').format(dateObject); // Day of the month
    return Container(
      width: 50,
      height: 50,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            formattedDay,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
