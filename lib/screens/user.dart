import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:gooday/components/appbar.dart';
import 'package:gooday/controllers/user.controller.dart';

import 'package:gooday/components/chip.dart';
import 'package:gooday/components/form_field.dart';
import 'package:gooday/controllers/util.controller.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();

  int _currentPage = 0;
  final _ctrl = UserController();
  final _pageCtrl = PageController();

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UtilController(context: context).loading('Entrando...');
      await Future.delayed(const Duration(seconds: 5));
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } else {
      UtilController(context: context)
          .message('Verifique os campos destacados!');
    }
  }

  void _onDiabete(bool? value) {
    setState(() {
      _ctrl.diabeteCtrl = value;
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

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _goToNext() {
    if (_currentPage == 1) {
      _onSubmit();
    } else {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void _goToBack() {
    _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 30),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBarCustom(
                title: Image.asset('assets/images/logo.png', width: 80),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: PageView(
                  controller: _pageCtrl,
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _AuthRegisterAnamneseStep1(
                          context: context, ctrl: _ctrl),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: _AuthRegisterAnamneseStep2(
                        ctrl: _ctrl,
                        onDiabete: _onDiabete,
                        onDiabeteType: _onDiabeteType,
                        onInsulin: _onInsulin,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
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
                            color: _currentPage > 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey),
                      ),
                      onPressed: _currentPage > 0 ? () => _goToBack() : null,
                      child: Icon(Icons.arrow_back,
                          color: _currentPage > 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 2; i++)
                          Icon(
                            i == _currentPage
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
                        _currentPage < 1 ? Icons.arrow_forward : Icons.check,
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
        const SizedBox(height: 20),
        Column(
          children: [
            FormFieldCustom(
              label: 'Nome',
              controller: ctrl.nameCtrl,
            ),
            FormFieldCustom(
              label: 'E-mail',
              controller: ctrl.emailCtrl,
              inputType: TextInputType.emailAddress,
            ),
            FormFieldCustom(
              label: 'Celular',
              controller: ctrl.phoneCtrl,
              isRequired: true,
              minLength: 15,
              inputType: TextInputType.phone,
              mask: '(##) #####-####',
            ),
            Row(
              children: [
                Expanded(
                  child: FormFieldCustom(
                    label: 'Data de Nascimento',
                    controller: ctrl.dateBirthCtrl,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 140,
                  child: FormFieldCustom(
                    label: 'Sexo',
                    controller: ctrl.sexCtrl,
                    isDropdown: true,
                    options: ctrl.sexList,
                  ),
                ),
              ],
            ),
            FormFieldCustom(
              label: 'Qual a sua altura?',
              controller: ctrl.heightCtrl,
              inputType: TextInputType.number,
              mask: '#,##',
            ),
            FormFieldCustom(
              label: 'Quanto você pesa?',
              controller: ctrl.weightCtrl,
              inputType: TextInputType.number,
              mask: '##,##',
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
  final ValueChanged<bool?> onDiabete;
  final ValueChanged<String?> onDiabeteType;
  final ValueChanged<bool?> onInsulin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você tem diabetes?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ChipCustom(
                  text: 'Sim',
                  selected: ctrl.diabeteCtrl != null
                      ? ctrl.diabeteCtrl == true
                      : false,
                  onSelected: (value) =>
                      value ? onDiabete(true) : onDiabete(null),
                ),
                const SizedBox(width: 10),
                ChipCustom(
                  text: 'Não',
                  selected: ctrl.diabeteCtrl != null
                      ? ctrl.diabeteCtrl == false
                      : false,
                  onSelected: (value) =>
                      value ? onDiabete(false) : onDiabete(null),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: ctrl.diabeteCtrl == true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tipo'),
              const SizedBox(height: 5),
              Wrap(
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
              const SizedBox(height: 20),
              Visibility(
                visible: ctrl.diabeteTypeCtrl != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ctrl.diabeteTypeCtrl == 'type-1'
                            ? 'Utiliza Bomba de Insulina?'
                            : 'Utiliza Insulina?'),
                        const SizedBox(height: 5),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ChipCustom(
                              text: 'Sim',
                              selected: ctrl.insulinCtrl != null
                                  ? ctrl.insulinCtrl == true
                                  : false,
                              onSelected: (value) =>
                                  value ? onInsulin(true) : onInsulin(null),
                            ),
                            const SizedBox(width: 10),
                            ChipCustom(
                              text: 'Não',
                              selected: ctrl.insulinCtrl != null
                                  ? ctrl.insulinCtrl == false
                                  : false,
                              onSelected: (value) =>
                                  value ? onInsulin(false) : onInsulin(null),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: ctrl.insulinCtrl != null,
                      child: Column(
                        children: [
                          Visibility(
                            visible: (ctrl.diabeteTypeCtrl == 'type-1' &&
                                    ctrl.insulinCtrl == false) ||
                                (ctrl.diabeteTypeCtrl == 'type-2' &&
                                    ctrl.insulinCtrl == true),
                            child: FormFieldCustom(
                              label: 'Basal (Lenta)',
                              controller: ctrl.insulinSlowCtrl,
                              isDropdown: true,
                              options: ctrl.insulinSlowList,
                            ),
                          ),
                          Visibility(
                            visible: !(ctrl.diabeteTypeCtrl == 'type-2' &&
                                ctrl.insulinCtrl == false),
                            child: FormFieldCustom(
                              label: ctrl.diabeteTypeCtrl == 'type-1' &&
                                      ctrl.insulinCtrl == true
                                  ? 'Insulina'
                                  : 'Boulos (Rápida)',
                              controller: ctrl.insulinFastCtrl,
                              isDropdown: true,
                              options: ctrl.insulinFastList,
                            ),
                          ),
                          FormFieldCustom(
                            label: 'Medicamentos',
                            controller: ctrl.drugCtrl,
                            isDropdown: true,
                            options: ctrl.drugList,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
