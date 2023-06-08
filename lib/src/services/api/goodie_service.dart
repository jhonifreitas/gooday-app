import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/goodie_model.dart';

class GoodieApiService {
  final _ref = FirebaseFirestore.instance.collection('goodies').withConverter(
      fromFirestore: (snapshot, _) =>
          GoodieModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<List<GoodieModel>> getAll(String userId) async {
    const limit = 30;

    final query = await _ref
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return query.docs.map((doc) => doc.data()).toList();
  }

  Future<List<GoodieModel>> getByTypeByDate(
    String userId,
    GoodieType type,
    DateTime date,
  ) async {
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = start.add(const Duration(days: 1));

    final query = await _ref
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type.name)
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .orderBy('createdAt', descending: true)
        .get();
    return query.docs.map((doc) => doc.data()).toList();
  }

  Future<void> add(GoodieModel data) async {
    await _ref.add(data);
    return;
  }
}
