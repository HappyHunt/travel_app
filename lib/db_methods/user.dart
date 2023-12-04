import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final CollectionReference users = FirebaseFirestore.instance.collection('users');

String userId = '';

Future<void> addUser(String uid, String? firstName, String? lastName, String? email, DateTime? birthDate, String? phoneNumber) {
  return users
      .doc(uid)
      .set({
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'birthDate' : birthDate,
    'phoneNumber' : phoneNumber
  })
      .then((value) => print("Użytkownik dodany do Firestore"))
      .catchError((error) => print("Błąd: $error"));
}

Future<bool> checkIfUserExists(User? user) async {
  if (user == null) {
    print("Błąd: Obiekt użytkownika jest pusty.");
    return false;
  }

  final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (userSnapshot.exists) {
    print("Użytkownik już istnieje w bazie danych.");

    return true;
  } else {
    print("Użytkownik nie istnieje w bazie danych.");
    return false;
  }
}



Future<Map<String, dynamic>?> getUserData(String? uid) async {
  try {
    DocumentSnapshot userSnapshot = await users.doc(uid).get();
    if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  } catch (e) {
    print("Błąd pobierania danych użytkownika: $e");
    return null;
  }
}


Future<void> updateUserData(String? uid, String firstName, String lastName,
    String birthDate, String email, String phoneNumber) async {
  try {
    await users.doc(uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'email': email,
      'phoneNumber': phoneNumber,
    });
    print('Dane użytkownika zaktualizowane pomyślnie.');
  } catch (e) {
    print('Błąd aktualizacji danych użytkownika: $e');
  }
}

Future<String> getFirstNameByUid(String uid) async {
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userSnapshot.exists) {
      String firstName = (userSnapshot.data() as Map<String, dynamic>?)?['firstName'] ?? '';
      print('Imię użytkownika o UID $uid: $firstName');
      return firstName;
    } else {
      print('Użytkownik o UID $uid nie istnieje.');
      return ''; // Lub inną wartość domyślną w przypadku braku użytkownika
    }
  } catch (error) {
    print('Błąd podczas pobierania danych z Firebase: $error');
    return ''; // Lub inną wartość domyślną w przypadku błędu
  }
}
