import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/model_countries.dart';

Future<List<Country>> getCountryList() async {

  try {
    QuerySnapshot querySnapshot;

      querySnapshot = await FirebaseFirestore.instance
          .collection('countries')
          .get();

    List<Country> countries = querySnapshot.docs.map((doc) => Country.fromFirestore(doc)).toList();

    return countries;
  } catch (error) {
    print("Błąd podczas pobierania danych z Firestore: $error");
    return [];
  }
}