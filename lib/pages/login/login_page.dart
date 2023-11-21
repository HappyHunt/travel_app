import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onPressed;
  const LoginPage({super.key,required this.onPressed});

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
          email: _usernameController.text,
          password: _passwordController.text
      );
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
            const SnackBar(content: Text("Błędny email lub hasło!"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('VoyageVoyage Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: OverflowBar(
              overflowSpacing: 20,
              children: [
                TextFormField(
                  controller: _usernameController,
                  validator: (text){
                    if (text == null || text.isEmpty){
                      return "Podaj email!";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (text){
                    if (text == null || text.isEmpty){
                      return "Podaj hasło!";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: "Hasło"),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                        if (_formKey.currentState!.validate()){
                          print("Walidacja udana!");
                          signInWithEmailAndPassword();
                        }
                    },
                    child: isLoading
                      ?const Center(child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                      :const Text("Zaloguj")
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: widget.onPressed,
                      child: const Text("Zarejestruj")
                  ),
                )
              ],
            )
          )
        ),
      ),
    );
  }
}