import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:gooday/components/button.dart';
import 'package:gooday/components/form_field.dart';
import 'package:gooday/controllers/util.controller.dart';

class AuthRegisterScreen extends StatefulWidget {
  const AuthRegisterScreen({super.key});

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void _signInFacebook() {}

  void _signInGoogle() {}

  void _signInApple() {}

  void _onImageUpload() {}

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // UtilController(context: context).loading('Entrando...');
      // Navigator.of(context).pop();
      Navigator.pushNamed(context, '/auth/cadastrar/anamnese');
    } else {
      UtilController(context: context)
          .message('Verifique os campos destacados!');
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
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 80,
                  ),
                  const SizedBox(width: 50),
                ],
              ),
              Column(
                children: [
                  Text('E você?',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text('Queremos conhecê-lo'),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
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
                          inputType: TextInputType.phone,
                          mask: '(##) #####-####',
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('Já possui uma conta?',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
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
