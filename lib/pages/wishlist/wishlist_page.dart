import 'package:flutter/material.dart';
import 'package:travel_app/pages/wishlist/wishlist_data.dart';
import 'wishlist_provider.dart';

class WishList extends StatelessWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<OfferListItem> pozycjeNaLiscieZyczen = WishlistProvider.getData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista obserwowanych ofert'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: pozycjeNaLiscieZyczen.map((pozycja) {
          return GestureDetector(
            onTap: () {
              _showOfferDetails(context, pozycja);
            },
            child: _buildWishlistItem(
              tytul: pozycja.title,
              cena: "Cena: " + pozycja.price,
              okres:"Data: " + pozycja.endDate,
              lokalizacja: pozycja.localization,
              zdjecieUrl: pozycja.photoUrl,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWishlistItem({
    required String tytul,
    required String cena,
    required String okres,
    required String lokalizacja,
    required String zdjecieUrl,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Obraz
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(zdjecieUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(width: 16.0),
            // Szczegóły
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tytul,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(cena),
                  Text(okres),
                  Text(lokalizacja),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferDetails(BuildContext context, OfferListItem pozycja) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OfferDetailsScreen(pozycja: pozycja),
      ),
    );
  }
}

class OfferDetailsScreen extends StatelessWidget {
  final OfferListItem pozycja;

  const OfferDetailsScreen({Key? key, required this.pozycja}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły oferty'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            pozycja.photoUrl,
            width: double.infinity,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pozycja.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text('Cena: ${pozycja.price}'),
                Text('Okres: ${pozycja.endDate}'),
                Text('Lokalizacja: ${pozycja.localization}'),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Dodaj tutaj obsługę przycisku Rezerwuj
              },
              child: Text('Rezerwuj'),
            ),
          ),
        ],
      ),
    );
  }
}
