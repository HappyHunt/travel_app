import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'home_page.dart';

List<String> categories = ['Hotele', 'Apartamenty'];

class AppBarHome extends StatefulWidget {
  @override
  _AppBarHomeState createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.login)),
          ],
          title: Center(
            child: Image.asset('assets/logo.jpg',
                height: 120, width: double.infinity),
          ),
          toolbarHeight: 120.0,
          scrolledUnderElevation: 20.0,
          shadowColor: Theme.of(context).shadowColor,
          backgroundColor: appTheme.secondaryHeaderColor,
          bottom: TabBar(
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            labelColor: appTheme.scaffoldBackgroundColor,
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            indicatorColor: appTheme.scaffoldBackgroundColor,
            tabs: categories.map((String category) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                //podkreślnik
                child: Container(
                  decoration: BoxDecoration(
                    color: appTheme.highlightColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //ikonki hotel itp
                  width: 130.0,
                  child: Tab(
                    icon: category == 'Hotele'
                        ? const Icon(Icons.hotel_rounded, size: 24)
                        : const Icon(Icons.home_filled, size: 24),
                    text: category,
                  ),
                ),
              );
            }).toList(),
            onTap: (int index) {
              setState(() {
                hotelOrApartment = index;

              });
            },
          ),
        ),
        body: const HomeSearchScreen(),
      ),
    );
  }
}
