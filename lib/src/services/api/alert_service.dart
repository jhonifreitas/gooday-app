import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/alert_model.dart';

class AlertApiService {
  final _ref = FirebaseFirestore.instance.collection('alerts').withConverter(
      fromFirestore: (snapshot, _) =>
          AlertModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<List<AlertModel>> getByDate(String userId, DateTime date) async {
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = start.add(const Duration(days: 1));

    final query = await _ref
        .where('userId', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .where('createdAt', isLessThanOrEqualTo: end)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs.map((doc) => doc.data()).toList();
  }

  Future<AlertModel> save(AlertModel data) async {
    DocumentReference<AlertModel> ref;
    if (data.id != null) {
      ref = await _update(data);
    } else {
      ref = await _add(data);
    }

    final doc = await ref.get();
    return doc.data()!;
  }

  Future<DocumentReference<AlertModel>> _add(AlertModel data) {
    return _ref.add(data);
  }

  Future<DocumentReference<AlertModel>> _update(AlertModel data) async {
    final ref = _ref.doc(data.id);
    await ref.update(data.toJson());
    return ref;
  }
}
