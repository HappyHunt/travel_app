import 'package:cloud_firestore/cloud_firestore.dart';

class Country {
  final String name;
  final List<String> cities;

  Country({required this.name, required this.cities});

  factory Country.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Country(
      name: data?['name'] ?? '',
      cities: List<String>.from(data?['cities'] ?? []),
    );
  }
}
