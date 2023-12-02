import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/db_methods/trips.dart';
import 'package:travel_app/pages/home/travel-list.dart';
import 'package:travel_app/pages/offers/offers_data.dart';

import '../../db_methods/countries_and_cities.dart';
import '../../main.dart';
import '../../models/model_countries.dart';
import 'app_bar.dart';
import 'calendar_marked.dart';

TextEditingController dateValueController = TextEditingController();
var db = FirebaseFirestore.instance;

String? selectedCountry;
String? selectedLocation;
DateTime? selectedStartDate;
DateTime? selectedEndDate;
var selectedPersonCount;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: AppBarHome()),
    );
  }
}

class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({Key? key}) : super(key: key);

  @override
  _HomeSearchScreenState createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  Map<String, List<String>> countriesMap = {};

  @override
  void initState() {
    super.initState();
    Provider.of<MyState>(context, listen: false)
        .setTravelsList(0, null, null, null, null, null);
    setCountries();
  }

  @override
  Widget build(BuildContext context) {
    int hotelOrApartment = Provider.of<MyState>(context).hotelOrApartment;
    final dataProvider = Provider.of<MyState>(context);
    List<Offer> travelsList = Provider.of<MyState>(context).travelsList;
    final ScrollController _scrollController = ScrollController();

    return Stack(children: [
      ListView(
        controller: _scrollController,
        children: [
          _buildContent(context, hotelOrApartment),
          dataProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TravelsListView(dataList: travelsList),
        ],
      ),
      Positioned(
        bottom: 16.0,
        right: 16.0,
        child: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          backgroundColor: appTheme.scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(
            Icons.keyboard_arrow_up,
            color: Colors.black,
          ),
        ),
      ),
    ]);
  }

  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.38,
            child: CalendarWidget(),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 50.0), // wewnętrzny padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // zaokrąglenie narożników
                  ),
                  backgroundColor: appTheme.secondaryHeaderColor,
                ),
                child: const Text(
                  'Wybierz',
                  style: TextStyle(
                    fontSize: 16.0, // rozmiar czcionki
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, int hotelOrApartment) {
    final CollectionReference countriesCollection =
        FirebaseFirestore.instance.collection('trips');

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 70.0,
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'Kraj',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text('Kraj'),
                  value: selectedCountry,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCountry = newValue;
                      selectedLocation = null;
                    });
                  },
                  items: countriesMap.keys.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          hotelOrApartment == 0
              ? Column(
                  children: [
                    SizedBox(
                      height: 70.0,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          hintText: 'Miejscowość',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text('Miejscowość'),
                            value: selectedLocation,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedLocation = newValue;
                              });
                            },
                            items: countriesMap[selectedCountry]
                                ?.map((String location) {
                              return DropdownMenuItem<String>(
                                value: location,
                                child: Text(location),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              : const SizedBox(height: 0),
          TextField(
            decoration: InputDecoration(
              hintText: 'Liczba osób',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (var newValue) {
              setState(() {
                selectedPersonCount = newValue;
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: dateValueController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Data',
              prefixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onTap: () {
              _showCalendarDialog(context);
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: double.infinity, // przycisk na całą szerokość
              child: ElevatedButton(
                onPressed: () async {
                  print(
                      "Wyszukaj:  ${selectedCountry} , ${selectedLocation} , ${selectedStartDate} , ${selectedEndDate} , ${selectedPersonCount}");
                  Provider.of<MyState>(context, listen: false).setTravelsList(
                      hotelOrApartment,
                      selectedCountry,
                      selectedLocation,
                      selectedPersonCount,
                      selectedStartDate,
                      selectedEndDate);
                  setCountries();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // wewnętrzny padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: appTheme.secondaryHeaderColor,
                ),
                child: const Text(
                  'Wyszukaj',
                  style: TextStyle(
                    fontSize: 18.0, // rozmiar czcionki
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> setCountries() async {
    var countriesData = await getCountryList();

    for (var country in countriesData) {
      countriesMap[country.name] = country.cities;
    }
  }
}
