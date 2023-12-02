import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/pages/offers/offers_data.dart';

List<Offer> travelsList = [];

Future<List<Offer>> getTravelsList(
    int option, country, city, personCount, startDate, endDate) async {
  try {
    var collectionReference = FirebaseFirestore.instance.collection('trips');
    Query query = collectionReference;

    if (option == 1) {
      query = query.where('city', isEqualTo: "");
    } else {
      query = query.where('city', isNotEqualTo: "");
      if (city != null) {
        query = query.where('city', isEqualTo: city);
      }
    }
    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }

    QuerySnapshot querySnapshot = await query.get();

    travelsList =
        querySnapshot.docs.map((doc) => Offer.fromFirestore(doc)).toList();

    travelsList.forEach((offer) {
      print(
          "Title: ${offer.title}, Price: ${offer.price}, Location: ${offer.city}, Start: ${offer.startDate}, End: ${offer.endDate}");
    });
    print("Start: ${startDate}, End: ${endDate}");

    travelsList = travelsList.where((offer) {
      bool meetsPersonCountCondition = personCount != null
          ? (offer.personCount != null &&
              offer.personCount! >= int.parse(personCount))
          : true;
      bool meetsStartDateCondition = startDate != null
          ? (offer.startDate != null &&
              (offer.startDate!.isAfter(startDate) ||
                  offer.startDate!.isAtSameMomentAs(startDate)))
          : true;
      bool meetsEndDateCondition = endDate != null
          ? (offer.endDate != null &&
              (offer.endDate!.isBefore(endDate) ||
                  offer.endDate!.isAtSameMomentAs(endDate)))
          : true;

      return meetsPersonCountCondition &&
          meetsStartDateCondition &&
          meetsEndDateCondition;
    }).toList();

    travelsList.forEach((offer) {
      print(
          "Title: ${offer.title}, Price: ${offer.price}, Location: ${offer.city}");
    });

    return travelsList;
  } catch (error) {
    print("Błąd podczas pobierania danych z Firestore: $error");
    return [];
  }
}
