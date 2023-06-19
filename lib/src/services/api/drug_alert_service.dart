import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/drug_alert_model.dart';

class DrugAlertApiService {
  final _ref = FirebaseFirestore.instance
      .collection('drug-alerts')
      .withConverter(
          fromFirestore: (snapshot, _) =>
              DrugAlertModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
          toFirestore: (obj, _) => obj.toJson());

  Future<List<DrugAlertModel>> getAll(String userId) async {
    final query = await _ref
        .where('userId', isEqualTo: userId)
        .where('deletedAt', isNull: true)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs.map((doc) => doc.data()).toList();
  }

  Future<DrugAlertModel> save(DrugAlertModel data) async {
    DocumentReference<DrugAlertModel> ref;
    if (data.id != null) {
      ref = await _update(data);
    } else {
      ref = await _add(data);
    }

    final doc = await ref.get();
    return doc.data()!;
  }

  Future<DocumentReference<DrugAlertModel>> _add(DrugAlertModel data) {
    return _ref.add(data);
  }

  Future<DocumentReference<DrugAlertModel>> _update(DrugAlertModel data) async {
    final ref = _ref.doc(data.id);
    await ref.update(data.toJson());
    return ref;
  }

  Future<void> delete(String id) {
    return _ref.doc(id).update({'deletedAt': Timestamp.now()});
  }
}
