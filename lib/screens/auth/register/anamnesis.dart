import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:gooday/models/user.dart';
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

  User? user;
  int _step = 0;

  final List<Option> _sexList = const [
    Option(id: 'masc', name: 'Masculino'),
    Option(id: 'fem', name: 'Feminino'),
    Option(id: 'other', name: 'Outro'),
  ];
  final List<Option> _diabeteTypeList = const [
    Option(id: 'type-1', name: 'Tipo 1'),
    Option(id: 'type-2', name: 'Tipo 2'),
    // Option(id: 'pre', name: 'Pré-Diabetes'),
  ];
  final List<Option> _insulinSlowList = const [
    Option(id: 'NPH', name: 'NPH'),
    Option(id: 'Lantus', name: 'Lantus'),
    Option(id: 'Tresiba', name: 'Tresiba'),
    Option(id: 'U300', name: 'U300'),
  ];
  final List<Option> _insulinFastList = const [
    Option(id: 'Apidra', name: 'Apidra'),
    Option(id: 'Humalog', name: 'Humalog'),
    Option(id: 'Novorapid', name: 'Novorapid'),
    Option(id: 'Fiasp', name: 'Fiasp'),
  ];
  final List<Option> _drugList = const [
    Option(id: 'drug-3', name: 'Medicamento 1'),
    Option(id: 'drug-2', name: 'Medicamento 2'),
    Option(id: 'drug-3', name: 'Medicamento 3'),
  ];

  final _sexCtrl = TextEditingController();
  final _dateBirthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  final _insulinSlowCtrl = TextEditingController();
  final _insulinFastCtrl = TextEditingController();
  final _drugCtrl = TextEditingController();

  bool? _diabete;
  String? _diabeteType;
  bool? _insulin;

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
              'Você pode ganhar goodies, ao completar todos os dados de sua conta, também atingindo seus objetivos e metas.'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      },
    );
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
    Widget stepBuild = _step1Build();

    if (_step == 1) stepBuild = _step2Build();

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
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

  Widget _step1Build() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('Olá, ${user?.name}?',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                  'Para finalizar seu cadastro, precisamos de mais algumas informações suas.'),
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
                    controller: _dateBirthCtrl,
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: FormFieldCustom(
                      label: 'Sexo',
                      controller: _sexCtrl,
                      isDropdown: true,
                      options: _sexList,
                    ),
                  ),
                ),
              ],
            ),
            FormFieldCustom(
              label: 'Qual a sua altura?',
              controller: _heightCtrl,
              inputType: TextInputType.number,
              mask: '##,##',
            ),
            FormFieldCustom(
              label: 'Quanto você pesa?',
              controller: _weightCtrl,
              inputType: TextInputType.number,
              mask: '#,##',
            ),
          ],
        ),
        Column(
          children: [
            Text(
                'Usaremos esses dados para calcular seu IMC, isso nos ajuda a gerenciar sua diabete',
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

  Widget _step2Build() {
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
                        selected: _diabete != null ? _diabete == true : false,
                        onSelected: (value) => setState(
                            () => {value ? _diabete = true : _diabete = null}),
                      ),
                    ),
                    ChipCustom(
                      text: 'Não',
                      selected: _diabete != null ? _diabete == false : false,
                      onSelected: (value) => setState(
                          () => {value ? _diabete = false : _diabete = null}),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (_diabete == true)
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
                          for (var option in _diabeteTypeList)
                            ChipCustom(
                              text: option.name,
                              selected: _diabeteType == option.id,
                              onSelected: (value) => setState(() => {
                                    value
                                        ? _diabeteType = option.id
                                        : _diabeteType = null
                                  }),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_diabeteType != null)
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
                                child: Text(_diabeteType == 'type-1'
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
                                    selected: _insulin != null
                                        ? _insulin == true
                                        : false,
                                    onSelected: (value) => setState(() => {
                                          value
                                              ? _insulin = true
                                              : _insulin = null
                                        }),
                                  ),
                                ),
                                ChipCustom(
                                  text: 'Não',
                                  selected: _insulin != null
                                      ? _insulin == false
                                      : false,
                                  onSelected: (value) => setState(() => {
                                        value
                                            ? _insulin = false
                                            : _insulin = null
                                      }),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (_insulin != null)
                      Column(
                        children: [
                          if ((_diabeteType == 'type-1' && _insulin == false) ||
                              (_diabeteType == 'type-2' && _insulin == true))
                            FormFieldCustom(
                              label: 'Basal (Lenta)',
                              controller: _insulinSlowCtrl,
                              isDropdown: true,
                              options: _insulinSlowList,
                            ),
                          if (!(_diabeteType == 'type-2' && _insulin == false))
                            FormFieldCustom(
                              label:
                                  _diabeteType == 'type-1' && _insulin == true
                                      ? 'Insulina'
                                      : 'Boulos (Rápida)',
                              controller: _insulinFastCtrl,
                              isDropdown: true,
                              options: _insulinFastList,
                            ),
                          FormFieldCustom(
                            label: 'Medicamentos',
                            controller: _drugCtrl,
                            isDropdown: true,
                            options: _drugList,
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
