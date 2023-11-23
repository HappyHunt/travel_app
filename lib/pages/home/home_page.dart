import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/db_methods/trips.dart';
import 'package:travel_app/pages/offers/offers_data.dart';

import '../../main.dart';
import 'app_bar.dart';
import 'calendar_marked.dart';

TextEditingController dateValueController = TextEditingController();
var db = FirebaseFirestore.instance;

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
  String? selectedCountry;
  String? selectedLocation;

  Map<String, List<String>> locationsData = {
    'Francja': ['Nicea', 'Cannes'],
    'Meksyk': ['Meksyk City', 'Playa del Carmen'],
    'Polska': ['Władysławowo', 'Rokietniki górne'],
  };
  late Future<List<Offer>> travelsListFuture;


  @override
  void initState() {
    super.initState();
    travelsListFuture = getTravelsList(0);
    print("Init: $travelsListFuture");
  }

  @override
  Widget build(BuildContext context) {
    int hotelOrApartment = Provider.of<MyState>(context).hotelOrApartment;
    List<Offer> travelsList = Provider.of<MyState>(context).travelsList;

    return FutureBuilder<List<Offer>>(
        future: travelsListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Wystąpił błąd: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Brak dostępnych danych.');
          }else {
            return _buildContent(context, travelsList, hotelOrApartment);
          }
        });
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

  Widget _buildContent(BuildContext context, List<Offer> travelsList, int hotelOrApartment) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
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
                    items: locationsData.keys.map((String country) {
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
                        items: locationsData[selectedCountry]
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    // wewnętrzny padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30.0),
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
            Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                itemCount: travelsList.length,
                itemBuilder: (context, index) {
                  Offer offer = travelsList[index];
                  return Text(offer.title);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
