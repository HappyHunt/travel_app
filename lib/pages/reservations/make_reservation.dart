import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../db_methods/reservation.dart';
import '../../db_methods/trip_update.dart';
import '../../db_methods/user.dart';

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController participantsController = TextEditingController();
TextEditingController phoneController = TextEditingController();

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
  final _formKey = GlobalKey<FormState>();
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        Map<String, dynamic>? userData = await getUserData(currentUser.uid);

        if (userData != null) {
          setState(() {
            firstNameController.text = userData['firstName'] ?? '';
            lastNameController.text = userData['lastName'] ?? '';
            phoneController.text = userData['phoneNumber'] ?? '';
          });
        }
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'To pole nie może być puste';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'To pole nie może być puste';
    }
    // Add additional phone number validation if needed
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rezerwacja oferty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(widget.offerTitle),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Imię'),
                controller: firstNameController,
                validator: _validateName,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nazwisko'),
                controller: lastNameController,
                validator: _validateName,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Numer telefonu'),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                controller: phoneController,
                validator: _validatePhoneNumber,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Liczba osób'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: participantsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'To pole nie może być puste';
                  }
                  int? parsedValue = int.tryParse(value);
                  if (parsedValue == null || parsedValue <= 0) {
                    return 'Wprowadź poprawną liczbę';
                  }
                  return null;
                },
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
                  const Text('Zapoznałem się z ofertą i akceptuję \nwarunki rezerwacji oraz regulamin '
                      '\naplikacji VoyageVoyage.'
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, proceed with reservation
                    if (_acceptTerms) {
                      Reservation reservation = Reservation(
                        tripId: widget.tripId,
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        phoneNumber: phoneController.text,
                        participants: int.parse(participantsController.text),
                        totalPrice: (int.parse(participantsController.text) * widget.price),
                      );

                      await ReservationService.makeReservation(reservation);
                      await TripService.updateAvailableSeats(widget.tripId, reservation.participants);

                      participantsController.text = '';

                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Warunki rezerwacji muszą być zaakceptowane.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Rezerwuj'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
