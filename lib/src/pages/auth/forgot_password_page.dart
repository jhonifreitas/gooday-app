import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/controllers/auth_controller.dart';

class AuthForgotPasswordPage extends StatefulWidget {
  const AuthForgotPasswordPage({super.key});

  @override
  State<AuthForgotPasswordPage> createState() => _AuthForgotPasswordPageState();
}

class _AuthForgotPasswordPageState extends State<AuthForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Enviado...');

      await AuthController(context).sendPasswordReset(_emailCtrl.text);

      if (!mounted) return;

      UtilService(context)
          .message('Verifique a caixa de entrada de seu e-mail!');

      context.pop(context);
      context.go('/auth/entrar');
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _goToBack() {
    context.pop();
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
                Image.asset(
                  width: 80,
                  'assets/images/logo.png',
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
                      FormFieldCustom(
                        label: 'E-mail',
                        controller: _emailCtrl,
                        isRequired: true,
                        inputType: TextInputType.emailAddress,
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
              ],
            ),
            Column(
              children: [
                Text('Tudo certo com sua conta?',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
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
