import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/pages/betty/form/all_page.dart';
import 'package:gooday/src/controllers/betty_controller.dart';

class BettyFormEducationPage extends StatefulWidget {
  const BettyFormEducationPage({this.bettyCtrl, super.key});

  final BettyController? bettyCtrl;

  @override
  State<BettyFormEducationPage> createState() => _BettyFormEducationPageState();
}

class _BettyFormEducationPageState extends State<BettyFormEducationPage> {
  void _onSubmit() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            AppBarCustom(
              iconBackColor: primaryColor,
              title: Image.asset(width: 80, 'assets/images/logo.png'),
            ),
            const BettyRecommendDayli(
              title: 'Suas\nDúvidas',
              iconAssets: 'assets/icons/book.svg',
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
        visible: widget.bettyCtrl == null,
        child: SizedBox(
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
      ),
    );
  }
}
