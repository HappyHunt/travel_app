import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    try {
      setState(() {
        _isSigningIn = true;
      });
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _isSigningIn = false;
      });
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isSigningIn = false;
      });
      if (e.code != null) {
        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logowanie nie udane!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            signInWithGoogle();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                vertical: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(30.0), // zaokrąglenie narożników
            ),
            backgroundColor: appTheme.indicatorColor,
          ),
          child: _isSigningIn
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 35.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Zaloguj z Google',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
