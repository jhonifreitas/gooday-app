import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/drug_model.dart';

class DrugApiService {
  final _ref = FirebaseFirestore.instance.collection('drugs').withConverter(
      fromFirestore: (snapshot, _) =>
          DrugModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<List<DrugModel>> getAll() async {
    final query = await _ref.orderBy('name').get();
    return query.docs.map((doc) => doc.data()).toList();
  }
}
