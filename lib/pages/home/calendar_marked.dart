import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../../main.dart';
import 'home_page.dart';


class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currDate;
  late DateTime _rangeStartDate;
  late DateTime _rangeEndDate;
  late EventList<Event> _markedDateMap;

  @override
  void initState() {
    super.initState();
    _currDate = DateTime.now();
    _rangeStartDate = DateTime(3000);
    _rangeEndDate = DateTime(3000);
    _markedDateMap = EventList<Event>(events: {});
  }

  @override
  Widget build(BuildContext context) {
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        _handleDateSelection(date);
      },
      weekdayTextStyle: TextStyle(color: appTheme.secondaryHeaderColor),
      weekendTextStyle: const TextStyle(color: Colors.red),
      weekFormat: false,
      markedDatesMap: _generateMarkedDates(),
      todayButtonColor: appTheme.secondaryHeaderColor,
      todayBorderColor: appTheme.secondaryHeaderColor,
      minSelectedDate: _currDate,
      markedDateCustomShapeBorder: const CircleBorder(
        side: BorderSide(color: Colors.blue, width: 2.0),
      ),
      daysHaveCircularBorder: true,
      firstDayOfWeek: 1,
    );
  }

  void _handleDateSelection(DateTime date) {
    if (_rangeStartDate.isAfter(date) || _rangeStartDate == date) {
      setState(() {
        _rangeStartDate = date;
        _rangeEndDate = date;
      });
    } else if (_rangeStartDate.isBefore(date) && _rangeEndDate.isAfter(date)) {
      setState(() {
        _rangeStartDate = date;
      });
    } else {
      setState(() {
        _rangeEndDate = date;
      });
    }
    dateValueController.text =
    "${_rangeStartDate.day}.${_rangeStartDate.month}.${_rangeStartDate.year}  -"
        "  ${_rangeEndDate.day}.${_rangeEndDate.month}.${_rangeEndDate.year}";
    selectedStartDate = _rangeStartDate;
    selectedEndDate = _rangeEndDate;
  }

  EventList<Event> _generateMarkedDates() {
    _markedDateMap.clear();

    DateTime currentDate = _rangeStartDate;
    while (currentDate.isBefore(_rangeEndDate) ||
        currentDate.isAtSameMomentAs(_rangeEndDate)) {
      _markedDateMap.add(
        currentDate,
        Event(
          date: currentDate,
          icon: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return _markedDateMap;
  }
}