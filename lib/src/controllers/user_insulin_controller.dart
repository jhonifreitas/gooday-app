import 'package:flutter/material.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/models/user_model.dart';

class UserInsulinController {
  final insulinCtrl = TextEditingController();
  final scaleCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  List<UserConfigInsulinParam> paramsCtrl = [];

  final List<Item> insulinList = const [
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
      insulinCtrl.text = user.config!.insulin!.insulin;
      scaleCtrl.text = user.config!.insulin!.scale.toString();
      durationCtrl.text = user.config!.insulin!.duration.toString();
      paramsCtrl = user.config!.insulin!.params;
    }
  }

  Map<String, dynamic> clearValues() {
    List<Map<String, dynamic>> params =
        paramsCtrl.map((val) => val.toJson()).toList();

    return {
      'insulin': insulinCtrl.text,
      'scale': double.parse(scaleCtrl.text),
      'duration': int.parse(durationCtrl.text),
      'params': params,
    };
  }
}
