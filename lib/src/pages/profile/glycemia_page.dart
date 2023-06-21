import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/controllers/user_glycemia_controller.dart';

class GlycemiaConfigPage extends StatefulWidget {
  const GlycemiaConfigPage({super.key});

  @override
  State<GlycemiaConfigPage> createState() => _GlycemiaConfigPageState();
}

class _GlycemiaConfigPageState extends State<GlycemiaConfigPage> {
  late final UserProvider _userProvider;
  final _formKey = GlobalKey<FormState>();

  bool _changed = false;
  final _userGlycemiaCtrl = UserGlycemiaController();

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = _userProvider.data;
    if (user != null) {
      _userGlycemiaCtrl.initData(user);
    }
  }

  Future<void> _onSubmit() async {
    final user = _userProvider.data!;

    if (!_changed && user.config?.glycemia != null) return _goToNext();

    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');

      final config = user.config!.toJson();
      final data = _userGlycemiaCtrl.clearValues();

      config['glycemia'] = data;
      await _userProvider.update({'config': config});

      if (!mounted) return;

      context.pop();
      _goToNext();
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _onChange(String? value) {
    setState(() {
      _changed = true;
    });
  }

  void _goToNext() {
    context.pop();
    context.push('/config/insulina');
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
            children: [
              AppBarCustom(
                iconBackColor: primaryColor,
                title: Image.asset('assets/images/logo.png', width: 80),
              ),
              // const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Como anda sua Glicemia?',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text('Informe a sua meta glicêmica!',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                          'Estes dados são muito importantes para próxima etapa!',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 40),
                      const Text(
                        "Pré refeição",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              label: 'Mínimo',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller: _userGlycemiaCtrl.beforeMealMinCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: InputField(
                              label: 'Normal',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller:
                                  _userGlycemiaCtrl.beforeMealNormalCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: InputField(
                              label: 'Máximo',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller: _userGlycemiaCtrl.beforeMealMaxCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Pós refeição",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              label: 'Mínimo',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller: _userGlycemiaCtrl.afterMealMinCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: InputField(
                              label: 'Normal',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller: _userGlycemiaCtrl.afterMealNormalCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: InputField(
                              label: 'Máximo',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller: _userGlycemiaCtrl.afterMealMaxCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Ante de dormir",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              label: 'Mínimo',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller: _userGlycemiaCtrl.beforeSleepMinCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: InputField(
                              label: 'Normal',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller:
                                  _userGlycemiaCtrl.beforeSleepNormalCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: InputField(
                              label: 'Máximo',
                              hint: 'ml/g',
                              maxLength: 3,
                              isRequired: true,
                              onChange: _onChange,
                              controller: _userGlycemiaCtrl.beforeSleepMaxCtrl,
                              inputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ButtonCustom(text: 'Avançar', onPressed: _onSubmit),
              )
            ],
          ),
        ),
      ),
    );
  }
}
