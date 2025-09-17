import 'package:flutter/material.dart';

import '../model_classes/pg_model_class.dart';

class PGDetailPage extends StatelessWidget {
  final PG pg;

  PGDetailPage({required this.pg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pg.name)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Name: ${pg.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Location: ${pg.location}'),
            SizedBox(height: 10),
            Text('Price with Food & AC: ₹${pg.priceWithFoodAC}'),
            SizedBox(height: 10),
            Text('Price without Food: ₹${pg.priceWithoutFood}'),
            SizedBox(height: 10),
            Text('Price without AC: ₹${pg.priceWithoutAC}'),
            SizedBox(height: 10),
            Text('Food Rating: ${pg.foodRating} / 5'),
            SizedBox(height: 10),
            Text('Food Review: ${pg.foodReview}'),
            SizedBox(height: 10),
            Text('Contact Person: ${pg.contactPerson}'),
            SizedBox(height: 10),
            Text('Contact Number: ${pg.contactNumber}'),
            SizedBox(height: 10),
            Text('House Size: ${pg.houseSize}'),
            SizedBox(height: 10),
            Text('House Features: ${pg.houseFeatures.join(', ')}'),
            SizedBox(height: 10),
            Text('Description:\n${pg.description}'),
          ],
        ),
      ),
    );
  }
}
