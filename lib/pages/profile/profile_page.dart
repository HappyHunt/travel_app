import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Przykładowe dane profilu
  String name = 'John';
  String lastName = 'Doe';
  String birthDate = '01-01-1990';
  String email = 'john.doe@example.com';
  String phoneNumber = '+1 123-456-7890';

  // Kontrolery dla pól tekstowych
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Przypisz wcześniejsze dane do kontrolerów
    nameController.text = name;
    lastNameController.text = lastName;
    birthDateController.text = birthDate;
    emailController.text = email;
    phoneNumberController.text = phoneNumber;
  }

  // Funkcja otwierająca okno dialogowe do edycji danych
  void _openEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edytuj dane'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Imię', nameController),
                _buildTextField('Nazwisko', lastNameController),
                _buildTextField('Data urodzenia', birthDateController),
                _buildTextField('E-mail', emailController),
                _buildTextField('Numer telefonu', phoneNumberController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                // Tutaj dodaj kod do zapisu zmienionych danych
                setState(() {
                  name = nameController.text;
                  lastName = lastNameController.text;
                  birthDate = birthDateController.text;
                  email = emailController.text;
                  phoneNumber = phoneNumberController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Zapisz'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cześć $name, oto Twój profil', style: TextStyle(color: Colors.white)),
        backgroundColor: appTheme.secondaryHeaderColor,
      ),
      body: Container(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [appTheme.secondaryHeaderColor, appTheme.scaffoldBackgroundColor],
            ),
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(30.0),
                  color: Colors.white.withOpacity(0.9),
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      ListTile(
                        title: Text('Imię', style: TextStyle(fontSize: 13.0)),
                        subtitle: Text(name, style: TextStyle(fontSize: 18.0)),
                      ),
                      ListTile(
                        title: Text('Nazwisko', style: TextStyle(fontSize: 13.0)),
                        subtitle: Text(lastName, style: TextStyle(fontSize: 18.0)),
                      ),
                      ListTile(
                        title: Text('Data urodzenia', style: TextStyle(fontSize: 13.0)),
                        subtitle: Text(birthDate, style: TextStyle(fontSize: 18.0)),
                      ),
                      ListTile(
                        title: Text('E-mail', style: TextStyle(fontSize: 13.0)),
                        subtitle: Text(email, style: TextStyle(fontSize: 18.0)),
                      ),
                      ListTile(
                        title: Text('Numer telefonu', style: TextStyle(fontSize: 13.0)),
                        subtitle: Text(phoneNumber, style: TextStyle(fontSize: 18.0)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _openEditProfileDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.secondaryHeaderColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text('Edytuj dane', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.secondaryHeaderColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text('Wyloguj', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
