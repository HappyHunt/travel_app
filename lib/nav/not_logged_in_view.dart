import 'package:flutter/material.dart';
import 'package:travel_app/pages/login/login_page.dart';

import '../main.dart';

class NotLoggedInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [appTheme.secondaryHeaderColor, appTheme.scaffoldBackgroundColor],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Witaj w aplikacji VoyageVoyage!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Aby korzystać z pełnej funkcjonalności, zaloguj się!',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login-or-signup");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: appTheme.hintColor,
                    ),
                    child: Text(
                      'Zaloguj się',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: appTheme.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}