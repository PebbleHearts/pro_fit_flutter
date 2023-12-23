import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateItem extends StatelessWidget {
  final DateTime dateObject;
  final String selectedDate;
  const DateItem({
    super.key,
    required this.dateObject,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    String formattedMonth = DateFormat('MM').format(dateObject);
    String formattedYear = DateFormat('yyyy').format(dateObject);
    String formattedDate = DateFormat('EEE').format(dateObject);
    String formattedDay = DateFormat('d').format(dateObject);
    String formattedDateString = DateFormat('dd-MM-yyyy').format(dateObject);

    bool isDateSelected = formattedDateString == selectedDate;

    return Container(
      width: 50,
      height: 50,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                formattedYear,
                style: TextStyle(fontSize: 7, color: isDateSelected ? Colors.black : Colors.grey,),
              ),
              const SizedBox(width: 5,),
              Text(
                formattedMonth,
                style: TextStyle(fontSize: 7, color: isDateSelected ? Colors.black : Colors.grey,),
              ),
            ],
          ),
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
    );
  }
}
