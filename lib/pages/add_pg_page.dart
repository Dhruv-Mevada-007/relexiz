import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase_service/FirebaseService.dart';
import '../providers/pg_provider.dart';

class AddPGPage extends StatefulWidget {
  @override
  _AddPGPageState createState() => _AddPGPageState();
}

class _AddPGPageState extends State<AddPGPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _pgData = {
    'name': '',
    'location': '',
    'priceWithFoodAC': 0,
    'priceWithoutFood': 0,
    'priceWithoutAC': 0,
    'foodRating': 0.0,
    'foodReview': '',
    'contactNumber': '',
    'contactPerson': '',
    'houseSize': '',
    'houseFeatures': <String>[],
    'description': '',
  };

  final TextEditingController _featuresController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Convert comma-separated features into List<String>
    _pgData['houseFeatures'] =
        _featuresController.text.split(',').map((e) => e.trim()).toList();

    setState(() => _isLoading = true);

    try {
      await FirebaseService().addPG(_pgData);
      Navigator.of(context).pop(); // Go back to the PG list page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<PGProvider>(context, listen: false).loadPGs();
      });
    } catch (e) {
      print('Error adding PG: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _featuresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New PG')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'PG Name'),
                onSaved: (value) => _pgData['name'] = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Please enter PG name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (value) => _pgData['location'] = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Please enter location' : null,
              ),
              TextFormField(
                decoration:
                InputDecoration(labelText: 'Price with Food & AC (₹)'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                _pgData['priceWithFoodAC'] = int.tryParse(value!) ?? 0,
                validator: (value) =>
                value!.isEmpty ? 'Enter valid price' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price without Food (₹)'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                _pgData['priceWithoutFood'] = int.tryParse(value!) ?? 0,
                validator: (value) =>
                value!.isEmpty ? 'Enter valid price' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price without AC (₹)'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                _pgData['priceWithoutAC'] = int.tryParse(value!) ?? 0,
                validator: (value) =>
                value!.isEmpty ? 'Enter valid price' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Food Rating (0-5)'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                _pgData['foodRating'] = double.tryParse(value!) ?? 0.0,
                validator: (value) =>
                value!.isEmpty ? 'Enter valid rating' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Food Review'),
                onSaved: (value) => _pgData['foodReview'] = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _pgData['contactNumber'] = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Enter contact number' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Person Name'),
                onSaved: (value) => _pgData['contactPerson'] = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Enter contact person name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'House Size (1BHK, 2BHK)'),
                onSaved: (value) => _pgData['houseSize'] = value ?? '',
                validator: (value) =>
                value!.isEmpty ? 'Enter house size' : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'House Features (comma separated)'),
                controller: _featuresController,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => _pgData['description'] = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Main Image URL (optional)'),
                onSaved: (value) => _pgData['mainImage'] = value ?? '',
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submit,
                child: Text('Add PG'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
