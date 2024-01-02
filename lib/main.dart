import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/nav/bottom_nav.dart';
import 'package:travel_app/pages/login/login_or_sign_up.dart';
import 'package:travel_app/pages/offers/offers_data.dart';
import 'db_methods/trips.dart';
import 'firebase_api.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (context) => MyState(),
      child: const MyApp(),
    ),
  );
}

ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF1E4232),
  hintColor: const Color(0xFF152C23),
  secondaryHeaderColor: const Color(0xFF347555),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5F5F5)),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  shadowColor: Colors.grey,
  indicatorColor: Colors.white,
  useMaterial3: true,

);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'VoyageVoyage',
        theme: appTheme,
        home: BottomNav(),
        routes: {
          "/login-or-signup": (context) => const LoginAndSignUp(),
        });
  }
}

class MyState extends ChangeNotifier {
  int _hotelOrApartment = 0;
  bool _isLoading = false;

  late List<Offer> _travelsList = [];

  int get hotelOrApartment => _hotelOrApartment;

  bool get isLoading => _isLoading;

  List<Offer> get travelsList => _travelsList;

  set hotelOrApartment(int value) {
    _hotelOrApartment = value;
    notifyListeners();
  }

  Future<void> setTravelsList(int value, country, city, personCount, startDate, endDate) async {
    try {
      _isLoading = true;
      var responseData = await getTravelsList(value, country, city, personCount, startDate, endDate);

      _travelsList = responseData;
      notifyListeners();
    } catch (error) {
      print('Błąd ładowania danych ofert: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
