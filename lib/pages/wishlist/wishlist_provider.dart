import 'package:travel_app/pages/wishlist/wishlist_data.dart';

class WishlistProvider {
  static List<OfferListItem> getData() {
    return [
      OfferListItem(
        title: 'Malediwy ',
        price: '3999 zł',
        startDate: '19.04.2023',
        endDate: '29.04.2023',
        localization: 'Chaka laka, Malediwy',
        photoUrl: 'assets/m1.jpg',
      ),
      OfferListItem(
        title: 'Inna oferta',
        price: '2999 zł',
        startDate: '15.05.2023',
        endDate: '25.05.2023',
        localization: 'Inna lokalizacja',
        photoUrl: 'assets/m2.jpg',
      ),
    ];
  }
}