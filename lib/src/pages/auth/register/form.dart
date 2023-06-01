import 'dart:io';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/widgets/profile_image.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/controllers/auth_controller.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  late final AuthController _authCtrl;
  final _formKey = GlobalKey<FormState>();

  File? _image;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authCtrl = AuthController(context);
  }

  Future<void> _signInFacebook() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInFacebook();

    if (user != null && mounted) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/auth/cadastrar/anamnese');
    }
  }

  Future<void> _signInGoogle() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInGoogle();

    if (user != null && mounted) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/auth/cadastrar/anamnese');
    }
  }

  Future<void> _signInApple() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInApple();

    if (user != null && mounted) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/auth/cadastrar/anamnese');
    }
  }

  Future<void> _onUploadImage() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null && context.mounted) {
        UtilService(context).loading('Carregando...');

        setState(() {
          _image = File(pickedFile.path);
        });

        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Cadastrando...');

      final user = await _authCtrl.registerWithEmail(
          _emailCtrl.text, _passwordCtrl.text);

      if (!mounted) return;

      if (user != null) {
        final userProvider = context.read<UserProvider>();
        final data = {
          'name': _nameCtrl.text,
          'phone': _phoneCtrl.text,
        };

        await userProvider.update(data);
        if (_image != null) await userProvider.uploadImage(_image!);

        if (!mounted) return;
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
                  ProfileImage(
                    image: _image?.path,
                    onUpload: _onUploadImage,
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
