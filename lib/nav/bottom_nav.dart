import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../pages/Reservations/reservations_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/wishlist/wishlist_page.dart';
import 'not_logged_in_view.dart';

int sel = 0;
List<Widget> bodies = [const HomeScreen(), const WishList(), const Reservations(), const Profile()];

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late BuildContext context;

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
      label: "Szukaj",
    ));
    items.add(BottomNavigationBarItem(
      activeIcon: Icon(
        Icons.favorite_border_outlined,
        color: appTheme.primaryColor,
      ),
      icon: const Icon(
        Icons.favorite_border_outlined,
        color: Colors.black,
      ),
      label: "Obserwowane",
    ));
    items.add(BottomNavigationBarItem(
      activeIcon: Icon(
        Icons.cases_outlined,
        color: appTheme.primaryColor,
      ),
      icon: const Icon(
        Icons.cases_outlined,
        color: Colors.black,
      ),
      label: "Rezerwacje",
    ));
    items.add(BottomNavigationBarItem(
      activeIcon: Icon(
        Icons.person_outline_outlined,
        color: appTheme.primaryColor,
      ),
      icon: const Icon(
        Icons.person_outline_outlined,
        color: Colors.black,
      ),
      label: "Profil",
    ));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    context = context;

    return Scaffold(
      // body: Center(child: (bodies.elementAt(sel))),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }else{
                return snapshot.hasData || sel == 0 ? bodies.elementAt(sel) : NotLoggedInView();
            }
          }
      ),
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
          // obsługa zmiany zakładek
          if (index != sel) {
            setState(() {
              sel = index;
            });
          }
        },
      ),
    );
  }
}