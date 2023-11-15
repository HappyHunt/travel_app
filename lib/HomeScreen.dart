import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

List<String> categories = <String> [
  'Domy',
  'Hotele'
];


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppBarHome()),
    );
  }
}

class AppBarHome extends StatelessWidget{
  const AppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: categories.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Travel App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold, // Add bold style
                  color: Colors.white, // Text color
                ),
              ),
            ),
            scrolledUnderElevation: 4.0,
            shadowColor: Theme.of(context).shadowColor,
            backgroundColor: appTheme.secondaryHeaderColor,
            bottom: TabBar(
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              labelColor: appTheme.scaffoldBackgroundColor,
              unselectedLabelStyle: const TextStyle(fontSize: 16),
              indicatorColor: appTheme.scaffoldBackgroundColor,
              tabs: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0), // Dodaj padding na lewo i prawo
                  child: Container(
                    decoration: BoxDecoration(
                      color: appTheme.highlightColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Tab(
                      icon: const Icon(Icons.home_filled, size: 24),
                      text: categories[0],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0), // Dodaj padding na lewo i prawo
                  child: Container(
                    decoration: BoxDecoration(
                      color: appTheme.highlightColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Tab(
                      icon: const Icon(Icons.hotel_rounded, size: 24),
                      text: categories[1],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: const Center(
            child: Text(
              'This is the home page',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ));
  }
}
