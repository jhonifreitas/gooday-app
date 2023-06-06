import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooday/src/widgets/appbar.dart';

class BettyIntroPage extends StatelessWidget {
  const BettyIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => context.push('/config/betty/todos'),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 40),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/background.png'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBarCustom(
                brightness: Brightness.dark,
                iconBackColor: Colors.white,
                title: Image.asset(width: 120, 'assets/images/logo-white.png'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text.rich(
                  TextSpan(text: 'Agora que já nos apresentamos, ', children: [
                    TextSpan(
                      text: 'vamos montar uma linha de bons hábitos para seu '
                          'dia a dia...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const Text(
                'Toque para continuar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
