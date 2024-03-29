import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/drug_list.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/models/drug_alert_model.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/widgets/form/dropdown_field.dart';
import 'package:gooday/src/controllers/alert_controller.dart';
import 'package:gooday/src/services/api/drug_alert_service.dart';

class AlertFormPage extends StatefulWidget {
  const AlertFormPage({this.data, super.key});

  final DrugAlertModel? data;

  @override
  State<AlertFormPage> createState() => _AlertFormPageState();
}

class _AlertFormPageState extends State<AlertFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _alertApi = DrugAlertApiService();
  final _alertCtrl = DrugAlertController();
  final _drugsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _alertCtrl.initData(widget.data!);
      _drugsCtrl.text = _alertCtrl.drugsCtrl.join(', ');
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final data =
          widget.data ?? DrugAlertModel(userId: userProvider.data!.id!);

      data.drugs = _alertCtrl.drugsCtrl;
      data.period = int.parse(_alertCtrl.periodCtrl.text);
      data.time = _alertCtrl.timeCtrl.text;

      await _alertApi.save(data);

      if (!mounted) return;

      context.pop();
      context.pop(data);

      UtilService(context).message('Alerta salvo!');
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  Future<void> _onDelete() async {
    if (widget.data != null) {
      final confirmed = await UtilService(context)
          .dialogConfirm('Remover?', 'Deseja realmente remover este alerta?');

      if (confirmed && mounted) {
        UtilService(context).loading('Removendo...');

        await _alertApi.delete(widget.data!.id!);

        if (!mounted) return;

        context.pop();
        context.pop('deleted');

        UtilService(context).message('Alerta removido!');
      }
    }
  }

  void _onDrug(String id, bool selected) {
    setState(() {
      if (selected) {
        _alertCtrl.drugsCtrl.add(id);
      } else {
        final index = _alertCtrl.drugsCtrl.indexWhere((drug) => drug == id);
        _alertCtrl.drugsCtrl.removeAt(index);
      }

      _drugsCtrl.text = _alertCtrl.drugsCtrl.join(', ');
    });
  }

  void _openDrug() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DrugList(
          onSelected: _onDrug,
          selecteds: _alertCtrl.drugsCtrl,
        );
      },
    );
  }

  void _onDate() {
    DateTime initialDateTime = DateTime.now().add(
      Duration(minutes: 5 - DateTime.now().minute % 5),
    );
    if (_alertCtrl.timeCtrl.text.isNotEmpty) {
      final timeList = _alertCtrl.timeCtrl.text.split(':');
      initialDateTime = DateTime(
        initialDateTime.year,
        initialDateTime.month,
        initialDateTime.day,
        int.parse(timeList[0]),
        int.parse(timeList[1]),
      );
    }

    UtilService(context).dateTimePicker(
      minuteInterval: 5,
      initialDateTime: initialDateTime,
      mode: CupertinoDatePickerMode.time,
      onChange: (dateTime) {
        setState(() {
          _alertCtrl.timeCtrl.text = DateFormat('HH:mm').format(dateTime);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    const Text(
                      'Alerta',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    widget.data != null
                        ? IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: _onDelete,
                          )
                        : const SizedBox(width: 40)
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InputField(
                  label: 'Medicamentos',
                  controller: _drugsCtrl,
                  isRequired: true,
                  readOnly: true,
                  onTap: _openDrug,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: DropdownField(
                  label: 'Período',
                  options: _alertCtrl.periodList,
                  controller: _alertCtrl.periodCtrl,
                  isRequired: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InputField(
                  label: 'Hora',
                  controller: _alertCtrl.timeCtrl,
                  onTap: _onDate,
                  readOnly: true,
                  isRequired: true,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ButtonCustom(text: 'Salvar', onPressed: _onSubmit),
              )
            ],
          ),
        ),
      ),
    );
  }
}
