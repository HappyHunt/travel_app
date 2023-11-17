import 'package:flutter/material.dart';

import '../main.dart';
import '../pages/deals/deals_page.dart';
import '../pages/home/home_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/wishlist/wishlist_page.dart';

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
        label: "Obserwowane"));
    items.add(BottomNavigationBarItem(

        activeIcon: Icon(
          Icons.cases_outlined,
          color: appTheme.primaryColor,
        ),
        icon: const Icon(
          Icons.cases_outlined,
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