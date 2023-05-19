import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:gooday/components/button.dart';
import 'package:gooday/components/form_field.dart';
import 'package:gooday/controllers/util.controller.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _togglePass = true;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  _onTogglePass() {
    setState(() {
      _togglePass = !_togglePass;
    });
  }

  void _signInFacebook() {}

  void _signInGoogle() {}

  void _signInApple() {}

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      UtilController(context: context).loading('Entrando...');
      // Navigator.of(context).pop();
      // Navigator.pushNamed(context, '/');
    } else {
      UtilController(context: context)
          .message('Verifique os campos destacados!');
    }
  }

  void _goToRegister() {
    Navigator.pushNamed(context, '/auth/cadastrar');
  }

  void _goToForgotPass() {
    Navigator.pushNamed(context, '/auth/esqueci-senha');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              width: 80,
            ),
            Column(
              children: [
                Text('Já possui conta?',
                    style: Theme.of(context).textTheme.titleLarge),
                const Text('Acesse agora para ver sua conta!'),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormFieldWidget(
                        label: 'E-mail',
                        controller: _emailCtrl,
                        isRequired: true,
                        inputType: TextInputType.emailAddress,
                      ),
                      FormFieldWidget(
                        label: 'Senha',
                        controller: _passwordCtrl,
                        isRequired: true,
                        obscureText: _togglePass,
                        suffixIcon: IconButton(
                          icon: _togglePass
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: _onTogglePass,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () => _goToForgotPass(),
                            child: const Text(
                              'Esqueceu a senha?',
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: ButtonWidget(
                          text: 'Entrar',
                          onPressed: () => _onSubmit(),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('Não possui uma conta?',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                FilledButton.tonal(
                    onPressed: () => _goToRegister(),
                    child: const Text('Cadastre-se'))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Ou acesse usando',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FloatingActionButton(
                    tooltip: 'Facebook',
                    heroTag: 'login-btn-facebook',
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
                    heroTag: 'login-btn-google',
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        SvgPicture.asset('assets/icons/google.svg', width: 30),
                    onPressed: () => _signInGoogle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FloatingActionButton(
                    tooltip: 'Apple',
                    heroTag: 'login-btn-apple',
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
    );
  }
}
