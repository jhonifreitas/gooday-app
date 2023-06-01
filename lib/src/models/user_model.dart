import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gooday/src/models/base_model.dart';

class UserModel extends BaseModel {
  final String authId;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? genre;
  final DateTime? dateBirth;
  final UserAnamnese? anamnese;

  UserModel({
    this.authId = '',
    this.name = '',
    this.email = '',
    this.phone,
    this.image,
    this.genre,
    this.dateBirth,
    this.anamnese,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromJson(json);
    final dateBirth = json['dateBirth'];

    return UserModel(
      authId: json['authId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      genre: json['genre'],
      dateBirth: dateBirth != null && dateBirth != ''
          ? (dateBirth as Timestamp).toDate()
          : null,
      anamnese: UserAnamnese.fromJson(json['anamnese'] ?? {}),
      id: base.id,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      deletedAt: base.deletedAt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['authId'] = authId;
    json['name'] = name;
    json['email'] = email;
    json['phone'] = phone;
    json['image'] = image;
    json['genre'] = genre;
    json['dateBirth'] = dateBirth;
    json['anamnese'] = anamnese;
    return json;
  }
}

class UserAnamnese {
  double? height;
  double? weight;
  String? diabeteType;
  bool? insulin;
  String? insulinSlow;
  String? insulinFast;
  String? drug;

  UserAnamnese({
    this.height,
    this.weight,
    this.diabeteType,
    this.insulin,
    this.insulinSlow,
    this.insulinFast,
    this.drug,
  });

  UserAnamnese.fromJson(Map<String, dynamic> json)
      : this(
          height: json['height'],
          weight: json['weight'],
          diabeteType: json['diabeteType'],
          insulin: json['insulin'],
          insulinSlow: json['insulinSlow'],
          insulinFast: json['insulinFast'],
          drug: json['drug'],
        );

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'weight': weight,
      'diabeteType': diabeteType,
      'insulin': insulin,
      'insulinSlow': insulinSlow,
      'insulinFast': insulinFast,
      'drug': drug,
    };
  }
}
