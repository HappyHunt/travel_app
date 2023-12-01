import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db_methods/trips.dart';
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
          title: const Center(
            child:Image(image: AssetImage('./assets/logo.png'))
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
            onTap: (int index) async {
              Provider.of<MyState>(context, listen: false).hotelOrApartment = index;
              Provider.of<MyState>(context, listen: false).setTravelsList(index, null, null, null, null, null);
            },
          ),
        ),
        body: const HomeSearchScreen(),
      ),
    );
  }
}
