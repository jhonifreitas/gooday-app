import 'package:flutter/material.dart';

import 'package:gooday/components/appbar.dart';
import 'package:gooday/screens/betty/form/all.dart';

class BettyFormEducationScreen extends StatefulWidget {
  const BettyFormEducationScreen({this.onSubmit, super.key});

  final VoidCallback? onSubmit;

  @override
  State<BettyFormEducationScreen> createState() =>
      _BettyFormEducationScreenState();
}

class _BettyFormEducationScreenState extends State<BettyFormEducationScreen> {
  void _onSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            AppBarCustom(
              title: Image.asset(width: 80, 'assets/images/logo.png'),
            ),
            const BettyRecommendDayli(
              title: 'Suas\nDúvidas',
              iconAssets: 'assets/icons/meditation.svg',
              description: 'Todos os dias vou te enviar algumas sugestões de '
                  'leitura para lhe ajudar a entender melhor a diabetes. Confira '
                  'algumas delas abaixo:',
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: Colors.grey.shade200),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Image.asset('assets/images/diabete.png',
                        fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      'Pessoas com diabetes podem apresentar complicações '
                      'já no início da doença, mesmo que se sintam saudáveis'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: Colors.grey.shade200),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child:
                        Image.asset('assets/images/sock.png', fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 10),
                  const Text('Precauções que as pessoas com diabetes devem ter '
                      'no inverno'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Image.asset('assets/images/sleep.png',
                        fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 10),
                  const Text('Estudos apontam que dormir pouco pode aumentar o '
                      'risco de desenvolver diabetes do tipo 2'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: widget.onSubmit == null,
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(width: 10, color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: _onSubmit,
            child: const Icon(Icons.check, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
