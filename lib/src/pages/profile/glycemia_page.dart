import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/controllers/user_controller.dart';

class GlycemiaConfigPage extends StatefulWidget {
  const GlycemiaConfigPage({super.key});

  @override
  State<GlycemiaConfigPage> createState() => _GlycemiaConfigPageState();
}

class _GlycemiaConfigPageState extends State<GlycemiaConfigPage> {
  final _formKey = GlobalKey<FormState>();

  final _userCtrl = UserController();

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');

      if (!mounted) return;

      context.pop();
      context.pop();
      context.push('/config/insulina');
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            controller: _userCtrl.nameCtrl,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InputField(
                            label: 'Normal',
                            hint: 'ml/g',
                            maxLength: 3,
                            controller: _userCtrl.nameCtrl,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InputField(
                            label: 'Máximo',
                            hint: 'ml/g',
                            maxLength: 3,
                            controller: _userCtrl.nameCtrl,
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
                            controller: _userCtrl.nameCtrl,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InputField(
                            label: 'Normal',
                            hint: 'ml/g',
                            maxLength: 3,
                            controller: _userCtrl.nameCtrl,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InputField(
                            label: 'Máximo',
                            hint: 'ml/g',
                            maxLength: 3,
                            controller: _userCtrl.nameCtrl,
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
                            controller: _userCtrl.nameCtrl,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InputField(
                            label: 'Normal',
                            hint: 'ml/g',
                            maxLength: 3,
                            controller: _userCtrl.nameCtrl,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InputField(
                            label: 'Máximo',
                            hint: 'ml/g',
                            maxLength: 3,
                            controller: _userCtrl.nameCtrl,
                            inputType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
