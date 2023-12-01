import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  late String uid;
  late String title;
  late double? price;
  late DateTime? endDate;
  late DateTime? startDate;
  late String country;
  late String city;
  late num? personCount;
  late double? longitude;
  late double? latitude;
  late String photoUrl;
  late String description;

  Offer({
    required this.title,
    required this.price,
    required this.endDate,
    required this.startDate,
    required this.country,
    required this.city,
    required this.personCount,
    required this.longitude,
    required this.latitude,
    required this.photoUrl,
    required this.description,
  });

  factory Offer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Offer(
      title: data['title'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      endDate: (data['endDate'] as Timestamp).toDate(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      country: data['country'] ?? '',
      city: data['city'] ?? '',
      personCount: (data['personCount'] as num?)?.toInt() ?? 0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0,
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0,
      photoUrl: data['photoUrl'] ?? '',
      description: data['description'] ?? '',
    )..uid = doc.id;
  }
}