import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../offers/offers_data.dart';
import '../reservations/make_reservation.dart';
import 'home_page.dart';

class TravelsListView extends StatelessWidget {
  final List<Offer> dataList;
  final Function(Offer) onFavoriteToggle;

  const TravelsListView({
    Key? key,
    required this.dataList,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int hotelOrApartment = Provider.of<MyState>(context).hotelOrApartment;

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
            margin: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(8.0),
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
                            const SizedBox(width: 8.0),
                            Text(
                              ' ${dataList[index].startDate.day}.${dataList[index].startDate.month}.${dataList[index].startDate.year}'
                              ' - ${dataList[index].endDate.day}.${dataList[index].endDate.month}.${dataList[index].endDate.year}',
                              style: const TextStyle(fontSize: 13.0),
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
                    dataList[index].observedBy.contains(FirebaseAuth.instance.currentUser?.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _toggleFavorite(dataList[index]);
                    Provider.of<MyState>(context, listen: false).setTravelsList(
                        hotelOrApartment,
                        selectedCountry,
                        selectedLocation,
                        personCountController.text,
                        selectedStartDate,
                        selectedEndDate);
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

  const OfferDetailsScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły oferty', style: TextStyle(color: Colors.white)),
        backgroundColor: appTheme.secondaryHeaderColor,
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
                content: '${offer.country} / ${offer.city}',
                title: '',
                color:  appTheme.primaryColor,
                fontSize: 24.0,
              ),              _buildDivider(),
              _buildCategoryRow(
                icon: Icons.event_available,
                content: 'Wolne miejsca: ${offer.personCount}',
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
            height: 200.0,
            child: GoogleMap(
              onMapCreated: (controller) {
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(offer.longitude, offer.latitude),
                zoom: 14.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: offer.personCount > 0
                  ? () {
                reserveTrip(offer, context);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.secondaryHeaderColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                'Rezerwuj',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )

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
        style: const TextStyle(
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
    color: Colors.grey,
    margin: const EdgeInsets.symmetric(vertical: 8.0),
  );
}

void _toggleFavorite( Offer offer) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference travelsCollection = firestore.collection('trips');

  if (offer.observedBy.contains(FirebaseAuth.instance.currentUser?.uid)) {
    await travelsCollection.doc(offer.uid).update({
      'observedBy': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid]),
    });
  } else {
    await travelsCollection.doc(offer.uid).update({
      'observedBy': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid]),
    });
  }

}

void reserveTrip(Offer offer, BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MakeReservationScreen(
        tripId: offer.uid,
        offerTitle: offer.title,
        price: offer.price,
        availableSlots: offer.personCount,
      ),
    ),
  );
}