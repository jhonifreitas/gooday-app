import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/controllers/user_controller.dart';

class InsulinConfigPage extends StatefulWidget {
  const InsulinConfigPage({super.key});

  @override
  State<InsulinConfigPage> createState() => _InsulinConfigPageState();
}

class _InsulinConfigPageState extends State<InsulinConfigPage> {
  final _userCtrl = UserController();

  final List<Item> _paramList = [];

  void _onSubmit() async {
    // if () {
    //   UtilService(context).loading('Salvando...');
    //   final data = _userCtrl.onSerialize();

    //   if (!mounted) return;

    //   context.pop();
    //   context.pop();
    // } else {
    //   UtilService(context).message('Verifique os campos destacados!');
    // }
  }

  void _onParamSubmit(Item item, int? index) {
    setState(() {
      if (index != null) {
        _paramList[index] = item;
      } else {
        _paramList.add(item);
      }
    });
  }

  void _onParam([int? index]) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: _InsulinParam(
            item: index != null ? _paramList[index] : null,
            onSubmit: (item) => _onParamSubmit(item, index),
          ),
        );
      },
    );
  }

  void _onParamRemove(int index) {
    setState(() {
      _paramList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: [
            AppBarCustom(
              iconBackColor: primaryColor,
              title: Image.asset('assets/images/logo.png', width: 80),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Como anda sua Insulina?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                      'Informe os parametros receitados pelo seu '
                      'endocrinologista',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FormFieldCustom(
                          label: 'Insulina',
                          controller: _userCtrl.nameCtrl,
                          isDropdown: true,
                          options: _userCtrl.insulinFastList,
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: FormFieldCustom(
                          label: 'Escala',
                          controller: _userCtrl.nameCtrl,
                          isDropdown: true,
                          options: _userCtrl.scaleInsulinList,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Aplicações",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 26,
                                child: FilledButton.tonal(
                                  onPressed: _onParam,
                                  child: const Text(
                                    'Adicionar',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: _paramList.isEmpty,
                          child: const Padding(
                            padding: EdgeInsets.only(
                                bottom: 10, left: 20, right: 20),
                            child: Text(
                              'Adicione uma aplicação para ser mostrado aqui!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _paramList.isNotEmpty,
                          child: _InsulinParamList(
                            items: _paramList,
                            onSelected: _onParam,
                            onRemoved: _onParamRemove,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "* FC - Fator de Correção",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "* I/C - Relação Insulina/Carboidrato",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(width: 10, color: Colors.white),
          ),
          backgroundColor: primaryColor,
          onPressed: _onSubmit,
          child: const Icon(Icons.check, color: Colors.white),
        ),
      ),
    );
  }
}

class _InsulinParamList extends StatelessWidget {
  const _InsulinParamList({
    required this.items,
    required this.onSelected,
    required this.onRemoved,
  });

  final List<Item> items;
  final ValueChanged<int> onSelected;
  final ValueChanged<int> onRemoved;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade200,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            ListTile(
              minLeadingWidth: 20,
              onTap: () => onSelected(i),
              title: Text(
                items[i].name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              subtitle: Text(
                'Início: 8:00 - Fim: 10:00',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
              leading: SvgPicture.asset(
                'assets/icons/edit-square.svg',
                width: 20,
                colorFilter: const ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              trailing: IconButton(
                icon:
                    const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => onRemoved(i),
              ),
            )
        ],
      ),
    );
  }
}

class _InsulinParam extends StatefulWidget {
  const _InsulinParam({required this.onSubmit, this.item});

  final Item? item;
  final ValueChanged<Item> onSubmit;

  @override
  State<_InsulinParam> createState() => _InsulinParamState();
}

class _InsulinParamState extends State<_InsulinParam> {
  final _fcCtrl = TextEditingController();
  final _icCtrl = TextEditingController();
  final _endTimeCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();

  void _onStartTime() {
    final startTimeList = _startTimeCtrl.text.split(':');

    DateTime initialDateTime = DateTime.now();
    if (_startTimeCtrl.text.isNotEmpty) {
      initialDateTime = DateTime(
        initialDateTime.year,
        initialDateTime.month,
        initialDateTime.day,
        int.parse(startTimeList[0]),
        int.parse(startTimeList[1]),
      );
    }

    UtilService(context).dateTimePicker(
      initialDateTime: initialDateTime,
      mode: CupertinoDatePickerMode.time,
      onChange: (dateTime) {
        setState(() {
          _startTimeCtrl.text = DateFormat('HH:mm').format(dateTime);
        });
      },
    );
  }

  void _onEndTime() {
    final now = DateTime.now();
    final startTimeList = _startTimeCtrl.text.split(':');

    DateTime initialDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(startTimeList[0]),
      int.parse(startTimeList[1]),
    );
    if (_endTimeCtrl.text.isNotEmpty) {
      final endTimeList = _endTimeCtrl.text.split(':');
      initialDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(endTimeList[0]),
        int.parse(endTimeList[1]),
      );
    }

    UtilService(context).dateTimePicker(
      minimumDate: initialDateTime,
      initialDateTime: initialDateTime,
      mode: CupertinoDatePickerMode.time,
      onChange: (dateTime) {
        setState(() {
          _endTimeCtrl.text = DateFormat('HH:mm').format(dateTime);
        });
      },
    );
  }

  void _onSubmit() {
    const item = Item(id: '123', name: 'asd');
    widget.onSubmit(item);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Parametros de Aplicação',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FormFieldCustom(
                  label: 'Início',
                  controller: _startTimeCtrl,
                  inputType: TextInputType.number,
                  readOnly: true,
                  onTap: _onStartTime,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FormFieldCustom(
                  label: 'Fim',
                  controller: _endTimeCtrl,
                  isDisabled: _startTimeCtrl.text.isEmpty,
                  inputType: TextInputType.number,
                  readOnly: true,
                  onTap: _onEndTime,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormFieldCustom(
                  label: 'FC',
                  maxLength: 3,
                  controller: _fcCtrl,
                  inputType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FormFieldCustom(
                  label: 'I/C',
                  maxLength: 3,
                  controller: _icCtrl,
                  inputType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "* FC - Fator de Correção",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            "* I/C - Relação Insulina/Carboidrato",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          ButtonCustom(
            text: 'Salvar',
            onPressed: _onSubmit,
          )
        ],
      ),
    );
  }
}
