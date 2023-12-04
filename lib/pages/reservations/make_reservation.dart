import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../db_methods/reservation.dart';

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController participantsController = TextEditingController();

class MakeReservationScreen extends StatefulWidget {
  final String tripId;
  final String offerTitle;
  final int price;

  const MakeReservationScreen({
    super.key,
    required this.tripId,
    required this.offerTitle,
    required this.price,
  });

  @override
  _MakeReservationScreenState createState() => _MakeReservationScreenState();
}

class _MakeReservationScreenState extends State<MakeReservationScreen> {
  bool _acceptTerms = false;

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
              decoration: const InputDecoration(labelText: 'Imię'),
              controller: firstNameController,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nazwisko'),
              controller: lastNameController,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Liczba osób'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: participantsController,
            ),
            const SizedBox(height: 15.0),
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
                           'rezerwacji oraz regulamin aplikacji \n VoyageVoyage.'
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () async {
                if (_acceptTerms) {
                  Reservation reservation = Reservation(
                    tripId: widget.tripId,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    participants: int.parse(participantsController.text),
                    totalPrice: (int.parse(participantsController.text)*widget.price)
                  );

                  await ReservationService.makeReservation(reservation);
                } else {

                }
              },
              child: const Text('Rezerwuj'),
            ),
          ],
        ),
      ),
    );
  }
}

