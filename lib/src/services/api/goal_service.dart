import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/goal_model.dart';

class GoalApiService {
  final _ref = FirebaseFirestore.instance.collection('goals').withConverter(
      fromFirestore: (snapshot, _) =>
          GoalModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<GoalModel?> getByDate(String userId, DateTime date) async {
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = start.add(const Duration(days: 1));

    final query = await _ref
        .where('userId', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .orderBy('createdAt', descending: true)
        .get();

    if (query.docs.isEmpty) return null;

    return query.docs.first.data();
  }

  Future<GoalModel> save(GoalModel data) async {
    DocumentReference<GoalModel> ref;
    if (data.id != null) {
      ref = await _update(data);
    } else {
      ref = await _add(data);
    }

    final doc = await ref.get();
    return doc.data()!;
  }

  Future<DocumentReference<GoalModel>> _add(GoalModel data) {
    return _ref.add(data);
  }

  Future<DocumentReference<GoalModel>> _update(GoalModel data) async {
    final ref = _ref.doc(data.id);
    await ref.update(data.toJson());
    return ref;
  }
}
