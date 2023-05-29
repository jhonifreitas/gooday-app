import 'package:flutter/material.dart';
import 'package:gooday/models/user.dart';
import 'package:gooday/models/option.dart';

class UserController {
  final User data = const User(authId: '', name: '', email: '');

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final sexCtrl = TextEditingController();
  final dateBirthCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  final insulinSlowCtrl = TextEditingController();
  final insulinFastCtrl = TextEditingController();
  final drugCtrl = TextEditingController();

  bool? diabeteCtrl;
  String? diabeteTypeCtrl;
  bool? insulinCtrl;

  final List<Option> sexList = const [
    Option(id: 'masc', name: 'Masculino'),
    Option(id: 'fem', name: 'Feminino'),
    Option(id: 'other', name: 'Outro'),
  ];
  final List<Option> diabeteTypeList = const [
    Option(id: 'type-1', name: 'Tipo 1'),
    Option(id: 'type-2', name: 'Tipo 2'),
    // Option(id: 'pre', name: 'Pré-Diabetes'),
  ];
  final List<Option> insulinSlowList = const [
    Option(id: 'NPH', name: 'NPH'),
    Option(id: 'Lantus', name: 'Lantus'),
    Option(id: 'Tresiba', name: 'Tresiba'),
    Option(id: 'U300', name: 'U300'),
  ];
  final List<Option> insulinFastList = const [
    Option(id: 'Apidra', name: 'Apidra'),
    Option(id: 'Humalog', name: 'Humalog'),
    Option(id: 'Novorapid', name: 'Novorapid'),
    Option(id: 'Fiasp', name: 'Fiasp'),
  ];
  final List<Option> drugList = const [
    Option(id: 'drug-3', name: 'Medicamento 1'),
    Option(id: 'drug-2', name: 'Medicamento 2'),
    Option(id: 'drug-3', name: 'Medicamento 3'),
  ];
}
