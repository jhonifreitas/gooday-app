import 'package:flutter/material.dart';

import 'package:gooday/src/widgets/chip.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/pages/betty/form/all.dart';
import 'package:gooday/src/widgets/grid_image_item.dart';
import 'package:gooday/src/controllers/betty_controller.dart';

class BettyFormFitnessPage extends StatefulWidget {
  const BettyFormFitnessPage({this.onSubmit, super.key});

  final VoidCallback? onSubmit;

  @override
  State<BettyFormFitnessPage> createState() => _BettyFormFitnessPageState();
}

class _BettyFormFitnessPageState extends State<BettyFormFitnessPage> {
  final _bettyCtrl = BettyController();
  bool? _help;

  void _onSubmit() {}

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

  void _onHelpList(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.helpExerciseCtrl.add(id);
      } else {
        _bettyCtrl.helpExerciseCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onExerciseList(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.exerciseListCtrl.add(id);
      } else {
        _bettyCtrl.exerciseListCtrl.removeWhere((item) => item == id);
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
                        for (var item in _bettyCtrl.helpExerciseList)
                          CheckboxListTile(
                            value: _bettyCtrl.helpExerciseCtrl
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
                                const EdgeInsets.symmetric(horizontal: 35),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) => _onHelpList(item.id, value),
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
                        'Quais hábitos abaixo estão presentes ou são possíveis de '
                        'serem inseridas a sua rotina?'),
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
                            selected: _bettyCtrl.exerciseListCtrl
                                .any((id) => id == item.id),
                            onSelected: (value) =>
                                _onExerciseList(item.id, value),
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
        visible: widget.onSubmit == null,
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
