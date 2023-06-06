import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/goodie_model.dart';

class GoodieService {
  final _ref = FirebaseFirestore.instance.collection('goodies').withConverter(
      fromFirestore: (snapshot, _) =>
          GoodieModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<List<GoodieModel>> getByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = start.add(const Duration(days: 1));

    final query = await _ref
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .get();
    return query.docs.map((doc) => doc.data()).toList();
  }

  Future<void> add(GoodieModel data) async {
    await _ref.add(data);
    return;
  }
}
