import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/models/glycemia_model.dart';

class GlycemiaController {
  final typeCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final valueCtrl = TextEditingController();

  final List<Item> typeList = [
    Item(id: GlycemiaType.beforeBreakfast.name, name: 'Antes do Café'),
    Item(id: GlycemiaType.afterBreakfast.name, name: 'Depois do Café'),
    Item(id: GlycemiaType.beforeLunch.name, name: 'Antes do Almoço'),
    Item(id: GlycemiaType.afterLunch.name, name: 'Depois do Almoço'),
    Item(id: GlycemiaType.beforeDinner.name, name: 'Antes do Jantar'),
    Item(id: GlycemiaType.afterDinner.name, name: 'Depois do Jantar'),
    Item(id: GlycemiaType.sleep.name, name: 'Ao dormir/Madrugada'),
  ];

  initData(GlycemiaModel data) {
    typeCtrl.text = data.type.name;
    valueCtrl.text = data.value.toString();
    dateCtrl.text = DateFormat('dd/MM/yyyy HH:mm').format(data.date);
  }

  DateTime clearDate() {
    return DateFormat('dd/MM/yyyy HH:mm').parse(dateCtrl.text);
  }

  GlycemiaType clearType() {
    return GlycemiaType.values
        .firstWhere((value) => value.name == typeCtrl.text);
  }

  num clearValue() {
    return num.parse(valueCtrl.text);
  }
}
