import 'package:cloud_firestore/cloud_firestore.dart';
import '../model_classes/QuotesModelClass.dart';

class FirebaseService {
  final CollectionReference _quotesCollection =
  FirebaseFirestore.instance.collection('quotes');

  Future<List<Quote>> fetchQuotes() async {
    QuerySnapshot snapshot = await _quotesCollection.get();
    return snapshot.docs
        .map((doc) => Quote.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
