import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/notification_model.dart';

class NotificationApiService {
  final _ref = FirebaseFirestore.instance
      .collection('notifications')
      .withConverter(
          fromFirestore: (snapshot, _) => NotificationModel.fromJson(
              {'id': snapshot.id, ...snapshot.data()!}),
          toFirestore: (obj, _) => obj.toJson());

  Future<List<NotificationModel>> getByDate(
      String userId, DateTime date) async {
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

  Future<void> read(String id) {
    final ref = _ref.doc(id);
    return ref.update({'read': true});
  }
}
