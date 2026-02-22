import 'package:cloud_firestore/cloud_firestore.dart';
import '../model_classes/access_model.dart';
class AccessService {
  final _db = FirebaseFirestore.instance.collection('access_keys');

  Future<AccessModel?> getByName(String name) async {
    final snap = await _db.where('name', isEqualTo: name).limit(1).get();
    if (snap.docs.isEmpty) return null;

    final doc = snap.docs.first;
    return AccessModel.fromMap(doc.id, doc.data());
  }

  Future<AccessModel> createAccess(String name, String code) async {
    final doc = await _db.add({
      'name': name,
      'code': code,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return AccessModel(id: doc.id, name: name, code: code);
  }

  Future<void> updateCode(String id, String code) async {
    await _db.doc(id).update({'code': code});
  }
}
