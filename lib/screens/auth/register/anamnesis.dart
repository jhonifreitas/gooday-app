import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:gooday/controllers/user.controller.dart';

import 'package:gooday/components/chip.dart';
import 'package:gooday/components/form_field.dart';
import 'package:gooday/controllers/util.controller.dart';

class AuthRegisterAnamnesisScreen extends StatefulWidget {
  const AuthRegisterAnamnesisScreen({super.key});

  @override
  State<AuthRegisterAnamnesisScreen> createState() =>
      _AuthRegisterAnamnesisScreenState();
}

class _AuthRegisterAnamnesisScreenState
    extends State<AuthRegisterAnamnesisScreen> {
  final _formKey = GlobalKey<FormState>();

  int _step = 0;
  final _ctrl = UserController();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // UtilController(context: context).loading('Entrando...');
      // Navigator.of(context).pop();
      Navigator.pushNamed(context, '/introducao');
    } else {
      UtilController(context: context)
          .message('Verifique os campos destacados!');
    }
  }

  void _onDiabete(bool? value) {
    setState(() {
      _ctrl.diabeteCtrl = value;
      debugPrint(value.toString());
    });
  }

  void _onDiabeteType(String? value) {
    setState(() {
      _ctrl.diabeteTypeCtrl = value;
    });
  }

  void _onInsulin(bool? value) {
    setState(() {
      _ctrl.insulinCtrl = value;
    });
  }

  void _goToNext() {
    if (_step > 0) {
      _onSubmit();
      return;
    }

    setState(() {
      _step++;
    });
  }

  void _goToBack() {
    setState(() {
      _step--;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget stepBuild =
        _AuthRegisterAnamneseStep1(context: context, ctrl: _ctrl);

    if (_step == 1) {
      stepBuild = _AuthRegisterAnamneseStep2(
        ctrl: _ctrl,
        onDiabete: _onDiabete,
        onDiabeteType: _onDiabeteType,
        onInsulin: _onInsulin,
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 80,
                ),
              ),
              Flexible(child: stepBuild),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      tooltip: 'Voltar',
                      heroTag: 'btn-back',
                      elevation: 0,
                      hoverElevation: 0,
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(
                            width: 1,
                            color: _step > 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey),
                      ),
                      onPressed: _step > 0 ? () => _goToBack() : null,
                      child: Icon(Icons.arrow_back,
                          color: _step > 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 2; i++)
                          Icon(
                            i == _step
                                ? Icons.fiber_manual_record
                                : Icons.fiber_manual_record_outlined,
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          )
                      ],
                    ),
                    FloatingActionButton(
                      tooltip: 'Avançar',
                      heroTag: 'btn-next',
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () => _goToNext(),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthRegisterAnamneseStep1 extends StatelessWidget {
  const _AuthRegisterAnamneseStep1({required this.context, required this.ctrl});

  final UserController ctrl;
  final BuildContext context;

  void _openGoodies() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                'O que é Goodies?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SvgPicture.asset(
                'assets/icons/coin.svg',
                width: 30,
              ),
            ],
          ),
          content: const Text(
              'São pontos que você acumula ao utilizar nossos aplicativo.\n\n'
              'Você pode ganhar goodies, ao completar todos os '
              'dados de sua conta, também atingindo seus objetivos e metas.'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('Olá, ${ctrl.data.name}?',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Para finalizar seu cadastro, '
                  'precisamos de mais algumas informações suas.'),
            ),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormFieldCustom(
                    label: 'Data de Nascimento',
                    controller: ctrl.dateBirthCtrl,
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: FormFieldCustom(
                      label: 'Sexo',
                      controller: ctrl.sexCtrl,
                      isDropdown: true,
                      options: ctrl.sexList,
                    ),
                  ),
                ),
              ],
            ),
            FormFieldCustom(
              label: 'Qual a sua altura?',
              controller: ctrl.heightCtrl,
              inputType: TextInputType.number,
              mask: '##,##',
            ),
            FormFieldCustom(
              label: 'Quanto você pesa?',
              controller: ctrl.weightCtrl,
              inputType: TextInputType.number,
              mask: '#,##',
            ),
          ],
        ),
        Column(
          children: [
            Text(
                'Usaremos esses dados para calcular seu IMC, '
                'isso nos ajuda a gerenciar sua diabete',
                style: Theme.of(context).textTheme.bodySmall),
            Row(
              children: [
                Text('Preencha seus dados e ganhe 10 Goodies',
                    style: Theme.of(context).textTheme.bodySmall),
                IconButton(
                  onPressed: _openGoodies,
                  icon: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _AuthRegisterAnamneseStep2 extends StatelessWidget {
  const _AuthRegisterAnamneseStep2({
    required this.ctrl,
    required this.onDiabete,
    required this.onDiabeteType,
    required this.onInsulin,
  });

  final UserController ctrl;
  final void Function(bool?) onDiabete;
  final void Function(String?) onDiabeteType;
  final void Function(bool?) onInsulin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Você tem diabetes?',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChipCustom(
                        text: 'Sim',
                        selected: ctrl.diabeteCtrl != null
                            ? ctrl.diabeteCtrl == true
                            : false,
                        onSelected: (value) =>
                            value ? onDiabete(true) : onDiabete(null),
                      ),
                    ),
                    ChipCustom(
                      text: 'Não',
                      selected: ctrl.diabeteCtrl != null
                          ? ctrl.diabeteCtrl == false
                          : false,
                      onSelected: (value) =>
                          value ? onDiabete(false) : onDiabete(null),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (ctrl.diabeteCtrl == true)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text('Tipo'),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var option in ctrl.diabeteTypeList)
                            ChipCustom(
                              text: option.name,
                              selected: ctrl.diabeteTypeCtrl == option.id,
                              onSelected: (value) => value
                                  ? onDiabeteType(option.id)
                                  : onDiabeteType(null),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (ctrl.diabeteTypeCtrl != null)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(ctrl.diabeteTypeCtrl == 'type-1'
                                    ? 'Utiliza Bomba de Insulina?'
                                    : 'Utiliza Insulina?')),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ChipCustom(
                                    text: 'Sim',
                                    selected: ctrl.insulinCtrl != null
                                        ? ctrl.insulinCtrl == true
                                        : false,
                                    onSelected: (value) => value
                                        ? onInsulin(true)
                                        : onInsulin(null),
                                  ),
                                ),
                                ChipCustom(
                                  text: 'Não',
                                  selected: ctrl.insulinCtrl != null
                                      ? ctrl.insulinCtrl == false
                                      : false,
                                  onSelected: (value) => value
                                      ? onInsulin(false)
                                      : onInsulin(null),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (ctrl.insulinCtrl != null)
                      Column(
                        children: [
                          if ((ctrl.diabeteTypeCtrl == 'type-1' &&
                                  ctrl.insulinCtrl == false) ||
                              (ctrl.diabeteTypeCtrl == 'type-2' &&
                                  ctrl.insulinCtrl == true))
                            FormFieldCustom(
                              label: 'Basal (Lenta)',
                              controller: ctrl.insulinSlowCtrl,
                              isDropdown: true,
                              options: ctrl.insulinSlowList,
                            ),
                          if (!(ctrl.diabeteTypeCtrl == 'type-2' &&
                              ctrl.insulinCtrl == false))
                            FormFieldCustom(
                              label: ctrl.diabeteTypeCtrl == 'type-1' &&
                                      ctrl.insulinCtrl == true
                                  ? 'Insulina'
                                  : 'Boulos (Rápida)',
                              controller: ctrl.insulinFastCtrl,
                              isDropdown: true,
                              options: ctrl.insulinFastList,
                            ),
                          FormFieldCustom(
                            label: 'Medicamentos',
                            controller: ctrl.drugCtrl,
                            isDropdown: true,
                            options: ctrl.drugList,
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
