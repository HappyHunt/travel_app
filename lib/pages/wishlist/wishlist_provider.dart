import 'package:travel_app/pages/wishlist/wishlist_data.dart';

class WishlistProvider {
  static List<PozycjaNaLiscieZyczen> pobierzDane() {
    return [
      PozycjaNaLiscieZyczen(
        tytul: 'Malediwy ',
        cena: '3999 zł',
        okres: '19.04.2023 - 29.04.2023',
        lokalizacja: 'Chaka laka, Malediwy',
        zdjecieUrl: 'assets/m1.jpg',
      ),
      PozycjaNaLiscieZyczen(
        tytul: 'Inna oferta',
        cena: '2999 zł',
        okres: '15.05.2023 - 25.05.2023',
        lokalizacja: 'Inna lokalizacja',
        zdjecieUrl: 'assets/m2.jpg',
      ),
    ];
  }
}