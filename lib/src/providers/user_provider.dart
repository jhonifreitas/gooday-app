import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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
    final docRef = await _ref.add(data);
    final doc = await docRef.get();
    _data = doc.data();
    notifyListeners();
  }

  Future<void> update(Map<String, dynamic> data) async {
    if (_data?.id != null) {
      final query = _ref.doc(_data!.id);
      data.addAll({'updatedAt': DateTime.now()});
      await query.update(data);

      final doc = await query.get();
      _data = doc.data();

      _updateFbUser();
      notifyListeners();
    }
  }

  Future<void> uploadImage(File file) async {
    if (_data?.id != null) {
      final ref =
          FirebaseStorage.instance.refFromURL('users/${_data!.id}/image.png');
      final snapshot = await ref.putFile(file);
      await update({'image': snapshot.ref.fullPath});
    }
  }

  Future<void> _updateFbUser() async {
    final fbUser = FirebaseAuth.instance.currentUser;

    if (fbUser != null) {
      if (_data?.name != null && _data!.email!.isNotEmpty) {
        await fbUser.updateDisplayName(_data!.name!);
      }
      if (_data?.email != null && _data!.email!.isNotEmpty) {
        await fbUser.updateEmail(_data!.email!);
      }
      if (_data?.image != null && _data!.email!.isNotEmpty) {
        await fbUser.updatePhotoURL(_data!.image!);
      }
    }
  }
}
