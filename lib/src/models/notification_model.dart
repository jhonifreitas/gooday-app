import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/base_model.dart';

class NotificationModel extends BaseModel {
  String userId;
  String title;
  String message;
  NotificationType type;
  String? image;
  DateTime? read;

  NotificationModel({
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.image,
    this.read,
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
      type: NotificationType.values
          .firstWhere((value) => value.name == (json['type'] as String)),
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
    json['type'] = type.name;
    json['read'] = read;
    return json;
  }
}

enum NotificationType { alert }
