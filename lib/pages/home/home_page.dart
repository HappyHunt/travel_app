import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import '../../main.dart';

List<String> categories = ['Hotele', 'Apartamenty'];
TextEditingController _dateValueController = TextEditingController();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: AppBarHome()),
    );
  }
}

class AppBarHome extends StatelessWidget {
  const AppBarHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 2.0, bottom: 10.0),
              child: Text(
                'VoyageVoyage',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          backgroundColor: appTheme.secondaryHeaderColor,
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            labelColor: appTheme.scaffoldBackgroundColor,
            unselectedLabelStyle: TextStyle(fontSize: 16),
            indicatorColor: appTheme.scaffoldBackgroundColor,
            tabs: categories.map((String category) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: appTheme.highlightColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Tab(
                    icon: category == 'Hotele'
                        ? Icon(Icons.hotel_rounded, size: 24)
                        : Icon(Icons.home_filled, size: 24),
                    text: category,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        body: const HomeSearchScreen(),
      ),
    );
  }
}

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({Key? key}) : super(key: key);

  @override
  _HomeSearchScreenState createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  String? selectedCountry;
  String? selectedLocation;
  String? selectedMealType; // Nowa zmienna dla zakładki Hotele
  String? selectedApartmentSize; // Nowa zmienna dla zakładki Apartamenty
  String? hotelOrApartment; // Nowa zmienna do wyboru między Hotele a Apartamenty

  Map<String, List<String>> locationsData = {
    'Francja': ['Nicea', 'Cannes'],
    'Meksyk': ['Meksyk City', 'Playa del Carmen'],
    'Polska': ['Władysławowo', 'Rokietniki górne'],
  };

  List<String> mealTypes = ['Bez wyżywienia', 'BB', 'HB', 'AI']; // Nowa lista dla zakładki Hotele
  List<String> apartmentSizes = ['0-35m2', '36-50m2', '50m2 i więcej']; // Nowa lista dla zakładki Apartamenty

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                hintText: 'Hotele czy Apartamenty',
                prefixIcon: Icon(Icons.hotel),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Hotele czy Apartamenty'),
                  value: hotelOrApartment,
                  onChanged: (String? newValue) {
                    setState(() {
                      hotelOrApartment = newValue;
                      selectedCountry = null;
                      selectedLocation = null;
                      selectedMealType = null;
                      selectedApartmentSize = null;
                    });
                  },
                  items: categories.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(
                hintText: 'Kraj',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Kraj'),
                  value: selectedCountry,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCountry = newValue;
                      selectedLocation = null;
                    });
                  },
                  items: locationsData.keys.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(
                hintText: 'Miejscowość',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Miejscowość'),
                  value: selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLocation = newValue;
                    });
                  },
                  items: locationsData[selectedCountry]?.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            if (hotelOrApartment == 'Hotele') ...[
              InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Rodzaj wyżywienia',
                  prefixIcon: Icon(Icons.restaurant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text('Rodzaj wyżywienia'),
                    value: selectedMealType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMealType = newValue;
                      });
                    },
                    items: mealTypes.map((String mealType) {
                      return DropdownMenuItem<String>(
                        value: mealType,
                        child: Text(mealType),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ] else if (hotelOrApartment == 'Apartamenty') ...[
              InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Metraż',
                  prefixIcon: Icon(Icons.aspect_ratio),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text('Metraż'),
                    value: selectedApartmentSize,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedApartmentSize = newValue;
                      });
                    },
                    items: apartmentSizes.map((String size) {
                      return DropdownMenuItem<String>(
                        value: size,
                        child: Text(size),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
            SizedBox(height: 20),
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
            height: MediaQuery.of(context).size.height * 0.3,
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
    _dateValueController.text =
    "${_rangeStartDate.day}.${_rangeStartDate.month}.${_rangeStartDate.year}  -"
        "  ${_rangeEndDate.day}.${_rangeEndDate.month}.${_rangeEndDate.year}";
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
