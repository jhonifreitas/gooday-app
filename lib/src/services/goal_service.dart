import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/goal_model.dart';

class GoalService {
  final _ref = FirebaseFirestore.instance.collection('goodies').withConverter(
      fromFirestore: (snapshot, _) =>
          GoalModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<GoalModel?> getByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = start.add(const Duration(days: 1));

    final query = await _ref
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .get();

    if (query.docs.isEmpty) return null;

    return query.docs.first.data();
  }

  Future<void> add(GoalModel data) async {
    await _ref.add(data);
    return;
  }

  Future<void> update(GoalModel data) async {
    await _ref.doc(data.id).update(data.toJson());
    return;
  }
}
