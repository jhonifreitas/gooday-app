import 'dart:io';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/profile_image.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/controllers/user_controller.dart';
import 'package:gooday/src/controllers/auth_controller.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  State<AuthRegisterPage> createState() => _AuthRegisterPageState();
}

class _AuthRegisterPageState extends State<AuthRegisterPage> {
  final _userCtrl = UserController();
  late final AuthController _authCtrl;
  final _formKey = GlobalKey<FormState>();
  late UserProvider _userProvider;

  File? _image;

  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _authCtrl = AuthController(context);
  }

  Future<void> _signInFacebook() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInFacebook();

    if (!mounted) return;
    context.pop();
    if (user != null) context.push('/auth/cadastrar/anamnese');
  }

  Future<void> _signInGoogle() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInGoogle();

    if (!mounted) return;
    context.pop();
    if (user != null) context.push('/auth/cadastrar/anamnese');
  }

  Future<void> _signInApple() async {
    UtilService(context).loading('Entrando...');
    final user = await _authCtrl.signInApple();

    if (!mounted) return;
    context.pop();
    if (user != null) context.push('/auth/cadastrar/anamnese');
  }

  Future<void> _onUploadImage() async {
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null && mounted) {
          UtilService(context).loading('Carregando...');
          final file = File(pickedFile.path);
          await _userProvider.uploadImage(file).catchError((_) {
            UtilService(context).message('Não foi possível salvar a imagem!');
          });
          if (mounted) context.pop();
        }
      } catch (e) {
        UtilService(context)
            .message('Não foi possível carregar a imagem.\nTente Novamente!');
      }
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        UtilService(context).loading('Cadastrando...');

        final user = await _authCtrl.registerWithEmail(
            _userCtrl.emailCtrl.text, _passwordCtrl.text);

        if (!mounted) return;

        if (user != null) {
          final Map<String, dynamic> data = {
            'name': _userCtrl.nameCtrl.text,
            'email': _userCtrl.emailCtrl.text,
            'phone': _userCtrl.clearPhone(),
          };

          await _userProvider.update(data);
          if (_image != null) await _userProvider.uploadImage(_image!);

          if (!mounted) return;
          context.pop();
          context.push('/auth/cadastrar/anamnese');
        }
      } on FirebaseAuthException catch (e) {
        context.pop();
        String msg = 'Não foi possível realizar o cadastro!';
        if (e.code == 'email-already-in-use') msg = 'Usuário já cadastrado!';
        UtilService(context).message(msg);
      }
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
      body: SingleChildScrollView(
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
                  Text('E você?',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text('Queremos conhecê-lo'),
                  const SizedBox(height: 10),
                  ProfileImage(image: _image?.path, onUpload: _onUploadImage),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        InputField(
                          label: 'Nome',
                          controller: _userCtrl.nameCtrl,
                          isRequired: true,
                        ),
                        InputField(
                          label: 'Celular',
                          controller: _userCtrl.phoneCtrl,
                          isRequired: true,
                          minLength: 15,
                          inputType: TextInputType.number,
                          masks: const ['(99) 99999-9999'],
                        ),
                        InputField(
                          label: 'E-mail',
                          controller: _userCtrl.emailCtrl,
                          isRequired: true,
                          inputType: TextInputType.emailAddress,
                        ),
                        InputField(
                          label: 'Senha',
                          controller: _passwordCtrl,
                          minLength: 6,
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
                  Text(
                    'Já possui uma conta?',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonal(
                    onPressed: () => _goToBack(),
                    child: const Text('Acessar'),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
                    heroTag: 'register-btn-google',
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
                Visibility(
                  visible: Platform.isIOS,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FloatingActionButton(
                      tooltip: 'Apple',
                      heroTag: 'register-btn-apple',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
