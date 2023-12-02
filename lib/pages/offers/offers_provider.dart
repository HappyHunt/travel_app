import 'package:travel_app/pages/offers/offers_data.dart';

class OfferProvider {
  static List<Offer> readOffersData() {
    return [
      Offer(
        title: 'Malediwy',
        price: 3999.0,
        endDate: DateTime(2023, 4, 29),
        photoUrl: 'assets/m1.jpg',
        description: 'sraka',
        startDate: DateTime(2023, 4, 25),
        country: 'francj ',
        city: 'dupas',
        personCount: 5,
        longitude: 52,
        latitude: 52,
        observedBy: [],
      ),
      Offer(
        title: 'Inna oferta',
        price: 2999.0,
        startDate:DateTime(2023,5,21),
        // Zmieniłem na double
        endDate: DateTime(2023, 5, 25),
        // Zmieniłem na DateTime
        photoUrl: 'assets/m2.jpg',
        description: 'sraka',
        country: 'francj ',
        city: 'dupas',
        personCount: 10,
        longitude: 52,
        latitude: 52,
        observedBy: [],
      ),
    ];
  }
}
