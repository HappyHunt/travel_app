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
        startDate: null,
        country: '',
        city: '',
        longitude: null,
        latitude: null,
      ),
      Offer(
        title: 'Inna oferta',
        price: 2999.0,
        // Zmieniłem na double
        endDate: DateTime(2023, 5, 25),
        // Zmieniłem na DateTime
        photoUrl: 'assets/m2.jpg',
        description: 'sraka',
        startDate: null,
        country: '',
        city: '',
        longitude: null,
        latitude: null,
      ),
    ];
  }
}
