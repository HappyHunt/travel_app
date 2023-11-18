import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://example.com/path-to-your-profile-image.jpg'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ListTile(
                    title: Text('Imię'),
                    subtitle: Text('John'), // Dodaj rzeczywiste dane
                    dense: true,
                  ),
                  ListTile(
                    title: Text('Nazwisko'),
                    subtitle: Text('Doe'), // Dodaj rzeczywiste dane
                    dense: true,
                  ),
                  ListTile(
                    title: Text('Data urodzenia'),
                    subtitle: Text('01-01-1990'), // Dodaj rzeczywiste dane
                    dense: true,
                  ),
                  ListTile(
                    title: Text('E-mail'),
                    subtitle: Text('john.doe@example.com'), // Dodaj rzeczywiste dane
                    dense: true,
                  ),
                  ListTile(
                    title: Text('Numer telefonu'),
                    subtitle: Text('+1 123-456-7890'), // Dodaj rzeczywiste dane
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
                  onPressed: () {
                    // Dodaj kod do obsługi przycisku "Edytuj dane"
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text('Edytuj dane'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Dodaj kod do obsługi przycisku "Wyloguj"
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text('Wyloguj'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
