import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/pages/offers/offers_data.dart';

Future<List<Offer>> getTravelsList(int option) async {

  try {
    QuerySnapshot querySnapshot;

    if (option == 1) {
      print("objazd");
      querySnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .where('city', isEqualTo: "")
          .get();
      print(querySnapshot.docs);
    } else {
      print("wypoczynek");
      querySnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .where('city', isNotEqualTo: "")
          .get();
      print(querySnapshot.docs);
    }

    List<Offer> travelsList = querySnapshot.docs.map((doc) => Offer.fromFirestore(doc)).toList();
    travelsList.forEach((offer) {
      print("Title: ${offer.title}, Price: ${offer.price}, Location: ${offer.city}");
    });
    return travelsList;
  } catch (error) {
    print("Błąd podczas pobierania danych z Firestore: $error");
    return [];
  }
}