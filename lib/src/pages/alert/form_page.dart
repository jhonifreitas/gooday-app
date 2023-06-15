import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/models/alert_model.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/services/api/alert_service.dart';
import 'package:gooday/src/controllers/alert_controller.dart';

class AlertFormPage extends StatefulWidget {
  const AlertFormPage({this.data, super.key});

  final AlertModel? data;

  @override
  State<AlertFormPage> createState() => _AlertFormPageState();
}

class _AlertFormPageState extends State<AlertFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _alertApi = AlertApiService();
  final _alertCtrl = AlertController();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) _alertCtrl.initData(widget.data!);
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');
      final userProvider = context.read<UserProvider>();
      final data = widget.data ?? AlertModel(userId: userProvider.data!.id!);

      data.title = _alertCtrl.titleCtrl.text;
      data.message = _alertCtrl.messageCtrl.text;
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
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Alerta',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InputField(
                  label: 'Titúlo',
                  controller: _alertCtrl.titleCtrl,
                  isRequired: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InputField(
                  label: 'Mensagem',
                  controller: _alertCtrl.messageCtrl,
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
