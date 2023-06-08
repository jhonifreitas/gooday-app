import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/models/user_model.dart';

class UserController {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final genreCtrl = TextEditingController();
  final dateBirthCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();

  final diabeteTypeCtrl = TextEditingController();
  final insulinSlowCtrl = TextEditingController();
  final insulinFastCtrl = TextEditingController();
  final drugCtrl = TextEditingController();

  bool? diabeteCtrl;
  bool? insulinCtrl;

  final List<Item> genreList = const [
    Item(id: 'masc', name: 'Masculino'),
    Item(id: 'fem', name: 'Feminino'),
    Item(id: 'other', name: 'Outro'),
  ];
  final List<Item> diabeteTypeList = const [
    Item(id: 'type-1', name: 'Tipo 1'),
    Item(id: 'type-2', name: 'Tipo 2'),
    // Item(id: 'pre', name: 'Pré-Diabetes'),
  ];
  final List<Item> insulinSlowList = const [
    Item(id: 'NPH', name: 'NPH'),
    Item(id: 'Lantus', name: 'Lantus'),
    Item(id: 'Tresiba', name: 'Tresiba'),
    Item(id: 'U300', name: 'U300'),
  ];
  final List<Item> insulinFastList = const [
    Item(id: 'Apidra', name: 'Apidra'),
    Item(id: 'Humalog', name: 'Humalog'),
    Item(id: 'Novorapid', name: 'Novorapid'),
    Item(id: 'Fiasp', name: 'Fiasp'),
  ];
  final List<Item> scaleInsulinList = const [
    Item(id: '0.1', name: '0.1'),
    Item(id: '0.5', name: '0.5'),
    Item(id: '1.0', name: '1.0'),
  ];

  initData(UserModel data) {
    if (data.name != null) nameCtrl.text = data.name!;
    if (data.email != null) emailCtrl.text = data.email!;
    if (data.phone != null) phoneCtrl.text = data.phone!;
    if (data.genre != null) genreCtrl.text = data.genre!;
    if (data.dateBirth != null) {
      dateBirthCtrl.text = DateFormat('dd/MM/yyyy').format(data.dateBirth!);
    }

    if (data.anamnese != null) {
      if (data.anamnese!.height != null) {
        heightCtrl.text = data.anamnese!.height.toString();
        if (heightCtrl.text.length == 3) heightCtrl.text += '0';
      }
      if (data.anamnese!.weight != null) {
        weightCtrl.text = data.anamnese!.weight.toString();
      }
      if (data.anamnese!.diabeteType != null) {
        diabeteTypeCtrl.text = data.anamnese!.diabeteType!;
        if (diabeteTypeCtrl.text.isNotEmpty) diabeteCtrl = true;
      }
      if (data.anamnese!.insulin != null) {
        insulinCtrl = data.anamnese!.insulin;
      }
      if (data.anamnese!.insulinSlow != null) {
        insulinSlowCtrl.text = data.anamnese!.insulinSlow!;
      }
      if (data.anamnese!.insulinFast != null) {
        insulinFastCtrl.text = data.anamnese!.insulinFast!;
      }
      if (data.anamnese!.drug != null) {
        drugCtrl.text = data.anamnese!.drug!;
      }
    }
  }

  String? clearPhone() {
    if (phoneCtrl.text.isNotEmpty) {
      return phoneCtrl.text.replaceAll(RegExp('[^0-9]'), '');
    }
    return phoneCtrl.text;
  }

  DateTime? clearDateBirth() {
    if (dateBirthCtrl.text.isNotEmpty) {
      return DateFormat('dd/MM/yyyy').parse(dateBirthCtrl.text);
    }
    return null;
  }

  double? clearHeight() {
    if (heightCtrl.text.isNotEmpty) {
      return double.parse(heightCtrl.text.replaceAll(RegExp(r','), '.'));
    }
    return null;
  }

  double? clearWeight() {
    if (weightCtrl.text.isNotEmpty) {
      String value = weightCtrl.text.replaceAll(RegExp(r','), '.');
      if (!value.contains('.')) value += '.0';
      return double.parse(value);
    }
    return null;
  }
}
