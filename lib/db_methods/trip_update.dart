import 'package:cloud_firestore/cloud_firestore.dart';

class TripService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _tripsCollection = _firestore.collection('trips');

  static Future<void> updateAvailableSeats(String tripId, int participants) async {
    try {
      DocumentReference tripReference = _tripsCollection.doc(tripId);

      DocumentSnapshot tripSnapshot = await tripReference.get();
      Map<String, dynamic>? tripData = tripSnapshot.data() as Map<String, dynamic>?;

      if (tripData != null) {
        int personCount = tripData['personCount'] ?? 0;

        if (personCount >= participants) {
          await tripReference.update({
            'personCount': personCount - participants,
          });
        } else {
          throw Exception('Niewystarczająca ilość wolnych miejsc.');
        }
      } else {
        throw Exception('Nie znaleziono danych wyjazdu.');
      }
    } catch (error) {
      print('Błąd podczas aktualizacji stanu wolnych miejsc: $error');
      throw error;
    }
  }
}
