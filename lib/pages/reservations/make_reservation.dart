import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_app/pages/home/home_page.dart';

import '../../db_methods/reservation.dart';

TextEditingController participantsController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();

class MakeReservationScreen extends StatefulWidget {
  final String tripId;
  final String offerTitle;

  const MakeReservationScreen({
    Key? key,
    required this.tripId,
    required this.offerTitle,
  }) : super(key: key);

  @override
  _MakeReservationScreenState createState() => _MakeReservationScreenState();
}

class _MakeReservationScreenState extends State<MakeReservationScreen> {
  bool _acceptTerms = false;

  get participantsController => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rezerwacja oferty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.offerTitle),

            TextFormField(
              decoration: InputDecoration(labelText: 'Imię'),
              controller: firstNameController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nazwisko'),
              controller: lastNameController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Liczba osób'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: participantsController,
            ),
            SizedBox(height: 15.0),
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                ),
                const Text('Zapoznałem się z ofertą i akceptuję warunki \n'
                    'rezerwacji oraz regulamin aplikacji '
                    '\n VoyageVoyage.'),
              ],
            ),
            SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () async {
                if (_acceptTerms) {
                  Reservation reservation = Reservation(
                    tripId: widget.tripId,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    participants: num.tryParse(personCountController.text),//TODO - nie dziala
                  );


                  await ReservationService.makeReservation(reservation);
                } else {
                }
              },
              child: Text('Rezerwuj'),
            ),
          ],
        ),
      ),
    );
  }
}

