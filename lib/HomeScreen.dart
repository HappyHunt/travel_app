import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'main.dart';

List<String> categories = <String>['Domy', 'Hotele'];
TextEditingController _dateValueController = TextEditingController();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppBarHome()),
    );
  }
}

class AppBarHome extends StatelessWidget {
  const AppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: categories.length,
        child: Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text(
                  'VoyageVoyage',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold, // Add bold style
                    color: Colors.white, // Text color
                  ),
                ),
              ),
              scrolledUnderElevation: 4.0,
              shadowColor: Theme.of(context).shadowColor,
              backgroundColor: appTheme.secondaryHeaderColor,
              bottom: TabBar(
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                labelColor: appTheme.scaffoldBackgroundColor,
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                indicatorColor: appTheme.scaffoldBackgroundColor,
                tabs: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    // Dodaj padding na lewo i prawo
                    child: Container(
                      decoration: BoxDecoration(
                        color: appTheme.highlightColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Tab(
                        icon: const Icon(Icons.home_filled, size: 24),
                        text: categories[0],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    // Dodaj padding na lewo i prawo
                    child: Container(
                      decoration: BoxDecoration(
                        color: appTheme.highlightColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Tab(
                        icon: const Icon(Icons.hotel_rounded, size: 24),
                        text: categories[1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SearchScreen()));
  }
}

class SearchScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Miejscowość',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 22),
            TextField(
              decoration: InputDecoration(
                hintText: 'Liczba osób',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 22),
            TextFormField(
              controller: _dateValueController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Data',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onTap: () {
                _showCalendarDialog(context);
              },
            ),
            SizedBox(height: 22),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Tutaj dodaj kod do obsługi przycisku wyszukiwania
                },
                child: Text('Wyszukaj'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            // Maksymalna szerokość
            height: MediaQuery.of(context).size.height * 0.4,
            // Maksymalna wysokość // Ustaw wysokość kontenera, dostosuj do potrzeb
            child: CalendarWidget(),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Wybierz'),
              ),
            ),
          ],
        );
      },
    );
  }
}

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
      // Zmiana koloru nazw dni na zielony
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
      firstDayOfWeek: 1
    );
  }

  void _handleDateSelection(DateTime date) {
    if (_rangeStartDate.isAfter(date) || _rangeStartDate == date) {
      setState(() {
        _rangeStartDate = date;
        _rangeEndDate = date;
      });
    } else if (_rangeStartDate.isBefore(date) && _rangeEndDate.isAfter(date)){
      setState(() {
        _rangeStartDate = date;
      });
    }
    else {
      setState(() {
        _rangeEndDate = date;
      });
    }
    _dateValueController.text = "${_rangeStartDate.year}.${_rangeStartDate.month}.${_rangeStartDate.day} - ${_rangeEndDate.year}.${_rangeEndDate.month}.${_rangeEndDate.day}";
  }

  EventList<Event> _generateMarkedDates() {
    // Clear existing marked dates
    _markedDateMap.clear();

    // Mark dates between _rangeStartDate and _rangeEndDate
    DateTime currentDate = _rangeStartDate;
    while (currentDate.isBefore(_rangeEndDate) ||
        currentDate.isAtSameMomentAs(_rangeEndDate)) {
      _markedDateMap.add(
        currentDate,
        Event(
          date: currentDate,
          icon: Container(
            decoration: const BoxDecoration(
              color: Colors.blue, // Adjust the color as needed
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
