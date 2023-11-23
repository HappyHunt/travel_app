import 'package:travel_app/pages/offers/offers_data.dart';

class OfferProvider {
  static List<Offer> readOffersData() {
    return [
      Offer(
        title: 'Malediwy ',
        price: '3999 zł',
        dates: '19.04.2023 - 29.04.2023',
        location: 'Chaka laka, Malediwy',
        photoUrl: 'assets/m1.jpg',
        description: 'sraka',
        isTour: false,
      ),
      Offer(
        title: 'Inna oferta',
        price: '2999 zł',
        dates: '15.05.2023 - 25.05.2023',
        location: 'Inna location',
        photoUrl: 'assets/m2.jpg',
        description: 'sraka',
        isTour: false,
      ),
    ];
  }
}