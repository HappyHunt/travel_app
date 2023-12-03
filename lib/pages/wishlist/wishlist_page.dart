import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/pages/offers/offers_data.dart';
import '../../db_methods/favorites.dart';
import '../home/travel_list.dart';

class Wishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Twoje ulubione podróże'),
      ),
      body: FutureBuilder<List<Offer>>(
        future: getFavoritesList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Offer> wishlist = snapshot.data ?? [];

            return ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                Offer offer = wishlist[index];
                return GestureDetector(
                  onTap: () {
                    _showOfferDetailsDialog(context, offer);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(offer.photoUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer.title,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                                      style: const TextStyle(fontSize: 15.0),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${offer.price} zł/os',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _toggleFavorite(offer);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showOfferDetailsDialog(BuildContext context, Offer offer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OfferDetailsScreen(offer: offer),
      ),
    );
  }

  void _toggleFavorite(Offer offer) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference travelsCollection =
    firestore.collection('trips');

    if (offer.observedBy
        .contains(FirebaseAuth.instance.currentUser?.uid)) {
      await travelsCollection.doc(offer.uid).update({
        'observedBy':
        FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid]),
      });
    } else {
      await travelsCollection.doc(offer.uid).update({
        'observedBy':
        FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid]),
      });
    }
  }
}
