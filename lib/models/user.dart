import 'package:gooday/models/base.dart';

class User extends Base {
  final String authId;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? sex;
  final String? dateBirth;
  final UserAnamnese anamnese;

  const User({
    required this.authId,
    required this.name,
    required this.email,
    this.phone,
    this.image,
    this.sex,
    this.dateBirth,
    this.anamnese = const UserAnamnese(),
  });
}

class UserAnamnese {
  final double? height;
  final double? weight;
  final bool? diabete;
  final String? diabeteType;
  final bool? insulin;
  final String? insulinSlow;
  final String? insulinFast;
  final String? drug;

  const UserAnamnese({
    this.height,
    this.weight,
    this.diabete,
    this.diabeteType,
    this.insulin,
    this.insulinSlow,
    this.insulinFast,
    this.drug,
  });
}
