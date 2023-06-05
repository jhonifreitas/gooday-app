import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BettyIntroPage extends StatelessWidget {
  const BettyIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => context.push('/config/betty/todos'),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 40),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/background.png'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(width: 120, 'assets/images/logo-white.png'),
              const Text.rich(
                TextSpan(text: 'Agora que já nos apresentamos, ', children: [
                  TextSpan(
                    text: 'vamos montar uma linha de bons hábitos para seu '
                        'dia a dia...',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ]),
                style: TextStyle(color: Colors.white, fontSize: 18),
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
