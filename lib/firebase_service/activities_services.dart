import 'package:cloud_firestore/cloud_firestore.dart';

import '../model_classes/activity_model.dart';

class ActivitiesServices {
  final activitiesRef =
  FirebaseFirestore.instance.collection("activities");

  Future<List<ActivityModel>> getActivitiesOnce() async {
    final snap = await activitiesRef
        .orderBy("createdAt", descending: true)
        .get();

    return snap.docs.map((d) => ActivityModel.fromDoc(d)).toList();
  }

  Future<String> addActivityReturnId(ActivityModel activity) async {
    final doc = await activitiesRef.add(activity.toMap());
    return doc.id;
  }

  Future<void> deleteActivity(String id) async {
    await activitiesRef.doc(id).delete();
  }

  Future<void> updateActivity(ActivityModel activity) async {
    await activitiesRef.doc(activity.id).update(activity.toMap());
  }
}
