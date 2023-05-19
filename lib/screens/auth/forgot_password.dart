import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:gooday/components/button.dart';
import 'package:gooday/components/form_field.dart';
import 'package:gooday/controllers/util.controller.dart';

class AuthForgotPasswordScreen extends StatefulWidget {
  const AuthForgotPasswordScreen({super.key});

  @override
  State<AuthForgotPasswordScreen> createState() =>
      _AuthForgotPasswordScreenState();
}

class _AuthForgotPasswordScreenState extends State<AuthForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      UtilController(context: context).loading('Enviado...');
      // Navigator.of(context).pop();
      // Navigator.pushNamed(context, '/');
    } else {
      UtilController(context: context)
          .message('Verifique os campos destacados!');
    }
  }

  void _goToBack() {
    Navigator.pop(context);
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
                Text('Esqueceu sua senha?',
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(
                  'Informe seu e-mail para recuperar sua conta!',
                  textAlign: TextAlign.center,
                ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ButtonWidget(
                          text: 'Avançar',
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
                    onPressed: () => _goToBack(), child: const Text('Acessar'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
