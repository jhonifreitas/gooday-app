import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/models/glycemia_model.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/widgets/form/checkbox_field.dart';
import 'package:gooday/src/services/api/glycemia_service.dart';
import 'package:gooday/src/controllers/glycemia_controller.dart';

class GlycemiaPage extends StatefulWidget {
  const GlycemiaPage({this.data, super.key});

  final GlycemiaModel? data;

  @override
  State<GlycemiaPage> createState() => _GlycemiaPageState();
}

class _GlycemiaPageState extends State<GlycemiaPage> {
  final _formKey = GlobalKey<FormState>();
  final _glycemiaApi = GlycemiaApiService();
  final _glycemiaCtrl = GlycemiaController();

  @override
  initState() {
    super.initState();
    if (widget.data != null) {
      _glycemiaCtrl.initData(widget.data!);
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');
      final userProvider = context.read<UserProvider>();
      final data = widget.data ?? GlycemiaModel(userId: userProvider.data!.id!);

      data.date = _glycemiaCtrl.clearDate();
      data.type = _glycemiaCtrl.clearType();
      data.value = _glycemiaCtrl.clearValue();

      await _glycemiaApi.save(data);

      if (!mounted) return;

      context.pop();
      context.pop(data);

      UtilService(context).message('Glicemia salva!');
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _onType(String id, bool selected) {
    setState(() {
      if (selected) {
        _glycemiaCtrl.typeCtrl.text = id;
      } else {
        _glycemiaCtrl.typeCtrl.clear();
      }
    });
  }

  void _onDate() {
    DateTime initialDateTime = DateTime.now();
    if (_glycemiaCtrl.dateCtrl.text.isNotEmpty) {
      initialDateTime =
          DateFormat('dd/MM/yyyy HH:mm').parse(_glycemiaCtrl.dateCtrl.text);
    }

    UtilService(context).dateTimePicker(
      maximumDate: DateTime.now(),
      initialDateTime: initialDateTime,
      mode: CupertinoDatePickerMode.dateAndTime,
      onChange: (dateTime) {
        setState(() {
          _glycemiaCtrl.dateCtrl.text =
              DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
        });
      },
    );
  }

  Future<bool> _openDeleteConfirm() async {
    final dialog = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remover?'),
          content: const Text('Deseja realmente remover está glicemia?'),
          actions: [
            TextButton(
              child: const Text('Não'),
              onPressed: () => context.pop(false),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(Colors.red),
                overlayColor:
                    MaterialStatePropertyAll(Colors.red.withOpacity(0.1)),
              ),
              child: const Text('Sim'),
              onPressed: () => context.pop(true),
            ),
          ],
        );
      },
    );
    return dialog ?? false;
  }

  Future<void> _onDelete() async {
    if (widget.data != null) {
      final confirmed = await _openDeleteConfirm();

      if (confirmed && mounted) {
        UtilService(context).loading('Removendo...');

        await _glycemiaApi.delete(widget.data!.id!);

        if (!mounted) return;

        context.pop();
        context.pop('deleted');

        UtilService(context).message('Glicemia removida!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SizedBox> types = [];
    for (final item in _glycemiaCtrl.typeList) {
      final type = SizedBox(
        width: (MediaQuery.of(context).size.width) / 2,
        child: CheckboxField(
          selected: _glycemiaCtrl.typeCtrl.text == item.id,
          text: item.name,
          isRequired: _glycemiaCtrl.typeCtrl.text.isEmpty,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          onSelected: (value) => _onType(item.id, value),
        ),
      );
      types.add(type);
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
                      'Registrar Glicemia',
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InputField(
                  label: 'Informe sua glicemia',
                  hint: '000 mg/dL',
                  controller: _glycemiaCtrl.valueCtrl,
                  isRequired: true,
                  inputType: TextInputType.number,
                  maxLength: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InputField(
                  label: 'Data e Hora',
                  controller: _glycemiaCtrl.dateCtrl,
                  onTap: _onDate,
                  readOnly: true,
                  isRequired: true,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text('Selecione o tipo de glicemia'),
              ),
              Wrap(
                children: types,
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
