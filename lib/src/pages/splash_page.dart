import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final authCtrl = AuthController();
    final authId = await authCtrl.fetchUser();

    if (!mounted) return;

    if (authId != null) {
      context.read<UserProvider>().getByAuthId(authId);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/auth/entrar', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Expanded(
              child: Image.asset('assets/images/logo-white.png'),
            ),
            const CircularProgressIndicator(color: Colors.white)
          ],
        ),
      ),
    );
  }
}
