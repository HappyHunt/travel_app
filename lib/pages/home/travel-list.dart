import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../db_methods/user.dart';
import '../../main.dart';
import '../offers/offers_data.dart';

class TravelsListView extends StatelessWidget {
  final List<Offer> dataList;

  TravelsListView({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showOfferDetailsDialog(context, dataList[index]);
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(dataList[index].photoUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataList[index].title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              ' ${dataList[index].startDate.day}.${dataList[index].startDate.month}.${dataList[index].startDate.year}'
                              ' - ${dataList[index].endDate.day}.${dataList[index].endDate.month}.${dataList[index].endDate.year}',
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${dataList[index].price} zł/os',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    dataList[index].observedBy.contains(userId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _toggleFavorite(dataList[index]);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOfferDetailsDialog(BuildContext context, Offer offer) {
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
        title: const Text('Szczegóły oferty'),
      ),
      body: ListView(
        children: [
          Card(
            elevation: 4.0, // Add a subtle shadow
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                offer.photoUrl,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              _buildDivider(),
              _buildCategoryRow(
                icon: Icons.wallet,
                title: '',
                content: '${offer.price} zł / os',
                color: appTheme.primaryColor,
                fontSize: 24.0,
              ),
              _buildDivider(),
              _buildCategoryRow(
                icon: Icons.date_range,
                title: '',
                content:
                '${offer.startDate.day}.${offer.startDate.month}.${offer.startDate.year} - ${offer.endDate.day}.${offer.endDate.month}.${offer.endDate.year}',
                color:  appTheme.primaryColor,
                fontSize: 24.0,
              ),
              _buildDivider(),
              _buildCategoryRow(
                icon: Icons.location_on,
                content: offer.city,
                title: '',
                color:  appTheme.primaryColor,
                fontSize: 24.0,
              ),              _buildDivider(),
              _buildCategoryRow(
                icon: Icons.event_available,
                content: 'Wolne miejsca: ' + offer.personCount.toString(),
                title: '',
                color:  appTheme.primaryColor,
                fontSize: 24.0,
              ),
              _buildDivider(),
              _buildCategoryRow(
                title: '',
                icon: Icons.info_rounded,
                content: offer.description,
                color:  appTheme.hintColor,
                fontSize: 18.0,
              ),_buildDivider(),
              _buildCategoryRow(
                title: '',
                icon: Icons.location_on,
                content: "Lokalizacja: ",
                color:  appTheme.hintColor,
                fontSize: 24.0,
              ),
            ],
          ),
        ),
      ),
          SizedBox(
            height: 200.0, // Wysokość obszaru mapy
            child: GoogleMap(
              onMapCreated: (controller) {
                // Tutaj możesz dodać dodatkową logikę obsługi mapy
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(offer.longitude, offer.latitude),
                zoom: 14.0,
              ),
              markers: <Marker>{
                Marker(
                  markerId: MarkerId('offer_location'),
                  position: LatLng(36.54978068411743, 29.1157510185125),
                  infoWindow: InfoWindow(
                    snippet: offer.country,
                  ),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.secondaryHeaderColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Rezerwuj',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildCategoryRow({
  required IconData icon,
  required String title,
  required String content,
  required Color color,
  double fontSize=24,
}) {
  return Row(
    children: [
      Icon(
        icon,
        color: color,
      ),
      Text(
        ' $title  ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Flexible(
        child: Text(
          ' $content',
          style: TextStyle(
            fontSize: fontSize,
              color: color),
        ),
      ),
    ],
  );
}

Widget _buildDivider() {
  return Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey, // Kolor kreski
    margin: const EdgeInsets.symmetric(vertical: 8.0), // Odstęp górny i dolny
  );
}

void _toggleFavorite(Offer offer) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference travelsCollection =
  _firestore.collection('trips');

  if (offer.observedBy.contains(userId)) {
    await travelsCollection.doc(offer.uid).update({
      'observedBy': FieldValue.arrayRemove([userId]),
    });
  } else {
    await travelsCollection.doc(offer.uid).update({
      'observedBy': FieldValue.arrayUnion([userId]),
    });
  }
}