import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/meal_model.dart';

class MealApiService {
  final _ref = FirebaseFirestore.instance.collection('meals').withConverter(
      fromFirestore: (snapshot, _) =>
          MealModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<List<MealModel>> getAll(String userId) async {
    final query = await _ref
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(30)
        .get();
    return query.docs.map((doc) => doc.data()).toList();
  }

  Future<MealModel> save(MealModel data) async {
    DocumentReference<MealModel> ref;
    if (data.id != null) {
      ref = await _update(data);
    } else {
      ref = await _add(data);
    }

    final doc = await ref.get();
    return doc.data()!;
  }

  Future<DocumentReference<MealModel>> _add(MealModel data) {
    return _ref.add(data);
  }

  Future<DocumentReference<MealModel>> _update(MealModel data) async {
    final ref = _ref.doc(data.id);
    await ref.update(data.toJson());
    return ref;
  }
}
