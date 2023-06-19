import 'package:flutter/material.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/models/drug_alert_model.dart';

class DrugAlertController {
  final periodCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  List<String> drugsCtrl = [];

  List<Item> periodList = const [
    Item(id: '1', name: 'Diario'),
    Item(id: '2', name: 'A cada 2 dias'),
    Item(id: '3', name: 'A cada 3 dias'),
    Item(id: '5', name: 'A cada 5 dias'),
    Item(id: '7', name: 'Semanal'),
  ];

  initData(DrugAlertModel data) {
    drugsCtrl = data.drugs;
    periodCtrl.text = data.period.toString();
    timeCtrl.text = data.time;
  }

  int cleaPeriod() {
    return int.parse(periodCtrl.text);
  }
}
