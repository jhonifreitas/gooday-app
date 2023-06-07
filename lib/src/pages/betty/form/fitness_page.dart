import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/widgets/chip.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/grid_image_item.dart';
import 'package:gooday/src/pages/betty/form/all_page.dart';
import 'package:gooday/src/widgets/checkbox_list_tile.dart';
import 'package:gooday/src/controllers/betty_controller.dart';

class BettyFormFitnessPage extends StatefulWidget {
  const BettyFormFitnessPage({this.bettyCtrl, super.key});

  final BettyController? bettyCtrl;

  @override
  State<BettyFormFitnessPage> createState() => _BettyFormFitnessPageState();
}

class _BettyFormFitnessPageState extends State<BettyFormFitnessPage> {
  late final UserProvider _userProvider;
  late final _bettyCtrl = widget.bettyCtrl ?? BettyController();

  bool? _help;

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
      'doExercise': _bettyCtrl.doExerciseCtrl,
      'exerciseHelps': _bettyCtrl.exerciseHelpsCtrl,
      'exercises': _bettyCtrl.exercisesCtrl,
    };

    final config = _userProvider.data!.config!.toJson();
    config['betty'] = data;

    await _userProvider.update({'config': config});

    if (!mounted) return;

    context.pop();
    context.pop();
  }

  void _onDoExercise(bool? value) {
    setState(() {
      _bettyCtrl.doExerciseCtrl = value;
    });
  }

  void _onHelp(bool? value) {
    setState(() {
      _help = value;
    });
  }

  void _onExerciseHelps(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.exerciseHelpsCtrl.add(id);
      } else {
        _bettyCtrl.exerciseHelpsCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onExercises(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.exercisesCtrl.add(id);
      } else {
        _bettyCtrl.exercisesCtrl.removeWhere((item) => item == id);
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
              title: 'Seus\nExercícios',
              iconAssets: 'assets/icons/fitness.svg',
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
                  const Text(
                      'Você já se exercita de forma suficiente para atingir '
                      'seus objetivos de saúde?'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ChipCustom(
                        text: 'Sim',
                        selected: _bettyCtrl.doExerciseCtrl == true,
                        onSelected: (value) =>
                            _onDoExercise(value == true ? true : null),
                      ),
                      const SizedBox(width: 10),
                      ChipCustom(
                        text: 'Não',
                        selected: _bettyCtrl.doExerciseCtrl == false,
                        onSelected: (value) =>
                            _onDoExercise(value == true ? false : null),
                      ),
                    ],
                  )
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
                  const Text(
                      'Você quer que eu te ajude a se exercitar mais e melhor?'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ChipCustom(
                        text: 'Sim',
                        selected: _help == true,
                        onSelected: (value) =>
                            _onHelp(value == true ? true : null),
                      ),
                      const SizedBox(width: 10),
                      ChipCustom(
                        text: 'Não',
                        selected: _help == false,
                        onSelected: (value) =>
                            _onHelp(value == true ? false : null),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Visibility(
              visible: _help == true,
              child: Container(
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
                      child: Text('Como eu posso te ajudar?'),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        for (var item in _bettyCtrl.exerciseHelpList)
                          CheckboxListTileCustom(
                            selected: _bettyCtrl.exerciseHelpsCtrl
                                .any((id) => id == item.id),
                            text: item.name,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            onSelected: (value) =>
                                _onExerciseHelps(item.id, value),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                        'Quais hábitos abaixo estão presentes ou são possíveis '
                        'de serem inseridas a sua rotina?'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      children: [
                        for (var item in _bettyCtrl.exerciseList)
                          GridImageItem(
                            tooltip: item.name,
                            image: item.image!,
                            selected: _bettyCtrl.exercisesCtrl
                                .any((id) => id == item.id),
                            onSelected: (value) => _onExercises(item.id, value),
                          ),
                      ],
                    ),
                  ),
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
