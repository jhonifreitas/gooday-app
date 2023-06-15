import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/base_model.dart';

class NotificationModel extends BaseModel {
  String userId;
  String title;
  String message;
  String? image;
  DateTime? read;
  Map<String, dynamic>? params;

  NotificationModel({
    required this.userId,
    required this.title,
    required this.message,
    this.image,
    this.read,
    this.params,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return NotificationModel(
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      image: json['image'],
      read: (json['read'] as Timestamp?)?.toDate(),
      params: json['params'],
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      deletedAt: base.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['userId'] = userId;
    json['title'] = title;
    json['message'] = message;
    json['image'] = image;
    json['params'] = params;
    json['read'] = read;
    return json;
  }
}
