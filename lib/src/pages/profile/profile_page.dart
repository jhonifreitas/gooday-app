import 'dart:io';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/profile_image.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/controllers/auth_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _coins = 0;

  void _goToGoodies() {
    Navigator.pushNamed(context, '/goodies');
  }

  void _goToUser() {
    Navigator.pushNamed(context, '/user');
  }

  void _goToBetty() {
    Navigator.pushNamed(context, '/betty/config');
  }

  Future<void> _onSignOut() async {
    UtilService(context).loading('Saindo...');
    final authCtrl = AuthController(context);

    await authCtrl.signOut();
    if (!mounted) return;

    Navigator.of(context).pop();
    Navigator.pushNamedAndRemoveUntil(
        context, '/auth/entrar', (route) => false);
  }

  Future<void> _onUploadImage() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null && context.mounted) {
        UtilService(context).loading('Carregando...');
        final file = File(pickedFile.path);
        await context.read<UserProvider>().uploadImage(file);
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 30),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background.png'),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: AppBarCustom(
                    prefix: SvgPicture.asset(
                      'assets/icons/user.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: const Text('Meu Perfil',
                        style: TextStyle(color: Colors.white)),
                    suffix: IconButton(
                      tooltip: 'Sair',
                      onPressed: _onSignOut,
                      icon: const Icon(Icons.logout, color: Colors.white),
                    ),
                  ),
                ),
                ProfileImage(
                  onUpload: _onUploadImage,
                  image: context.watch<UserProvider>().data?.image,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${context.watch<UserProvider>().data?.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -25),
            child: Card(
              elevation: 15,
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: ListTile(
                onTap: _goToGoodies,
                title: Row(
                  children: [
                    Image.asset('assets/images/logo.png', width: 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child:
                          SvgPicture.asset('assets/icons/coin.svg', width: 30),
                    ),
                    Text(
                      '$_coins coins',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                    )
                  ],
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 15,
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  _ProfileListTile(
                    text: 'Notificações',
                    icon: const Icon(Icons.notifications_active,
                        size: 15, color: Colors.white),
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    text: 'Conta',
                    icon: const Icon(Icons.face, size: 15, color: Colors.white),
                    onTap: _goToUser,
                  ),
                  _ProfileListTile(
                    text: 'Privacidade',
                    icon: const Icon(Icons.visibility,
                        size: 15, color: Colors.white),
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    text: 'Segurança',
                    icon: const Icon(Icons.lock, size: 15, color: Colors.white),
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    text: 'Ajuda',
                    icon: const Icon(Icons.question_mark,
                        size: 15, color: Colors.white),
                    onTap: () {},
                  ),
                  _ProfileListTile(
                    text: 'Suporte',
                    icon: Padding(
                      padding: const EdgeInsets.all(3),
                      child: SvgPicture.asset('assets/icons/logo-white.svg'),
                    ),
                    onTap: () {},
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Card(
              elevation: 15,
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                title: const Text(
                  'Configurar Assistente Virtual',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                leading: Image.asset('assets/images/betty-avatar.png'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _goToBetty,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  const _ProfileListTile(
      {required this.text, required this.icon, required this.onTap});

  final String text;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      leading: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: icon,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
