import 'package:flutter/material.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/models/user_model.dart';

class UserInsulinController {
  final insulinCtrl = TextEditingController();
  final scaleCtrl = TextEditingController();
  List<UserConfigInsulinTime> timesCtrl = [];

  final List<Item> insulinList = const [
    Item(id: 'NPH', name: 'NPH'),
    Item(id: 'Lantus', name: 'Lantus'),
    Item(id: 'Tresiba', name: 'Tresiba'),
    Item(id: 'U300', name: 'U300'),
    Item(id: 'Apidra', name: 'Apidra'),
    Item(id: 'Humalog', name: 'Humalog'),
    Item(id: 'Novorapid', name: 'Novorapid'),
    Item(id: 'Fiasp', name: 'Fiasp'),
  ];
  final List<Item> scaleList = const [
    Item(id: '0.1', name: '0.1'),
    Item(id: '0.5', name: '0.5'),
    Item(id: '1.0', name: '1.0'),
  ];

  initData(UserModel user) {
    if (user.config?.insulin != null) {
      insulinCtrl.text = user.config!.insulin!.insulin!;
      scaleCtrl.text = user.config!.insulin!.scale.toString();
      timesCtrl = user.config!.insulin!.times;
    }
  }

  Map<String, dynamic> clearValues() {
    List<Map<String, dynamic>> times =
        timesCtrl.map((val) => val.toJson()).toList();

    return {
      'insulin': insulinCtrl.text,
      'scale': double.parse(scaleCtrl.text),
      'times': times,
    };
  }
}
