import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/horizontal-date-selector/date_item.dart';
import 'package:pro_fit_flutter/util/date.dart';

class HorizontalDateSelector extends StatefulWidget {
  const HorizontalDateSelector({super.key});

  @override
  State<HorizontalDateSelector> createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  List<DateTime> _datesList = [];

  @override
  void initState() {
    super.initState();
    _datesList =
        getPrevious30Days(fromDate: DateTime.now(), includeFromDate: true);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _datesList.length,
      itemBuilder: (context, index) {
        return DateItem(
          dateObject: _datesList[index],
        );
      },
    );
  }
}
