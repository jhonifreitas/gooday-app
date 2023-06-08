import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/food_model.dart';

class FoodApiService {
  final _ref = FirebaseFirestore.instance.collection('foods').withConverter(
      fromFirestore: (snapshot, _) =>
          FoodModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<List<FoodModel>> getAll() async {
    final query = await _ref.orderBy('name').get();
    return query.docs.map((doc) => doc.data()).toList();
  }
}
