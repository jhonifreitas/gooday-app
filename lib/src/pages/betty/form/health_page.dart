import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/pages/betty/form/all_page.dart';
import 'package:gooday/src/controllers/betty_controller.dart';

class BettyFormHealthPage extends StatefulWidget {
  const BettyFormHealthPage({this.bettyCtrl, super.key});

  final BettyController? bettyCtrl;

  @override
  State<BettyFormHealthPage> createState() => _BettyFormHealthPageState();
}

class _BettyFormHealthPageState extends State<BettyFormHealthPage> {
  late final UserProvider _userProvider;
  late final _bettyCtrl = widget.bettyCtrl ?? BettyController();

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = _userProvider.data;
    if (user?.config?.betty != null) _bettyCtrl.initData(user!.config!.betty!);
  }

  Future<void> _onSubmit() async {
    UtilService(context).loading('Salvando...');

    final Map<String, dynamic> data = {
      'timeExercise': _bettyCtrl.timeExerciseCtrl,
      'frequencyExercise': _bettyCtrl.frequencyExerciseCtrl,
    };

    final config = _userProvider.data!.config!.toJson();
    config['betty'] = data;

    await _userProvider.update({'config': config});

    if (!mounted) return;

    context.pop();
    context.pop();
  }

  void _onTimeList(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.timeExerciseCtrl.add(id);
      } else {
        _bettyCtrl.timeExerciseCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onFrequencyList(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.frequencyExerciseCtrl = int.parse(id);
      } else {
        _bettyCtrl.frequencyExerciseCtrl = null;
      }
    });
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
              title: 'Seu\nBem-estar',
              iconAssets: 'assets/icons/meditation.svg',
              description:
                  'O bem-estar é muito importante para o seu dia a dia. '
                  'Pretendo enviar para você algumas atividades (como meditação) '
                  'que vão lhe ajudar a relaxar.',
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: Colors.grey.shade200),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text('Qual o horário que você gostaria de receber '
                        'essas atividades?'),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GridView.count(
                      primary: false,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      children: [
                        for (var item in _bettyCtrl.timeExerciseList)
                          CheckboxListTile(
                            value: _bettyCtrl.timeExerciseCtrl
                                .any((id) => id == item.id),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) => _onTimeList(item.id, value),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text('Com que frequência gostaria de realizá-las?'),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      for (var item in _bettyCtrl.frequencyExerciseList)
                        CheckboxListTile(
                          value: _bettyCtrl.frequencyExerciseCtrl.toString() ==
                              item.id,
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 35),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) =>
                              _onFrequencyList(item.id, value),
                        )
                    ],
                  )
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
