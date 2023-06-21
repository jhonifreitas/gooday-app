import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/models/insulin_model.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/services/api/insulin_service.dart';
import 'package:gooday/src/controllers/insulin_controller.dart';

class InsulinPage extends StatefulWidget {
  const InsulinPage(
      {this.data, this.insulinActive, this.valueRecommended, super.key});

  final InsulinModel? data;
  final num? insulinActive;
  final num? valueRecommended;

  @override
  State<InsulinPage> createState() => _InsulinPageState();
}

class _InsulinPageState extends State<InsulinPage> {
  final _formKey = GlobalKey<FormState>();
  final _insulinApi = InsulinApiService();
  final _insulinCtrl = InsulinController();

  @override
  initState() {
    super.initState();
    if (widget.data != null) {
      _insulinCtrl.initData(widget.data!);
    } else {
      if (widget.valueRecommended != null) {
        _insulinCtrl.valueCtrl.text =
            widget.valueRecommended!.toStringAsFixed(2);
      }

      final date = DateTime.now().subtract(
        Duration(minutes: DateTime.now().minute % 5),
      );
      _insulinCtrl.dateCtrl.text = DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }

  String get _insuliActiveStr {
    return widget.insulinActive!.toStringAsFixed(2);
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final data = widget.data ?? InsulinModel(userId: userProvider.data!.id!);

      data.date = _insulinCtrl.clearDate();
      data.value = _insulinCtrl.clearValue();

      await _insulinApi.save(data);

      if (!mounted) return;

      context.pop();
      context.pop(data);

      UtilService(context).message('Aplicação de insulina salva!');
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _onDate() {
    final maximumDate = DateTime.now().subtract(
      Duration(minutes: DateTime.now().minute % 5),
    );
    DateTime initialDateTime = maximumDate;
    if (_insulinCtrl.dateCtrl.text.isNotEmpty) {
      initialDateTime =
          DateFormat('dd/MM/yyyy HH:mm').parse(_insulinCtrl.dateCtrl.text);
    }

    UtilService(context).dateTimePicker(
      minuteInterval: 5,
      maximumDate: maximumDate,
      initialDateTime: initialDateTime,
      mode: CupertinoDatePickerMode.dateAndTime,
      onChange: (dateTime) {
        setState(() {
          _insulinCtrl.dateCtrl.text =
              DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
        });
      },
    );
  }

  Future<void> _onDelete() async {
    if (widget.data != null) {
      final confirmed = await UtilService(context).dialogConfirm('Remover?',
          'Deseja realmente remover este registro de aplicação de insulina?');

      if (confirmed && mounted) {
        UtilService(context).loading('Removendo...');

        await _insulinApi.delete(widget.data!.id!);

        if (!mounted) return;

        context.pop();
        context.pop('deleted');

        UtilService(context).message('Aplicação de insulina removida!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String text = 'De acordo com os dados fornecidos, não sugerímos aplicação '
        'de insulina.';
    String textConfirm = 'Deseja realmente aplicar?';

    if (widget.valueRecommended != null) {
      text = 'De acordo com o seu perfil, sugerímos a dose abaixo.';
      textConfirm = 'Deseja aplicar?';
    }

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
                      'Aplicação de Insulina',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    widget.data != null
                        ? IconButton(
                            onPressed: _onDelete,
                            icon: const Icon(Icons.delete, color: Colors.red),
                          )
                        : const SizedBox(width: 40)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (widget.insulinActive != null)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 40, right: 40),
                  child: Text.rich(
                    TextSpan(
                      text: 'Pelos seus registros, você possui ',
                      children: [
                        TextSpan(
                          text: '${_insuliActiveStr}u ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: 'de Insulina circulante.')
                      ],
                    ),
                  ),
                ),
              if (widget.data == null)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 40, right: 40),
                  child: Text.rich(
                    TextSpan(
                      text: '$text\n',
                      children: [
                        TextSpan(
                          text: textConfirm,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InputField(
                  label: 'Dose',
                  maxLength: 3,
                  isRequired: true,
                  inputType: TextInputType.number,
                  controller: _insulinCtrl.valueCtrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InputField(
                  label: 'Data e Hora',
                  onTap: _onDate,
                  readOnly: true,
                  isRequired: true,
                  controller: _insulinCtrl.dateCtrl,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ButtonCustom(
                  text: widget.data == null ? 'Aplicar' : 'Editar',
                  onPressed: _onSubmit,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
