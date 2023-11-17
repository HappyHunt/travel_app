import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WishList extends StatelessWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista obserwowanych ofert'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          _buildWishlistItem(
            title: 'Malediwy - dupa sraka',
            price: 'Cena: 3999 zł',
            term: '19.04.2023 - 29.04.2023',
            location: 'Chaka laka, Malediwy',
          ),

          // Add more wishlist items as needed
        ],
      ),
    );
  }

  Widget _buildWishlistItem({
    required String title,
    required String price,
    required String term,
    required String location,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/m1.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(width: 16.0),
            // Details
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
                  Text(term),
                  Text(location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
