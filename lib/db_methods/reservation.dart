import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _reservationsCollection = _firestore.collection('reservations');

  static Future<void> makeReservation(Reservation reservation) async {
    await _reservationsCollection.add({
      'tripId': reservation.tripId,
      'userId': reservation.userId,
      'firstName': reservation.firstName,
      'lastName': reservation.lastName,
      'participants': reservation.participants,
      'totalPrice': reservation.totalPrice,
      'phoneNumber': reservation.phoneNumber,
    });
  }
}

class Reservation {
  final String? tripId;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final int? participants;
  final int? totalPrice;
  final String? phoneNumber;

  Reservation({
    required this.tripId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.participants,
    required this.totalPrice,
    required this.phoneNumber,
  });
}
