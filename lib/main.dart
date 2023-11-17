import 'package:flutter/material.dart';

import 'Deals.dart';
import 'HomeScreen.dart';
import 'Profile.dart';
import 'WhisList.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF3E4095), // Główny kolor aplikacji
  hintColor: const Color(0xFF16275A), // Kolor akcentu
  secondaryHeaderColor: const Color(0xFF009688), // Kolor tła AppBar
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5F5F5)),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Kolor tła Scaffold
  shadowColor: Colors.grey, // Kolor cienia
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teleporting',
      theme: appTheme,
      home: const BottomNav(),
    );
  }
}

int sel = 0;
List<Widget> bodies = [const HomeScreen(), const WishList(), const Deals(), const Profile()];

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<BottomNavigationBarItem> createItems() {
    List<BottomNavigationBarItem> items = [];
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.search,
          color: appTheme.primaryColor,
        ),
        icon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        label: "Szukaj"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.favorite_border_outlined,
          color: appTheme.primaryColor,
        ),
        icon: const Icon(
          Icons.favorite_border_outlined,
          color: Colors.black,
        ),
        label: "Zapisane"));
    items.add(BottomNavigationBarItem(

        activeIcon: Icon(
          Icons.cases_outlined ,
          color: appTheme.primaryColor,
        ),
        icon: const Icon(
          Icons.cases_outlined ,
          color: Colors.black,
        ),
        label: "Rezerwacje"));
    items.add(BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.person_outline_outlined,
          color: appTheme.primaryColor,
        ),
        icon: const Icon(
          Icons.person_outline_outlined,
          color: Colors.black,
        ),
        label: "Profil"));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: (bodies.elementAt(sel))),
        bottomNavigationBar: BottomNavigationBar(
          items: createItems(),
          unselectedItemColor: Colors.black,
          selectedItemColor: appTheme.primaryColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          currentIndex: sel,
          elevation: 1.5,
          onTap: (int index) {
            if (index != sel) {
              setState(() {
                sel = index;
              });
            }
          },
        ));
  }
}