import 'package:flutter/material.dart';

import 'package:gooday/components/chip.dart';
import 'package:gooday/components/appbar.dart';
import 'package:gooday/screens/betty/form/all.dart';
import 'package:gooday/components/grid_image_item.dart';
import 'package:gooday/controllers/betty.controller.dart';

class BettyFormFoodScreen extends StatefulWidget {
  const BettyFormFoodScreen({this.onSubmit, super.key});

  final VoidCallback? onSubmit;

  @override
  State<BettyFormFoodScreen> createState() => _BettyFormFoodScreenState();
}

class _BettyFormFoodScreenState extends State<BettyFormFoodScreen> {
  final _ctrl = BettyController();
  bool? _limit;
  bool? _help;

  void _onSubmit() {}

  void _onLostWeight(bool? value) {
    setState(() {
      _ctrl.lostWeightFoodCtrl = value;
    });
  }

  void _onBelieve(bool? value) {
    setState(() {
      _ctrl.believeFoodCtrl = value;
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
        _ctrl.helpFoodCtrl.add(id);
      } else {
        _ctrl.helpFoodCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onLimit(bool? value) {
    setState(() {
      _limit = value;
    });
  }

  void _onLimitList(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _ctrl.limitFoodCtrl.add(id);
      } else {
        _ctrl.limitFoodCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onFoodList(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _ctrl.foodListCtrl.add(id);
      } else {
        _ctrl.foodListCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onNoFoodList(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _ctrl.noFoodListCtrl.add(id);
      } else {
        _ctrl.noFoodListCtrl.removeWhere((item) => item == id);
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
              title: Image.asset(width: 80, 'assets/images/logo.png'),
            ),
            const BettyRecommendDayli(
              title: 'Sua\nAlimentação',
              iconAssets: 'assets/icons/fruits.svg',
              description:
                  'Calculamos o seu IMC e já estamos estruturando a sua '
                  'rotina. Ainda assim, é essencial levarmos em consideração os '
                  'seus interesses.',
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
                  const Text('Você que perder peso?'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ChipCustom(
                        text: 'Sim',
                        selected: _ctrl.lostWeightFoodCtrl == true,
                        onSelected: (value) =>
                            _onLostWeight(value == true ? true : null),
                      ),
                      const SizedBox(width: 10),
                      ChipCustom(
                        text: 'Não',
                        selected: _ctrl.lostWeightFoodCtrl == false,
                        onSelected: (value) =>
                            _onLostWeight(value == true ? false : null),
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
                  const Text('Você acredita que sua alimentação está '
                      'adequada para um bom controle do diabetes?'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ChipCustom(
                        text: 'Sim',
                        selected: _ctrl.believeFoodCtrl == true,
                        onSelected: (value) =>
                            _onBelieve(value == true ? true : null),
                      ),
                      const SizedBox(width: 10),
                      ChipCustom(
                        text: 'Não',
                        selected: _ctrl.believeFoodCtrl == false,
                        onSelected: (value) =>
                            _onBelieve(value == true ? false : null),
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
                  const Text('Você quer que eu ajude a se alimentar melhor?'),
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
                        for (var item in _ctrl.helpFoodList)
                          CheckboxListTile(
                            value:
                                _ctrl.helpFoodCtrl.any((id) => id == item.id),
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
                    child: Text(
                        'Quais alimentos abaixo você gosta e/ou estão presentes '
                        'em sua rotina?'),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      children: [
                        for (var item in _ctrl.foodList)
                          GridImageItem(
                            tooltip: item.name,
                            image: item.image!,
                            selected:
                                _ctrl.foodListCtrl.any((id) => id == item.id),
                            onSelected: (value) => _onFoodList(item.id, value),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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
                    child: Text.rich(
                      TextSpan(
                        text: 'Quais alimentos abaixo você',
                        children: [
                          TextSpan(
                            text: ' NÃO ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'gosta e/ou não são possíveis de '
                                'estarem em sua rotina?',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      children: [
                        for (var item in _ctrl.foodList)
                          GridImageItem(
                            tooltip: item.name,
                            image: item.image!,
                            selected:
                                _ctrl.noFoodListCtrl.any((id) => id == item.id),
                            onSelected: (value) =>
                                _onNoFoodList(item.id, value),
                          ),
                      ],
                    ),
                  ),
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
                    child: Text('Você tem alguma restrição?'),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: [
                        ChipCustom(
                          text: 'Sim',
                          selected: _limit == true,
                          onSelected: (value) =>
                              _onLimit(value == true ? true : null),
                        ),
                        const SizedBox(width: 10),
                        ChipCustom(
                          text: 'Não',
                          selected: _limit == false,
                          onSelected: (value) =>
                              _onLimit(value == true ? false : null),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: _limit == true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: GridView.count(
                        primary: false,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        children: [
                          for (var item in _ctrl.limitFoodList)
                            CheckboxListTile(
                              value: _ctrl.limitFoodCtrl
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
                              onChanged: (value) =>
                                  _onLimitList(item.id, value),
                            )
                        ],
                      ),
                    ),
                  )
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