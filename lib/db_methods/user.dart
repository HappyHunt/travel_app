import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void> addUser(String uid, String? first, String? last, String? email, DateTime? born, String? phone) {
  return users
      .doc(uid)
      .set({
    'last': last,
    'first': first,
    'email': email,
    'born' : born,
    'phone' : phone
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