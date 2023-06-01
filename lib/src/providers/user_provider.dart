import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:gooday/src/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _data;

  UserModel? get data => _data;

  final _ref = FirebaseFirestore.instance.collection('users').withConverter(
      fromFirestore: (snapshot, _) =>
          UserModel.fromJson({'id': snapshot.id, ...snapshot.data()!}),
      toFirestore: (obj, _) => obj.toJson());

  Future<void> getByAuthId(String authId) async {
    final query = await _ref.where('authId', isEqualTo: authId).get();

    if (query.docs.isNotEmpty) {
      _data = query.docs.first.data();
      notifyListeners();
    }
  }

  Future<void> add(UserModel data) async {
    await _ref.add(data);
    _data = data;
    notifyListeners();
  }

  Future<void> update(Map<String, dynamic> data) async {
    if (_data != null) {
      final query = _ref.doc(_data!.id);
      data['updatedAt'] = DateTime.now();
      await query.update(data);
      final doc = await query.get();
      _data = doc.data();
      notifyListeners();
    }
  }

  Future<void> uploadImage(File file) async {
    final ref =
        FirebaseStorage.instance.refFromURL('users/${_data!.id}/image.png');
    final snapshot = await ref.putFile(file);
    await update({'image': snapshot.ref.fullPath});
  }
}
