import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/insulin_model.dart';

class InsulinApiService {
  final _ref = FirebaseFirestore.instance.collection('insulins').withConverter(
      fromFirestore: (snapshot, _) =>
          InsulinModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<List<InsulinModel>> getByRangeDate(
      String userId, DateTime start, DateTime end) async {
    final query = await _ref
        .where('userId', isEqualTo: userId)
        .where('deletedAt', isNull: true)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy('date', descending: true)
        .limit(30)
        .get();

    return query.docs.map((doc) => doc.data()).toList();
  }

  Future<InsulinModel> save(InsulinModel data) async {
    DocumentReference<InsulinModel> ref;
    if (data.id != null) {
      ref = await _update(data);
    } else {
      ref = await _add(data);
    }

    final doc = await ref.get();
    return doc.data()!;
  }

  Future<DocumentReference<InsulinModel>> _add(InsulinModel data) {
    return _ref.add(data);
  }

  Future<DocumentReference<InsulinModel>> _update(InsulinModel data) async {
    final ref = _ref.doc(data.id);
    await ref.update(data.toJson());
    return ref;
  }

  Future<void> delete(String id) {
    return _ref.doc(id).update({'deletedAt': Timestamp.now()});
  }
}
