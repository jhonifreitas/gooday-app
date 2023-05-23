import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

import 'package:gooday/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  int _coins = 0;

  void _goToUser() {}

  void _onImageUpload() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/background.png'),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AppBar(
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          onPressed: _goToUser,
                          icon: SvgPicture.asset(
                            width: 20,
                            'assets/icons/user.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        title: const Text('Meu Perfil'),
                        actions: [
                          IconButton(
                            onPressed: _goToUser,
                            icon: SvgPicture.asset(
                              width: 20,
                              'assets/icons/edit-square.svg',
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Material(
                            clipBehavior: Clip.hardEdge,
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              onTap: _onImageUpload,
                              splashColor: Colors.black.withAlpha(30),
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: SvgPicture.asset(
                                  'assets/icons/user.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          width: 30,
                          height: 30,
                          child: IconButton(
                            padding: const EdgeInsets.all(6),
                            onPressed: _onImageUpload,
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Color(0xFFF7C006)),
                            ),
                            icon: const Icon(
                              size: 15,
                              color: Colors.white,
                              Icons.photo_camera_outlined,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '${_user?.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      heightFactor: 0.5,
                      alignment: const Alignment(0, -1),
                      child: Card(
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/images/logo.svg',
                                      width: 80),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SvgPicture.asset(
                                        'assets/icons/coin.svg',
                                        width: 30),
                                  ),
                                  Text('$_coins coins')
                                ],
                              ),
                              const Icon(Icons.chevron_right,
                                  color: Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Card(
                  elevation: 15,
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    children: [
                      _listTile(
                        'Notificações',
                        () {},
                        const Icon(Icons.notifications_active,
                            size: 15, color: Colors.white),
                      ),
                      _listTile(
                        'Conta',
                        () {},
                        const Icon(Icons.face, size: 15, color: Colors.white),
                      ),
                      _listTile(
                        'Privacidade',
                        () {},
                        const Icon(Icons.visibility,
                            size: 15, color: Colors.white),
                      ),
                      _listTile(
                        'Segurança',
                        () {},
                        const Icon(Icons.lock, size: 15, color: Colors.white),
                      ),
                      _listTile(
                        'Ajuda',
                        () {},
                        const Icon(Icons.question_mark,
                            size: 15, color: Colors.white),
                      ),
                      _listTile(
                        'Suporte',
                        () {},
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child:
                              SvgPicture.asset('assets/icons/logo-white.svg'),
                        ),
                      ),
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
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listTile(String text, VoidCallback onTap, Widget icon) {
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
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: icon,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
