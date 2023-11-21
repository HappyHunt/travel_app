import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

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
        title: const Text('Mój profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/profil.jpg'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ListTile(
                    title: Text('Imię'),
                    subtitle: Text(name),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('Nazwisko'),
                    subtitle: Text(lastName),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('Data urodzenia'),
                    subtitle: Text(birthDate),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('E-mail'),
                    subtitle: Text(email),
                    dense: true,
                  ),
                  ListTile(
                    title: Text('Numer telefonu'),
                    subtitle: Text(phoneNumber),
                    dense: true,
                  ),
                ],
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
          ],
        ),
      ),
    );
  }
}
