import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/services/util_service.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void _signInFacebook() {}

  void _signInGoogle() {}

  void _signInApple() {}

  void _onImageUpload() {}

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UtilService(context).loading('Cadastrando...');
      await Future.delayed(const Duration(seconds: 5));
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/auth/cadastrar/anamnese');
      }
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _goToRegister() {
    Navigator.pushNamed(context, '/auth/cadastrar');
  }

  void _goToBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => _goToBack(),
                      icon: const Icon(Icons.arrow_back)),
                  Image.asset(
                    width: 80,
                    'assets/images/logo.png',
                  ),
                  const SizedBox(width: 50),
                ],
              ),
              Column(
                children: [
                  Text('E você?',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text('Queremos conhecê-lo'),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      elevation: 0,
                      tooltip: 'Enviar foto',
                      heroTag: 'register-btn-image',
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder(
                        side: BorderSide(width: 1, color: Colors.grey),
                      ),
                      onPressed: _onImageUpload,
                      child: const Icon(Icons.camera_alt_outlined,
                          color: Colors.grey, size: 40),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        FormFieldCustom(
                          label: 'Nome',
                          controller: _nameCtrl,
                          isRequired: true,
                        ),
                        FormFieldCustom(
                          label: 'Celular',
                          controller: _phoneCtrl,
                          isRequired: true,
                          minLength: 15,
                          inputType: TextInputType.number,
                          masks: const ['(99) 99999-9999'],
                        ),
                        FormFieldCustom(
                          label: 'E-mail',
                          controller: _emailCtrl,
                          isRequired: true,
                          inputType: TextInputType.emailAddress,
                        ),
                        FormFieldCustom(
                          label: 'Senha',
                          controller: _passwordCtrl,
                          isRequired: true,
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ButtonCustom(
                            text: 'Avançar',
                            onPressed: () => _onSubmit(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text('Já possui uma conta?',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  FilledButton.tonal(
                      onPressed: () => _goToRegister(),
                      child: const Text('Acessar'))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Ou cadastre-se usando',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FloatingActionButton(
                      tooltip: 'Facebook',
                      heroTag: 'register-btn-facebook',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                      child: SvgPicture.asset('assets/icons/facebook.svg',
                          width: 30),
                      onPressed: () => _signInFacebook(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FloatingActionButton(
                      tooltip: 'Google',
                      heroTag: 'register-btn-google',
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset('assets/icons/google.svg',
                          width: 30),
                      onPressed: () => _signInGoogle(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FloatingActionButton(
                      tooltip: 'Apple',
                      heroTag: 'register-btn-apple',
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          SvgPicture.asset('assets/icons/apple.svg', width: 30),
                      onPressed: () => _signInApple(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
