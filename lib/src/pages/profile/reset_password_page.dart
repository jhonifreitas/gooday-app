import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/controllers/auth_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _passwordConfirmCtrl = TextEditingController();

  bool _togglePass = true;
  bool _togglePassConfirm = true;

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordCtrl.text != _passwordConfirmCtrl.text) {
        return UtilService(context).message('As senhas devem ser iguais!');
      }

      UtilService(context).loading('Salvando...');

      await AuthController(context).passwordReset(_passwordCtrl.text);

      if (!mounted) return;

      context.pop();
      context.pop();
      UtilService(context).message('Senha redefinida!');
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  void _onTogglePass() {
    setState(() {
      _togglePass = !_togglePass;
    });
  }

  void _onTogglePassConfirm() {
    setState(() {
      _togglePassConfirm = !_togglePassConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
                    'Esqueceu sua senha?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                      'Preencha os campos abaixo para redefinir sua senha de '
                      'acesso!',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  FormFieldCustom(
                    label: 'Senha',
                    minLength: 6,
                    isRequired: true,
                    obscureText: _togglePass,
                    controller: _passwordCtrl,
                    inputType: TextInputType.number,
                    suffixIcon: IconButton(
                      onPressed: _onTogglePass,
                      icon: _togglePass
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                  FormFieldCustom(
                    label: 'Confirme sua senha',
                    minLength: 6,
                    isRequired: true,
                    obscureText: _togglePassConfirm,
                    controller: _passwordConfirmCtrl,
                    inputType: TextInputType.number,
                    suffixIcon: IconButton(
                      onPressed: _onTogglePassConfirm,
                      icon: _togglePassConfirm
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(width: 10, color: Colors.white),
          ),
          backgroundColor: primaryColor,
          onPressed: _onSubmit,
          child: const Icon(Icons.check, color: Colors.white),
        ),
      ),
    );
  }
}
