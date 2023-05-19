import 'package:gooday/models/base.dart';

class User extends Base {
  final String name;
  final String email;
  final String? phone;
  final String? image;

  const User({required this.name, required this.email, this.phone, this.image});
}
