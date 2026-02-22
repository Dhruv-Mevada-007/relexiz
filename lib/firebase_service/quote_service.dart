import 'package:cloud_firestore/cloud_firestore.dart';

import '../model_classes/quote_model.dart';

class QuoteService {
  final quoteRef = FirebaseFirestore.instance.collection("quotes");

  Future<List<QuoteModel>> getQuotesOnce() async {
    final snap = await quoteRef.orderBy("date", descending: true).get();
    return snap.docs.map((d) => QuoteModel.fromDoc(d)).toList();
  }

  Future<String> addQuoteReturnId(QuoteModel quote) async {
    final doc = await quoteRef.add(quote.toMap());
    return doc.id;
  }

  Future<void> deleteQuote(String id) async {
    await quoteRef.doc(id).delete();
  }
}
