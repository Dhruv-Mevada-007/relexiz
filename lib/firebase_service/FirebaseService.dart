import 'package:cloud_firestore/cloud_firestore.dart';

import '../model_classes/pg_model_class.dart';

class FirebaseService {
  final CollectionReference pgCollection =
  FirebaseFirestore.instance.collection('pgs');

  Future<List<PG>> fetchPGs() async {
    QuerySnapshot snapshot = await pgCollection.get();
    return snapshot.docs
        .map((doc) => PG.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addPG(Map<String, dynamic> pgData) async {
    await pgCollection.add(pgData);
  }
}