import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/nav/not_logged_in_view.dart';

import '../auth/auth.dart';
import '../main.dart';
import '../pages/deals/deals_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/wishlist/wishlist_page.dart';

int sel = 0;
List<Widget> bodies = [const HomeScreen(), const WishList(), const Deals(), const Profile()];

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
      // body: Center(
      //   child: Consumer<AuthProvider>(
      //     builder: (context, authProvider, child) {
      //       bool isLoggedIn = authProvider.isLoggedIn;
      //       print(isLoggedIn);
      //       return isLoggedIn || sel == 0 ? bodies.elementAt(sel) : NotLoggedInView();
      //     },
      //   ),
      // ),
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