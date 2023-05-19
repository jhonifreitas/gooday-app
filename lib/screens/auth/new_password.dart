import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:gooday/components/button.dart';
import 'package:gooday/components/form_field.dart';
import 'package:gooday/controllers/util.controller.dart';

class AuthNewPasswordScreen extends StatefulWidget {
  const AuthNewPasswordScreen({super.key});

  @override
  State<AuthNewPasswordScreen> createState() => _AuthNewPasswordScreenState();
}

class _AuthNewPasswordScreenState extends State<AuthNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _togglePass = true;
  bool _togglePassConfirm = true;

  final _passwordCtrl = TextEditingController();
  final _passwordConfirmCtrl = TextEditingController();

  _onTogglePass() {
    setState(() {
      _togglePass = !_togglePass;
    });
  }

  _onTogglePassConfirm() {
    setState(() {
      _togglePassConfirm = !_togglePassConfirm;
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_passwordCtrl.text != _passwordConfirmCtrl.text) {
        return UtilController(context: context)
            .message('As senhas devem ser iguais!');
      }
      _formKey.currentState!.save();
      UtilController(context: context).loading('Alterando...');
      // Navigator.of(context).pop();
      // Navigator.pushNamed(context, '/');
    } else {
      UtilController(context: context)
          .message('Verifique os campos destacados!');
    }
  }

  void goToLogin() {
    Navigator.pushNamed(context, '/auth/entrar');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () => goToLogin(),
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
                Text('Já possui conta?',
                    style: Theme.of(context).textTheme.titleLarge),
                const Text('Acesse agora para ver sua conta!'),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      FormFieldCustom(
                        label: 'Confirmar Senha',
                        controller: _passwordConfirmCtrl,
                        isRequired: true,
                        obscureText: _togglePassConfirm,
                        suffixIcon: IconButton(
                          icon: _togglePassConfirm
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: _onTogglePassConfirm,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ButtonCustom(
                          text: 'Alterar senha',
                          onPressed: () => _onSubmit(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('Tudo certo com sua conta?',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                FilledButton.tonal(
                    onPressed: () => goToLogin(), child: const Text('Acessar'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
