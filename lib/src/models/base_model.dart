import 'package:cloud_firestore/cloud_firestore.dart';

class BaseModel {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const BaseModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      id: json['id'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      deletedAt: json['deletedAt'] != null
          ? (json['deletedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt ?? DateTime.now(),
      'updatedAt': updatedAt ?? (createdAt != null ? DateTime.now() : null),
      'deletedAt': deletedAt
    };
  }
}
