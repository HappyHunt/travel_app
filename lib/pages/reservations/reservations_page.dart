import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Reservation {
  String userId;
  String tripId;
  String lastName;
  String firstName;
  num participants;
  num totalPrice;

  Reservation({
    required this.userId,
    required this.tripId,
    required this.firstName,
    required this.lastName,
    required this.participants,
    required this.totalPrice,
  });

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Reservation(
      userId: data?['userId'] ?? '',
      tripId: data?['tripId'] ?? '',
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      participants: data?['participants'] ?? 0,
      totalPrice: data?['totalPrice'] ?? 0,
    );
  }
}

class Offer {
  String uid;
  String title;
  String city;
  DateTime startDate;
  DateTime endDate;
  num price;
  String photoUrl;
  List<String> observedBy;

  Offer({
    required this.uid,
    required this.title,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.photoUrl,
    required this.observedBy,
  });

  factory Offer.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return Offer(
      uid: doc.id,
      title: data?['title'] ?? '',
      city: data?['city'] ?? '',
      startDate: (data?['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data?['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (data?['price'] as num?) ?? 0,
      photoUrl: data?['photoUrl'] ?? '',
      observedBy: List<String>.from(data?['observedBy'] ?? []),
    );
  }
}

class ReservationsListView extends StatelessWidget {
  const ReservationsListView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Twoje rezerwacje'),
      ),
      body: StreamBuilder<List<Reservation>>(
        stream: getReservationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Reservation> reservations = snapshot.data ?? [];

            return Column(
              children: [
                for (int index = 0; index < reservations.length; index++)
                  ReservationCard(reservation: reservations[index]),
              ],
            );
          }
        },
      ),
    );
  }

  Stream<List<Reservation>> getReservationsStream() {
    var collectionReference = FirebaseFirestore.instance.collection(
        'reservations');
    return collectionReference
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((querySnapshot) =>
        querySnapshot.docs.map((doc) => Reservation.fromFirestore(doc))
            .toList());
  }
}

class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({Key? key, required this.reservation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Offer>(
      future: getOfferDetails(reservation.tripId),
      builder: (context, offerSnapshot) {
        if (offerSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (offerSnapshot.hasError) {
          return Text('Error: ${offerSnapshot.error}');
        } else {
          Offer offer = offerSnapshot.data!;
          return GestureDetector(
            onTap: () {
              _showReservationDetailsDialog(context, reservation, offer);
            },
            child: Card(
              key: ValueKey(reservation.tripId),
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(offer.photoUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.title,
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              ' ${offer.startDate.day}.${offer.startDate
                                  .month}.${offer.startDate.year}'
                                  ' - ${offer.endDate.day}.${offer.endDate
                                  .month}.${offer.endDate.year}',
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),

                        Text(
                          'Liczba uczestników: ${reservation.participants}',
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${reservation.totalPrice} zł',
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Offer> getOfferDetails(String tripId) async {
    try {
      var collectionReference = FirebaseFirestore.instance.collection('trips');
      DocumentSnapshot docSnapshot = await collectionReference.doc(tripId)
          .get();
      return Offer.fromFirestore(docSnapshot);
    } catch (error) {
      print("Błąd podczas pobierania szczegółów oferty z Firestore: $error");
      throw error;
    }
  }

  void _showReservationDetailsDialog(BuildContext context,
      Reservation reservation, Offer offer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Szczegóły rezerwacji'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Imię: ${reservation.firstName}',
                  style: TextStyle(fontSize: 18.0)),
              Text('Nazwisko: ${reservation.lastName}',
                  style: TextStyle(fontSize: 18.0)),
              Text('Liczba uczestników: ${reservation.participants}',
                  style: TextStyle(fontSize: 18.0)),
              Text('Miasto: ${offer.city}', style: TextStyle(fontSize: 18.0)),
              Text(
                'Daty: ${offer.startDate.day}.${offer.startDate.month}.${offer
                    .startDate.year}'
                    ' - ${offer.endDate.day}.${offer.endDate.month}.${offer
                    .endDate.year}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text('Łączna cena: ${reservation.totalPrice} zł',
                  style: TextStyle(fontSize: 18.0)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Zamknij', style: TextStyle(fontSize: 18.0)),
            ),
          ],
        );
      },
    );
  }
}


