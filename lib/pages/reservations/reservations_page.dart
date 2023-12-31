import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';

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

    List<String> observedBy = [];
    if (data?['observedBy'] is List<String>) {
      observedBy = List<String>.from(data?['observedBy']);
    }

    return Offer(
      uid: doc.id,
      title: data?['title'] ?? '',
      city: data?['city'] ?? '',
      startDate: (data?['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data?['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (data?['price'] as num?) ?? 0,
      photoUrl: data?['photoUrl'] ?? '',
      observedBy: observedBy,
    );
  }
}

class ReservationsListView extends StatelessWidget {
  const ReservationsListView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twoje rezerwacje', style: TextStyle(color: Colors.white)),
        backgroundColor: appTheme.secondaryHeaderColor,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<Reservation>>(
          stream: getReservationsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<Reservation> reservations = snapshot.data ?? [];

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (reservations.isEmpty)
                      Text(
                        'Nie masz jeszcze żadnych rezerwacji :(',
                        style: TextStyle(fontSize: 18.0),
                      )
                    else
                      Column(
                        children: [
                          for (int index = 0; index < reservations.length; index++)
                            ReservationCard(reservation: reservations[index]),
                        ],
                      ),
                  ],
                ),
              );
            }
          },
        ),
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

  const ReservationCard({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Offer?>(
      future: getOfferDetails(reservation.tripId),
      builder: (context, AsyncSnapshot<Offer?> offerSnapshot) {
        if (offerSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (offerSnapshot.hasError || offerSnapshot.data == null) {
          return Text('Error: Unable to retrieve offer details');
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
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              ' ${offer.startDate.day}.${offer.startDate.month}.${offer.startDate.year}'
                                  ' - ${offer.endDate.day}.${offer.endDate.month}.${offer.endDate.year}',
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

  Future<Offer?> getOfferDetails(String tripId) async {
    try {
      var collectionReference = FirebaseFirestore.instance.collection('trips');
      DocumentSnapshot docSnapshot = await collectionReference.doc(tripId).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        return Offer.fromFirestore(docSnapshot);
      } else {
        // Handle the case where the document doesn't exist
        print('Document with tripId $tripId does not exist.');
        return null;
      }
    } catch (error, stackTrace) {
      print("Error retrieving offer details from Firestore: $error");
      print("Stack trace: $stackTrace");
      return null;
    }
  }

  void _showReservationDetailsDialog(BuildContext context,
      Reservation reservation, Offer offer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Szczegóły rezerwacji'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Imię: ${reservation.firstName}',
                  style: const TextStyle(fontSize: 18.0)),
              _buildDivider(),
              Text('Nazwisko: ${reservation.lastName}',
                  style: const TextStyle(fontSize: 18.0)),
              _buildDivider(),
              Text('Liczba uczestników: ${reservation.participants}',
                  style: const TextStyle(fontSize: 18.0)),
              _buildDivider(),
              Text('Miasto: ${offer.city}', style: const TextStyle(fontSize: 18.0)),
              _buildDivider(),
              Text(
                'Daty: ${offer.startDate.day}.${offer.startDate.month}.${offer
                    .startDate.year}'
                    ' - ${offer.endDate.day}.${offer.endDate.month}.${offer
                    .endDate.year}',
                style: const TextStyle(fontSize: 18.0),
              ),
              _buildDivider(),
              Text('Łączna cena: ${reservation.totalPrice} zł',
                  style: const TextStyle(fontSize: 18.0)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Zamknij', style: TextStyle(fontSize: 18.0)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        height: 1,
        color: Colors.grey,
      ),
    );
  }
}


