import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateItem extends StatelessWidget {
  final DateTime dateObject;
  final String selectedDate;
  final ValueSetter<DateTime> onDateTap;
  const DateItem({
    super.key,
    required this.dateObject,
    required this.selectedDate,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    String formattedMonth = DateFormat('MM').format(dateObject);
    String formattedYear = DateFormat('yyyy').format(dateObject);
    String formattedDate = DateFormat('EEE').format(dateObject);
    String formattedDay = DateFormat('d').format(dateObject);
    String formattedDateString = DateFormat('dd-MM-yyyy').format(dateObject);

    bool isDateSelected = formattedDateString == selectedDate;

    return InkWell(
      onTap: () => onDateTap(dateObject),
      child: Container(
        width: 50,
        height: 50,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: isDateSelected ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              formattedDay,
              style: TextStyle(
                fontSize: 12,
                color: isDateSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
