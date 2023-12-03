import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/pages/offers/offers_data.dart';

List<Offer> favoritesList = [];

Future<List<Offer>> getFavoritesList() async {
  try {
    var collectionReference = FirebaseFirestore.instance.collection('trips');
    QuerySnapshot querySnapshot = await collectionReference.get();

    favoritesList = querySnapshot.docs
        .map((doc) => Offer.fromFirestore(doc))
        .where((offer) =>
        offer.observedBy.contains(FirebaseAuth.instance.currentUser?.uid))
        .toList();

    favoritesList.forEach((offer) {
      print("Title: ${offer.title}, Price: ${offer.price}, Location: ${offer.city}, "
          "Start: ${offer.startDate}, End: ${offer.endDate}");
    });

    return favoritesList;
  } catch (error) {
    print("Błąd podczas pobierania danych z Firestore: $error");
    return [];
  }
}

void addToFavorites(Offer offer) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference travelsCollection = firestore.collection('trips');

  if (!offer.observedBy.contains(FirebaseAuth.instance.currentUser?.uid)) {
    await travelsCollection.doc(offer.uid).update({
      'observedBy': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid]),
    });
  }
}

void removeFromFavorites(Offer offer) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference travelsCollection = firestore.collection('trips');

  if (offer.observedBy.contains(FirebaseAuth.instance.currentUser?.uid)) {
    await travelsCollection.doc(offer.uid).update({
      'observedBy': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid]),
    });
  }
}
