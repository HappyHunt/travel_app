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
  late String lastName = '';
  late String birthDate = '';
  late String email = '';
  late String phoneNumber = '';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = _loadData();
  }

  Future<void> _loadData() async {
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
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () async {
                await _saveEditedData();
                Navigator.pop(context);
              },
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );
  }

  // Funkcja do zapisu zmienionych danych
  Future<void> _saveEditedData() async {
    await users.updateUserData(
      FirebaseAuth.instance.currentUser?.uid,
      firstNameController.text,
      lastNameController.text,
      birthDateController.text,
      emailController.text,
      phoneNumberController.text,
    );

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
          child: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.all(30.0),
                        color: Colors.white.withOpacity(0.95),
                        child: ListView(
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            ListTile(
                              title: const Text('Imię', style: TextStyle(fontSize: 13.0)),
                              subtitle: Text(firstName, style: const TextStyle(fontSize: 18.0)),
                            ),
                            ListTile(
                              title: const Text('Nazwisko', style: TextStyle(fontSize: 13.0)),
                              subtitle: Text(lastName, style: const TextStyle(fontSize: 18.0)),
                            ),
                            ListTile(
                              title: const Text('Data urodzenia', style: TextStyle(fontSize: 13.0)),
                              subtitle: Text(birthDate, style: const TextStyle(fontSize: 18.0)),
                            ),
                            ListTile(
                              title: const Text('E-mail', style: TextStyle(fontSize: 13.0)),
                              subtitle: Text(email, style: const TextStyle(fontSize: 18.0)),
                            ),
                            ListTile(
                              title: const Text('Numer telefonu', style: TextStyle(fontSize: 13.0)),
                              subtitle: Text(phoneNumber, style: const TextStyle(fontSize: 18.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          child: const Text('Edytuj dane', style: TextStyle(color: Colors.white)),
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
                          child: const Text('Wyloguj', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
