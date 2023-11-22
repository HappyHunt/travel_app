import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/main.dart';

import 'google-sign-in-button.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onPressed;

  const LoginPage({super.key, required this.onPressed});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, "/nav");
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code != null) {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Błędny email lub hasło!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logowanie',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appTheme.secondaryHeaderColor,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                appTheme.secondaryHeaderColor,
                appTheme.dialogBackgroundColor
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OverflowBar(
                        overflowSpacing: 20,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            style: TextStyle(color: appTheme.indicatorColor),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Podaj email!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: appTheme.indicatorColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: appTheme.indicatorColor),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(color: appTheme.indicatorColor),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Podaj hasło!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Hasło",
                              labelStyle: TextStyle(color: appTheme.indicatorColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: appTheme.indicatorColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print("Walidacja udana!");
                                  signInWithEmailAndPassword();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0), // wewnętrzny padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30.0), // zaokrąglenie narożników
                                ),
                                backgroundColor: appTheme.indicatorColor,
                              ),
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text(
                                      'Zaloguj',
                                      style: TextStyle(
                                        fontSize: 18.0, // rozmiar czcionki
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Add space between login button and register text
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: const Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("lub skorzystaj z"),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: const Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Add space between register button and continue text
                      SizedBox(
                        width: double.infinity,
                        child: GoogleSignInButton(),
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: widget.onPressed,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Nie masz jeszcze konta? ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Zarejestruj się!",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
