import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/models/user_model.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/widgets/form/dropdown_field.dart';
import 'package:gooday/src/controllers/user_insulin_controller.dart';

class InsulinConfigPage extends StatefulWidget {
  const InsulinConfigPage({super.key});

  @override
  State<InsulinConfigPage> createState() => _InsulinConfigPageState();
}

class _InsulinConfigPageState extends State<InsulinConfigPage> {
  late final UserProvider _userProvider;
  final _formKey = GlobalKey<FormState>();
  final _userInsulinCtrl = UserInsulinController();

  bool _paramError24h = false;

  @override
  initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = _userProvider.data;
    if (user != null) {
      _userInsulinCtrl.initData(user);
    }
  }

  Future<void> _onSubmit() async {
    final now = DateTime.now();
    final hourTotal = _userInsulinCtrl.paramsCtrl.map((param) {
      final startTimeList = param.startTime.split(':');
      final endTimeList = param.endTime.split(':');

      final startHour = int.parse(startTimeList[0]);
      final startMinute = int.parse(startTimeList[1]);
      final endHour = int.parse(endTimeList[0]);
      final endMinute = int.parse(endTimeList[1]);

      final start =
          DateTime(now.year, now.month, now.day, startHour, startMinute);
      final end = DateTime(
        now.year,
        now.month,
        startHour > endHour ? now.day + 1 : now.day,
        endHour,
        endMinute,
      );

      return end.difference(start).inHours;
    }).fold(0, (prev, value) => prev + value);
    final isParamValid =
        _userInsulinCtrl.paramsCtrl.isNotEmpty && hourTotal >= 24;

    setState(() {
      _paramError24h = hourTotal < 24;
    });

    if (_formKey.currentState!.validate() && isParamValid) {
      UtilService(context).loading('Salvando...');

      final config = _userProvider.data!.config!.toJson();
      final data = _userInsulinCtrl.clearValues();

      config['insulin'] = data;
      await _userProvider.update({'config': config});

      if (!mounted) return;

      context.pop();
      context.pop();
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _onParamSubmit(UserConfigInsulinParam item, int? index) {
    setState(() {
      if (index != null) {
        _userInsulinCtrl.paramsCtrl[index] = item;
      } else {
        _userInsulinCtrl.paramsCtrl.add(item);
      }
    });
  }

  void _openParam([int? index]) {
    DateTime? minimum;
    DateTime? maximum;
    UserConfigInsulinParam? param;
    final now = DateTime.now();

    if (index != null) {
      param = _userInsulinCtrl.paramsCtrl[index];
      UserConfigInsulinParam? prevParam;
      UserConfigInsulinParam? nextParam;

      if (index > 0) {
        prevParam = _userInsulinCtrl.paramsCtrl[index - 1];
      }
      if (index < _userInsulinCtrl.paramsCtrl.length - 1) {
        nextParam = _userInsulinCtrl.paramsCtrl[index + 1];
      }

      if (prevParam != null) {
        final endParamPrevList = prevParam.endTime.split(':');
        minimum = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(endParamPrevList[0]),
          int.parse(endParamPrevList[1]),
        );
      }
      if (nextParam != null) {
        final startParamNextList = nextParam.startTime.split(':');
        maximum = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(startParamNextList[0]),
          int.parse(startParamNextList[1]),
        );
      }
    } else if (_userInsulinCtrl.paramsCtrl.isNotEmpty) {
      final endParamLastList =
          _userInsulinCtrl.paramsCtrl.last.endTime.split(':');

      minimum = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(endParamLastList[0]),
        int.parse(endParamLastList[1]),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: _InsulinParamForm(
                  param: param,
                  minimum: minimum,
                  maximum: maximum,
                  onSubmit: (param) => _onParamSubmit(param, index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeParam(int index) {
    setState(() {
      _userInsulinCtrl.paramsCtrl.removeAt(index);
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
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vamos definir seus parâmetros de Insulina?',
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
                          child: DropdownField(
                            label: 'Insulina',
                            isRequired: true,
                            controller: _userInsulinCtrl.insulinCtrl,
                            options: _userInsulinCtrl.insulinList,
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: DropdownField(
                            label: 'Escala',
                            isRequired: true,
                            controller: _userInsulinCtrl.scaleCtrl,
                            options: _userInsulinCtrl.scaleList,
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      label: 'Tempo de ação da insulina',
                      hint: 'min',
                      isRequired: true,
                      inputType: TextInputType.number,
                      controller: _userInsulinCtrl.durationCtrl,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Text(
                              "Parâmetros",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _InsulinParamList(
                            params: _userInsulinCtrl.paramsCtrl,
                            onAdd: _openParam,
                            onEdit: _openParam,
                            onRemoved: _removeParam,
                          ),
                          Visibility(
                            visible: _userInsulinCtrl.paramsCtrl.isNotEmpty &&
                                _paramError24h,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Os horários precisam constar 24 horas no total!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
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
    required this.params,
    required this.onAdd,
    required this.onEdit,
    required this.onRemoved,
  });

  final List<UserConfigInsulinParam> params;
  final VoidCallback onAdd;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onRemoved;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade200,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: params.length + 1,
        padding: const EdgeInsets.symmetric(),
        itemBuilder: (context, index) {
          if (params.length == index) {
            return ListTile(
              onTap: onAdd,
              leading: const Icon(Icons.add_circle, color: Colors.green),
              title: const Text('Adicionar novo parâmetro'),
            );
          }

          final param = params[index];

          return ListTile(
            minLeadingWidth: 20,
            onTap: () => onEdit(index),
            title: Text(
              '${param.startTime} às ${param.endTime}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            subtitle: Text(
              'FC: ${param.fc} - I/C: ${param.ic}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => onRemoved(index),
            ),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}

class _InsulinParamForm extends StatefulWidget {
  const _InsulinParamForm({
    required this.onSubmit,
    this.param,
    this.minimum,
    this.maximum,
  });

  final DateTime? minimum;
  final DateTime? maximum;
  final UserConfigInsulinParam? param;
  final ValueChanged<UserConfigInsulinParam> onSubmit;

  @override
  State<_InsulinParamForm> createState() => _InsulinParamFormState();
}

class _InsulinParamFormState extends State<_InsulinParamForm> {
  final _formKey = GlobalKey<FormState>();

  final _fcCtrl = TextEditingController();
  final _icCtrl = TextEditingController();
  final _endTimeCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.param != null) {
      _startTimeCtrl.text = widget.param!.startTime;
      _endTimeCtrl.text = widget.param!.endTime;
      _fcCtrl.text = widget.param!.fc.toString();
      _icCtrl.text = widget.param!.ic.toString();
    } else if (widget.minimum != null) {
      _startTimeCtrl.text = DateFormat('HH:mm').format(widget.minimum!);
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final param = UserConfigInsulinParam(
        fc: num.parse(_fcCtrl.text),
        ic: num.parse(_icCtrl.text),
        endTime: _endTimeCtrl.text,
        startTime: _startTimeCtrl.text,
      );
      widget.onSubmit(param);
      context.pop();
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _onStartTime() {
    final startTimeList = _startTimeCtrl.text.split(':');

    DateTime initialDateTime = DateTime.now().add(
      Duration(minutes: 5 - DateTime.now().minute % 5),
    );
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
      minuteInterval: 5,
      minimumDate: widget.minimum,
      initialDateTime: widget.minimum ?? initialDateTime,
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
      int.parse(startTimeList[1]) + 5,
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
      minuteInterval: 5,
      maximumDate: widget.maximum,
      initialDateTime: initialDateTime,
      mode: CupertinoDatePickerMode.time,
      onChange: (dateTime) {
        setState(() {
          _endTimeCtrl.text = DateFormat('HH:mm').format(dateTime);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
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
                  child: InputField(
                    label: 'Início',
                    controller: _startTimeCtrl,
                    inputType: TextInputType.number,
                    isRequired: true,
                    readOnly: true,
                    onTap: _onStartTime,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InputField(
                    label: 'Fim',
                    controller: _endTimeCtrl,
                    isDisabled: _startTimeCtrl.text.isEmpty,
                    inputType: TextInputType.number,
                    isRequired: true,
                    readOnly: true,
                    onTap: _onEndTime,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: 'FC',
                    maxLength: 3,
                    isRequired: true,
                    controller: _fcCtrl,
                    inputType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InputField(
                    label: 'I/C',
                    maxLength: 3,
                    isRequired: true,
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
              text: 'Confirmar',
              onPressed: _onSubmit,
            )
          ],
        ),
      ),
    );
  }
}
