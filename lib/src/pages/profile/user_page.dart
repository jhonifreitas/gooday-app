import 'package:gooday/src/models/drug_model.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/models/goodie_model.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/chip_field.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/services/api/drug_service.dart';
import 'package:gooday/src/widgets/form/dropdown_field.dart';
import 'package:gooday/src/services/api/goodie_service.dart';
import 'package:gooday/src/controllers/user_controller.dart';
import 'package:gooday/src/pages/goodie/congratulation_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final UserProvider _userProvider;
  final _userCtrl = UserController();
  final _pageCtrl = PageController();
  final _formKey = GlobalKey<FormState>();
  final _goodieApi = GoodieApiService();

  final _goodies = 10;
  int _currentPage = 0;
  bool _userCompleted = true;
  bool _diabeteTypeDisabled = false;

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = _userProvider.data;
    if (user != null) {
      _userCtrl.initData(user);

      final userCompleted = user.name!.isNotEmpty &&
          user.email!.isNotEmpty &&
          user.phone!.isNotEmpty &&
          user.dateBirth != null &&
          user.genre!.isNotEmpty &&
          user.anamnese?.height != null &&
          user.anamnese?.weight != null &&
          user.anamnese?.diabeteType != null &&
          user.anamnese?.insulin != null;
      setState(() {
        _userCompleted = userCompleted;
        _diabeteTypeDisabled = user.anamnese?.diabeteType != null;
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');

      final Map<String, dynamic> data = {
        'name': _userCtrl.nameCtrl.text,
        'email': _userCtrl.emailCtrl.text,
        'phone': _userCtrl.clearPhone(),
        'dateBirth': _userCtrl.clearDateBirth(),
        'genre': _userCtrl.genreCtrl.text,
        'anamnese': {
          'height': _userCtrl.clearHeight(),
          'weight': _userCtrl.clearWeight(),
          'diabeteType': _userCtrl.diabeteTypeCtrl.text,
          'insulin': _userCtrl.insulinCtrl,
          'insulinSlow': _userCtrl.insulinSlowCtrl.text,
          'insulinFast': _userCtrl.insulinFastCtrl.text,
          'drugs': _userCtrl.drugsCtrl,
        }
      };

      final isComplete = data['name'].isNotEmpty &&
          data['name'].isNotEmpty &&
          data['email'].isNotEmpty &&
          data['phone'].isNotEmpty &&
          data['dateBirth'] != null &&
          data['genre'].isNotEmpty &&
          data['anamnese']['height'] != null &&
          data['anamnese']['weight'] != null &&
          data['anamnese']['diabeteType'].isNotEmpty;
      if (isComplete && !_userCompleted) {
        data['goodies'] = _userProvider.data!.goodies + _goodies;
      }

      await _userProvider.update(data);

      if (mounted) context.pop();

      if (isComplete && !_userCompleted) await _addGoodie();

      if (mounted) context.pop();
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  Future<void> _addGoodie() async {
    final data = GoodieModel(
      userId: _userProvider.data!.id!,
      type: GoodieType.profileComplete,
      value: _goodies,
    );
    await _goodieApi.add(data);

    if (!mounted) return;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: GoodieCongratulationPage(value: data.value),
        );
      },
    );
  }

  void _onDateBirth() {
    DateTime initialDateTime = DateTime(DateTime.now().year - 10);
    if (_userCtrl.dateBirthCtrl.text.isNotEmpty) {
      initialDateTime =
          DateFormat('dd/MM/yyyy').parse(_userCtrl.dateBirthCtrl.text);
    }

    UtilService(context).dateTimePicker(
      maximumDate: DateTime.now(),
      initialDateTime: initialDateTime,
      onChange: (dateTime) {
        setState(() {
          _userCtrl.dateBirthCtrl.text =
              DateFormat('dd/MM/yyyy').format(dateTime);
        });
      },
    );
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
                iconBackColor: primaryColor,
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
                      child: _UserForm(
                        goodies: _goodies,
                        userCtrl: _userCtrl,
                        onDateBirth: _onDateBirth,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: UserAnamneseForm(
                        userCtrl: _userCtrl,
                        diabeteTypeDisabled: _diabeteTypeDisabled,
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
                            color:
                                _currentPage > 0 ? primaryColor : Colors.grey),
                      ),
                      onPressed: _currentPage > 0 ? () => _goToBack() : null,
                      child: Icon(Icons.arrow_back,
                          color: _currentPage > 0 ? primaryColor : Colors.grey),
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
                            color: primaryColor,
                          )
                      ],
                    ),
                    FloatingActionButton(
                      tooltip: _currentPage < 1 ? 'Avançar' : 'Salvar',
                      heroTag: 'btn-next',
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () => _goToNext(),
                      child: Icon(
                        color: Colors.white,
                        _currentPage < 1 ? Icons.arrow_forward : Icons.check,
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

class _UserForm extends StatelessWidget {
  const _UserForm({
    required this.userCtrl,
    required this.onDateBirth,
    required this.goodies,
  });

  final int goodies;
  final UserController userCtrl;
  final VoidCallback onDateBirth;

  void _openGoodies(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text(
                'O que é Goodies?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meus dados!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
                'Usaremos esses dados para calcular seu IMC, '
                'isso nos ajuda a gerenciar sua diabete',
                style: Theme.of(context).textTheme.bodySmall),
            Row(
              children: [
                Text('Preencha seus dados e ganhe $goodies Goodies',
                    style: Theme.of(context).textTheme.bodySmall),
                IconButton(
                  onPressed: () => _openGoodies(context),
                  icon: const Icon(
                    Icons.info_outline,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ],
        ),
        Column(
          children: [
            InputField(
              label: 'Nome',
              controller: userCtrl.nameCtrl,
            ),
            InputField(
              label: 'E-mail',
              controller: userCtrl.emailCtrl,
              inputType: TextInputType.emailAddress,
            ),
            InputField(
              label: 'Celular',
              controller: userCtrl.phoneCtrl,
              isRequired: true,
              minLength: 15,
              inputType: TextInputType.number,
              masks: const ['(99) 99999-9999'],
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: 'Data de Nascimento',
                    controller: userCtrl.dateBirthCtrl,
                    readOnly: true,
                    onTap: onDateBirth,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: DropdownField(
                    label: 'Sexo',
                    controller: userCtrl.genreCtrl,
                    options: userCtrl.genreList,
                  ),
                ),
              ],
            ),
            InputField(
              label: 'Qual a sua altura?',
              controller: userCtrl.heightCtrl,
              inputType: TextInputType.number,
              minLength: 4,
              masks: const ['9,99'],
            ),
            InputField(
              label: 'Quanto você pesa?',
              controller: userCtrl.weightCtrl,
              inputType: TextInputType.number,
              minLength: 2,
              masks: const ['99', '99,9', '999,9'],
              maskReverse: true,
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class UserAnamneseForm extends StatefulWidget {
  const UserAnamneseForm({
    required this.userCtrl,
    this.diabeteTypeDisabled = false,
    super.key,
  });

  final UserController userCtrl;
  final bool diabeteTypeDisabled;

  @override
  State<UserAnamneseForm> createState() => _UserAnamneseFormState();
}

class _UserAnamneseFormState extends State<UserAnamneseForm> {
  final _drugsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _drugsCtrl.text = widget.userCtrl.drugsCtrl.join(', ');
  }

  void _onDiabete(bool? value) {
    setState(() {
      widget.userCtrl.diabeteCtrl = value;
    });
  }

  void _onDiabeteType(String? value) {
    setState(() {
      widget.userCtrl.diabeteTypeCtrl.text = value ?? '';
    });
  }

  void _onInsulin(bool? value) {
    setState(() {
      widget.userCtrl.insulinCtrl = value;
    });
  }

  void _onDrug(String id, bool selected) {
    setState(() {
      if (selected) {
        widget.userCtrl.drugsCtrl.add(id);
      } else {
        final index =
            widget.userCtrl.drugsCtrl.indexWhere((drug) => drug == id);
        widget.userCtrl.drugsCtrl.removeAt(index);
      }

      _drugsCtrl.text = widget.userCtrl.drugsCtrl.join(', ');
    });
  }

  void _openDrug() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _DrugList(
          onSelected: _onDrug,
          selecteds: widget.userCtrl.drugsCtrl,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ChipField> diabeteTypes = [];
    for (final item in widget.userCtrl.diabeteTypeList) {
      final diabeteType = ChipField(
        text: item.name,
        isDisabled: widget.diabeteTypeDisabled,
        selected: widget.userCtrl.diabeteTypeCtrl.text == item.id,
        onSelected: (value) =>
            value ? _onDiabeteType(item.id) : _onDiabeteType(null),
      );
      diabeteTypes.add(diabeteType);
    }

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
                ChipField(
                  text: 'Sim',
                  isDisabled: widget.diabeteTypeDisabled,
                  selected: widget.userCtrl.diabeteCtrl != null
                      ? widget.userCtrl.diabeteCtrl == true
                      : false,
                  onSelected: (value) =>
                      value ? _onDiabete(true) : _onDiabete(null),
                ),
                ChipField(
                  text: 'Não',
                  isDisabled: widget.diabeteTypeDisabled,
                  selected: widget.userCtrl.diabeteCtrl != null
                      ? widget.userCtrl.diabeteCtrl == false
                      : false,
                  onSelected: (value) =>
                      value ? _onDiabete(false) : _onDiabete(null),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: widget.userCtrl.diabeteCtrl == true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tipo'),
              const SizedBox(height: 5),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: diabeteTypes,
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: widget.userCtrl.diabeteTypeCtrl.text.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.userCtrl.diabeteTypeCtrl.text == 'type-1'
                            ? 'Utiliza Bomba de Insulina?'
                            : 'Utiliza Insulina?'),
                        const SizedBox(height: 5),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ChipField(
                              text: 'Sim',
                              selected: widget.userCtrl.insulinCtrl != null
                                  ? widget.userCtrl.insulinCtrl == true
                                  : false,
                              onSelected: (value) =>
                                  value ? _onInsulin(true) : _onInsulin(null),
                            ),
                            ChipField(
                              text: 'Não',
                              selected: widget.userCtrl.insulinCtrl != null
                                  ? widget.userCtrl.insulinCtrl == false
                                  : false,
                              onSelected: (value) =>
                                  value ? _onInsulin(false) : _onInsulin(null),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: widget.userCtrl.insulinCtrl != null,
                      child: Column(
                        children: [
                          Visibility(
                            visible: (widget.userCtrl.diabeteTypeCtrl.text ==
                                        'type-1' &&
                                    widget.userCtrl.insulinCtrl == false) ||
                                (widget.userCtrl.diabeteTypeCtrl.text ==
                                        'type-2' &&
                                    widget.userCtrl.insulinCtrl == true),
                            child: DropdownField(
                              label: 'Basal (Lenta)',
                              controller: widget.userCtrl.insulinSlowCtrl,
                              options: widget.userCtrl.insulinSlowList,
                            ),
                          ),
                          Visibility(
                            visible: !(widget.userCtrl.diabeteTypeCtrl.text ==
                                    'type-2' &&
                                widget.userCtrl.insulinCtrl == false),
                            child: DropdownField(
                              label: widget.userCtrl.diabeteTypeCtrl.text ==
                                          'type-1' &&
                                      widget.userCtrl.insulinCtrl == true
                                  ? 'Insulina'
                                  : 'Bolus (Rápida)',
                              controller: widget.userCtrl.insulinFastCtrl,
                              options: widget.userCtrl.insulinFastList,
                            ),
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
        Visibility(
          visible: widget.userCtrl.diabeteCtrl != null,
          child: InputField(
            label: 'Medicamentos',
            controller: _drugsCtrl,
            readOnly: true,
            onTap: _openDrug,
          ),
        ),
      ],
    );
  }
}

class _DrugList extends StatefulWidget {
  const _DrugList({required this.selecteds, required this.onSelected});

  final List<String> selecteds;
  final void Function(String, bool) onSelected;

  @override
  State<_DrugList> createState() => _DrugListState();
}

class _DrugListState extends State<_DrugList> {
  final _drugApi = DrugApiService();
  late Future<List<DrugModel>> _loadData;

  @override
  void initState() {
    _loadData = _drugApi.getAll();
    super.initState();
  }

  void _onChanged(String id, bool? value) {
    if (value != null) {
      setState(() {
        widget.onSelected(id, value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('Medicamentos',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder(
              future: _loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final drug = snapshot.data![index];

                    return CheckboxListTile(
                      title: Text(
                        drug.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      value: widget.selecteds.any((val) => val == drug.name),
                      onChanged: (value) => _onChanged(drug.name, value),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ButtonCustom(
              text: 'Confirmar',
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
