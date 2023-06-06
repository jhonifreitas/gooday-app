import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/controllers/auth_controller.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({super.key});

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
  late final AuthController _authCtrl;
  final _formKey = GlobalKey<FormState>();

  bool _togglePass = true;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authCtrl = AuthController(context);
  }

  _onTogglePass() {
    setState(() {
      _togglePass = !_togglePass;
    });
  }

  Future<void> _signInFacebook() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInFacebook();

    if (user != null && mounted) {
      context.pop();
      context.go('/');
    }
  }

  Future<void> _signInGoogle() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInGoogle();

    if (user != null && mounted) {
      context.pop();
      context.go('/');
    }
  }

  Future<void> _signInApple() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInApple();

    if (user != null && mounted) {
      context.pop();
      context.go('/');
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Entrando...');

      try {
        final user =
            await _authCtrl.signInEmail(_emailCtrl.text, _passwordCtrl.text);

        if (user != null && mounted) {
          context.pop();
          context.go('/');
        }
      } on FirebaseAuthException {
        context.pop();
        UtilService(context).message('E-mail ou senha inválido!');
      }
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _goToRegister() {
    context.push('/auth/cadastrar');
  }

  void _goToForgotPass() {
    context.push('/auth/esqueci-senha');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBarCustom(
              title: Image.asset('assets/images/logo.png', width: 80),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text('Já possui conta?',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text('Acesse agora para ver sua conta!'),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                          obscureText: _togglePass,
                          suffixIcon: IconButton(
                            icon: _togglePass
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                            onPressed: _onTogglePass,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                        ButtonCustom(
                          text: 'Entrar',
                          onPressed: _onSubmit,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Não possui uma conta?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonal(
                    onPressed: _goToRegister,
                    child: const Text('Cadastre-se'),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
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
                    onPressed: _signInFacebook,
                    child: SvgPicture.asset(
                      'assets/icons/facebook.svg',
                      width: 30,
                    ),
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
                    onPressed: _signInGoogle,
                    child: SvgPicture.asset(
                      'assets/icons/google.svg',
                      width: 30,
                    ),
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
                    onPressed: _signInApple,
                    child: SvgPicture.asset(
                      'assets/icons/apple.svg',
                      width: 30,
                    ),
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
