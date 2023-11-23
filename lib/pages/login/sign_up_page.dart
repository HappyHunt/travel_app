import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/db_methods/user.dart';

import '../../main.dart';
import 'google-sign-in-button.dart';

class SignUp extends StatefulWidget {
  final void Function()? onPressed;

  const SignUp({super.key, required this.onPressed});

  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();

  createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredental = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

      addUser(userCredental.user!.uid, null, null, _usernameController.text, null, null);

    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Podaj mocniejsze hasło!")));
      } else if (e.code == 'email-already-in-use') {
        return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Konto już istnieje dla tego emaila!")));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejestracja', style: TextStyle(color: Colors.white)),
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
                const Color(0xF06BCC9B)
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
                          Center(
                            child: Image.network('https://firebasestorage.googleapis.com/v0/b/voyagevoyage-app.appspot.com/o/logo.png?alt=media&token=18b15c1b-c3bd-4d88-a92f-9050e2a50026',
                                height: 120, width: double.infinity),
                          ),
                          TextFormField(
                            controller: _usernameController,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Podaj email!";
                              }
                              return null;
                            },
                            style: TextStyle(color: appTheme.indicatorColor),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle:
                                  TextStyle(color: appTheme.indicatorColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: appTheme.indicatorColor),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return "Podaj hasło!";
                              }
                              return null;
                            },
                            style: TextStyle(color: appTheme.indicatorColor),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Hasło",
                              labelStyle:
                                  TextStyle(color: appTheme.indicatorColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: appTheme.indicatorColor),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _passwordConfirmationController,
                            validator: (text) {
                              if (text == null || text.isEmpty || text != _passwordController.text) {
                                return "Hasła nie są zgodne!";
                              }
                              return null;
                            },
                            style: TextStyle(color: appTheme.indicatorColor),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Powtórz hasło",
                              labelStyle:
                              TextStyle(color: appTheme.indicatorColor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: appTheme.indicatorColor),
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
                                  createUserWithEmailAndPassword();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
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
                                      'Zarejestruj',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: widget.onPressed,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Jesteś już naszym użytkownikiem? ",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Zaloguj się!",
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
