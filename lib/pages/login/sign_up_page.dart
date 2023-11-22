import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

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

  createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);
      setState(() {
        isLoading = false;
      });
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
        backgroundColor: appTheme.primaryColor,
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
                child: OverflowBar(
                  overflowSpacing: 20,
                  children: [
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
                        labelStyle: TextStyle(color: appTheme.indicatorColor),
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
                      decoration: InputDecoration(
                        labelText: "Hasło",
                        labelStyle: TextStyle(color: appTheme.indicatorColor),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: appTheme.indicatorColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print("Walidacja udana!");
                            createUserWithEmailAndPassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: appTheme.primaryColor,
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Zarejestruj',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: widget.onPressed,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: appTheme.primaryColor,
                        ),
                        child: const Text(
                          'Zaloguj',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
