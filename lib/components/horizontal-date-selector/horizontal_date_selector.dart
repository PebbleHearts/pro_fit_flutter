import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/components/horizontal-date-selector/date_item.dart';
import 'package:pro_fit_flutter/util/date.dart';

class HorizontalDateSelector extends StatefulWidget {
  final String selectedDate;
  const HorizontalDateSelector({super.key, required this.selectedDate});

  @override
  State<HorizontalDateSelector> createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  final _scrollController = ScrollController();
  List<DateTime> _datesList = [];
  double initialMaxScrollExtent = 0.0;

  void _loadMore() {
    final pixels = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final viewportDimension = _scrollController.position.viewportDimension;
    if (initialMaxScrollExtent == 0) {
      initialMaxScrollExtent = maxScrollExtent;
    }
    if (pixels >= maxScrollExtent) {
      List<DateTime> nextPreviousList = getPrevious30Days(
        fromDate: _datesList[_datesList.length - 1],
        includeFromDate: false,
      );
      setState(() {
        _datesList = [
          ..._datesList,
          ...nextPreviousList,
        ];
      });
    } else if (pixels <= 0) {
      List<DateTime> nextList = getNext30Days(
        fromDate: _datesList[0],
        includeFromDate: false,
      );
      setState(() {
        _datesList = [
          ...nextList,
          ..._datesList,
        ];
      });
      _scrollController.jumpTo(initialMaxScrollExtent + viewportDimension - 0.5);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _datesList =
        getPrevious30Days(fromDate: DateTime.now(), includeFromDate: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      scrollDirection: Axis.horizontal,
      itemCount: _datesList.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        return DateItem(
          dateObject: _datesList[index],
          selectedDate: widget.selectedDate,
        );
      },
    );
  }
}
