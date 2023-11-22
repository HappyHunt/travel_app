import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'home_page.dart';

List<String> categories = ['Wypoczynek', 'Objazdówki'];

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
          title: Center(
            child: Image.network('https://firebasestorage.googleapis.com/v0/b/voyagevoyage-app.appspot.com/o/logo.png?alt=media&token=18b15c1b-c3bd-4d88-a92f-9050e2a50026',
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
                    icon: category == 'Wypoczynek'
                        ? const Icon(Icons.beach_access, size: 24)
                        : const Icon(Icons.travel_explore, size: 24),
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
