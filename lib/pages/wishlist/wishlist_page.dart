import 'package:flutter/material.dart';
import 'package:travel_app/main.dart';
import '../offers/offers_data.dart';
import '../offers/offers_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WishList extends StatelessWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Offer> observedOffer = OfferProvider.readOffersData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista obserwowanych ofert'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: observedOffer.map((offer) {
          return GestureDetector(
            onTap: () {
              _showOfferDetails(context, offer);
            },
            child: _buildWishlistItem(
              title: offer.title,
              price: "Cena: " + offer.price,
              dates: "Data: " + offer.dates,
              location: offer.location,
              photoUrl: offer.photoUrl,
              offer: offer,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWishlistItem({
    required String title,
    required String price,
    required String dates,
    required String location,
    required String photoUrl,
    required Offer offer,
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
                  image: AssetImage(photoUrl),
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
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(price),
                  Text(dates),
                  Text(location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferDetails(BuildContext context, Offer offer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OfferDetailsScreen(offer: offer),
      ),
    );
  }
}

class OfferDetailsScreen extends StatelessWidget {
  final Offer offer;

  const OfferDetailsScreen({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły oferty'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4.0, // Add a subtle shadow
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                offer.photoUrl,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Cena: ${offer.price}',
                  style: TextStyle(
                    color: appTheme.hintColor, // Use an accent color for emphasis
                  ),
                ),
                Text('Data: ${offer.dates}'),
                Text('Lokalizacja: ${offer.location}'),
                Text('Opis: ${offer.location}'),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 200.0, // Wysokość obszaru mapy
            child: GoogleMap(
              onMapCreated: (controller) {
                // Tutaj możesz dodać dodatkową logikę obsługi mapy
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(36.54978068411743, 29.1157510185125),
                zoom: 14.0,
              ),
              markers: Set<Marker>.from([
                Marker(
                  markerId: MarkerId('offer_location'),
                  position: LatLng(36.54978068411743, 29.1157510185125),
                  infoWindow: InfoWindow(
                    title: 'Lokalizacja oferty',
                    snippet: offer.location,
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.secondaryHeaderColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Rezerwuj', style: TextStyle(fontSize:20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
