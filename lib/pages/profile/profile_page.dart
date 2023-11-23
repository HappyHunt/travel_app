import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/main.dart';
import '../../db_methods/user.dart' as users;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String firstName = '';
  late String lastName= '';
  late String birthDate= '';
  late String email= '';
  late String phoneNumber= '';

  // Kontrolery dla pól tekstowych
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Tutaj dodaj kod do pobierania danych z bazy danych
    // Przykład użycia:
    var userData = await users.getUserData(FirebaseAuth.instance.currentUser?.uid);
    if (userData != null) {
      setState(() {
        firstName = userData['firstName'] ?? '';
        lastName = userData['lastName'] ?? '';
        birthDate = userData['birthDate'] ?? '';
        email = userData['email'] ?? '';
        phoneNumber = userData['phoneNumber'] ?? '';
      });
    }

    firstNameController.text = firstName;
    lastNameController.text = lastName;
    birthDateController.text = birthDate;
    emailController.text = email;
    phoneNumberController.text = phoneNumber;
  }

  void _openEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edytuj dane'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Imię', firstNameController),
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
              onPressed: () async {
                // Tutaj dodaj kod do zapisu zmienionych danych
                await _saveEditedData();
                Navigator.pop(context);
              },
              child: Text('Zapisz'),
            ),
          ],
        );
      },
    );
  }

// Funkcja do zapisu zmienionych danych
  Future<void> _saveEditedData() async {
    // Tutaj dodaj kod do aktualizacji danych w bazie danych
    // Przykład użycia:
    await users.updateUserData(
      FirebaseAuth.instance.currentUser?.uid,
      firstNameController.text,
      lastNameController.text,
      birthDateController.text,
      emailController.text,
      phoneNumberController.text,
    );

    // Przykładowy kod - do zastąpienia kodem aktualizującym w bazie danych
    setState(() {
      firstName = firstNameController.text;
      lastName = lastNameController.text;
      birthDate = birthDateController.text;
      email = emailController.text;
      phoneNumber = phoneNumberController.text;
    });
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
        title: Text('Cześć $firstName, oto Twój profil', style: TextStyle(color: Colors.white)),
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
                  color: Colors.white.withOpacity(0.95),
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      ListTile(
                        title: Text('Imię', style: TextStyle(fontSize: 13.0)),
                        subtitle: Text(firstName, style: TextStyle(fontSize: 18.0)),
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
