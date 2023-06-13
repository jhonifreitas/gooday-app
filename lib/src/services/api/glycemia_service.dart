import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/glycemia_model.dart';

class GlycemiaApiService {
  final _ref = FirebaseFirestore.instance.collection('glycemias').withConverter(
      fromFirestore: (snapshot, _) =>
          GlycemiaModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<List<GlycemiaModel>> getByRangeDate(
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

  Future<GlycemiaModel> save(GlycemiaModel data) async {
    DocumentReference<GlycemiaModel> ref;
    if (data.id != null) {
      ref = await _update(data);
    } else {
      ref = await _add(data);
    }

    final doc = await ref.get();
    return doc.data()!;
  }

  Future<DocumentReference<GlycemiaModel>> _add(GlycemiaModel data) {
    return _ref.add(data);
  }

  Future<DocumentReference<GlycemiaModel>> _update(GlycemiaModel data) async {
    final ref = _ref.doc(data.id);
    await ref.update(data.toJson());
    return ref;
  }

  Future<void> delete(String id) {
    return _ref.doc(id).update({'deletedAt': Timestamp.now()});
  }
}
