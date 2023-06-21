import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/base_model.dart';

class InsulinModel extends BaseModel {
  String userId;
  num value;
  DateTime date;

  InsulinModel({
    required this.userId,
    DateTime? date,
    this.value = 0,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  })  : date = date ?? DateTime.now(),
        super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  factory InsulinModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);

    return InsulinModel(
      userId: json['userId'],
      value: json['value'],
      date: (json['date'] as Timestamp).toDate(),
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
    json['date'] = date;
    json['value'] = value;
    return json;
  }
}

class InsulinCalc {
  num active = 0;
  num recommended = 0;
}
