import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:gooday/src/models/insulin_model.dart';

class InsulinController {
  final dateCtrl = TextEditingController();
  final valueCtrl = TextEditingController();

  initData(InsulinModel data) {
    valueCtrl.text = data.value.toString();
    dateCtrl.text = DateFormat('dd/MM/yyyy HH:mm').format(data.date);
  }

  DateTime clearDate() {
    return DateFormat('dd/MM/yyyy HH:mm').parse(dateCtrl.text);
  }

  num clearValue() {
    return num.parse(valueCtrl.text);
  }
}
