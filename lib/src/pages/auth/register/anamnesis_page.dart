import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/pages/profile/user_page.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/controllers/user_controller.dart';
import 'package:gooday/src/pages/goodie/congratulation_page.dart';

class AuthRegisterAnamnesisPage extends StatefulWidget {
  const AuthRegisterAnamnesisPage({super.key});

  @override
  State<AuthRegisterAnamnesisPage> createState() =>
      _AuthRegisterAnamnesisPageState();
}

class _AuthRegisterAnamnesisPageState extends State<AuthRegisterAnamnesisPage> {
  final _formKey = GlobalKey<FormState>();

  final _goodies = 50;
  int _currentPage = 0;
  final _userCtrl = UserController();
  final _pageCtrl = PageController();

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');

      final Map<String, dynamic> data = {
        'dateBirth': _userCtrl.clearDateBirth(),
        'genre': _userCtrl.genreCtrl.text,
        'anamnese': {
          'height': _userCtrl.clearHeight(),
          'weight': _userCtrl.clearWeight(),
          'diabeteType': _userCtrl.diabeteTypeCtrl.text,
          'insulin': _userCtrl.insulinCtrl,
          'insulinSlow': _userCtrl.insulinSlowCtrl.text,
          'insulinFast': _userCtrl.insulinFastCtrl.text,
          'drug': _userCtrl.drugCtrl.text,
        }
      };
      final userProvider = context.read<UserProvider>();
      final isComplete = data['name'].isNotEmpty &&
          data['name'].isNotEmpty &&
          data['email'].isNotEmpty &&
          data['phone'].isNotEmpty &&
          data['dateBirth'] != null &&
          data['genre'].isNotEmpty &&
          data['anamnese']['height'] != null &&
          data['anamnese']['weight'] != null &&
          data['anamnese']['diabeteType'].isNotEmpty;
      if (isComplete) {
        data['goodies'] += userProvider.data!.goodies + _goodies;
      }

      await userProvider.update(data);

      if (mounted) context.pop();

      if (isComplete) await _openGoodieCongratulation(_goodies);

      if (mounted) context.push('/introducao/1');
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  Future<void> _openGoodieCongratulation(int value) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: GoodieCongratulationPage(value: value),
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
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/logo.png', width: 80),
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
                        userCtrl: _userCtrl,
                        onDateBirth: _onDateBirth,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: UserAnamneseForm(userCtrl: _userCtrl),
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
                      tooltip: 'Avançar',
                      heroTag: 'btn-next',
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      onPressed: () => _goToNext(),
                      child: Icon(
                        _currentPage < 1 ? Icons.arrow_forward : Icons.check,
                        color: Colors.white,
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
  const _AuthRegisterAnamneseStep1(
      {required this.userCtrl, required this.onDateBirth});

  final UserController userCtrl;
  final VoidCallback onDateBirth;

  void _openGoodie(BuildContext context) {
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
              SvgPicture.asset('assets/icons/coin.svg', width: 30),
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
                'Olá, ${context.watch<UserProvider>().data?.name?.split(' ')[0]}?',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            const Text('Para finalizar seu cadastro, '
                'precisamos de mais algumas informações suas.'),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormFieldCustom(
                    label: 'Data de Nascimento',
                    controller: userCtrl.dateBirthCtrl,
                    readOnly: true,
                    onTap: onDateBirth,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: FormFieldCustom(
                    label: 'Sexo',
                    controller: userCtrl.genreCtrl,
                    isDropdown: true,
                    options: userCtrl.genreList,
                  ),
                ),
              ],
            ),
            FormFieldCustom(
              label: 'Qual a sua altura?',
              controller: userCtrl.heightCtrl,
              inputType: TextInputType.number,
              minLength: 4,
              masks: const ['9,99'],
            ),
            FormFieldCustom(
              label: 'Quanto você pesa?',
              controller: userCtrl.weightCtrl,
              inputType: TextInputType.number,
              minLength: 2,
              masks: const ['99', '99,9', '999,9'],
              maskReverse: true,
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
                  onPressed: () => _openGoodie(context),
                  icon: const Icon(Icons.info_outline, color: primaryColor),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
