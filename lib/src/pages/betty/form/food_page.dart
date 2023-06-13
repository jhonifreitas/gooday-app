import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/grid_image_item.dart';
import 'package:gooday/src/widgets/form/chip_field.dart';
import 'package:gooday/src/pages/betty/form/all_page.dart';
import 'package:gooday/src/widgets/form/checkbox_field.dart';
import 'package:gooday/src/controllers/betty_controller.dart';

class BettyFormFoodPage extends StatefulWidget {
  const BettyFormFoodPage({this.bettyCtrl, super.key});

  final BettyController? bettyCtrl;

  @override
  State<BettyFormFoodPage> createState() => _BettyFormFoodPageState();
}

class _BettyFormFoodPageState extends State<BettyFormFoodPage> {
  late final UserProvider _userProvider;
  late final _bettyCtrl = widget.bettyCtrl ?? BettyController();

  bool? _limit;
  bool? _help;

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = _userProvider.data;
    if (user?.config?.betty != null) {
      _bettyCtrl.initData(user!.config!.betty!);

      if (user.config!.betty!.foodHelps.isNotEmpty) _onHelp(true);
      if (user.config!.betty!.foodLimits.isNotEmpty) _onLimit(true);
    }
  }

  Future<void> _onSubmit() async {
    UtilService(context).loading('Salvando...');

    final Map<String, dynamic> data = {
      'lostWeight': _bettyCtrl.lostWeightFoodCtrl,
      'adequateFood': _bettyCtrl.adequateFoodCtrl,
      'foodHelps': _bettyCtrl.foodHelpsCtrl,
      'foodLikes': _bettyCtrl.foodLikesCtrl,
      'foodNoLikes': _bettyCtrl.foodNoLikesCtrl,
      'foodLimits': _bettyCtrl.foodLimitsCtrl,
    };

    final config = _userProvider.data!.config!.toJson();
    config['betty'] = data;

    await _userProvider.update({'config': config});

    if (!mounted) return;

    context.pop();
    context.pop();
  }

  void _onLostWeight(bool? value) {
    setState(() {
      _bettyCtrl.lostWeightFoodCtrl = value;
    });
  }

  void _onAdequateFood(bool? value) {
    setState(() {
      _bettyCtrl.adequateFoodCtrl = value;
    });
  }

  void _onHelp(bool? value) {
    setState(() {
      _help = value;
    });
  }

  void _onFoodHelps(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.foodHelpsCtrl.add(id);
      } else {
        _bettyCtrl.foodHelpsCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onLimit(bool? value) {
    setState(() {
      _limit = value;
    });
  }

  void _onFoodLikes(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.foodLikesCtrl.add(id);
      } else {
        _bettyCtrl.foodLikesCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onFoodNoLikes(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.foodNoLikesCtrl.add(id);
      } else {
        _bettyCtrl.foodNoLikesCtrl.removeWhere((item) => item == id);
      }
    });
  }

  void _onFoodLimits(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _bettyCtrl.foodLimitsCtrl.add(id);
      } else {
        _bettyCtrl.foodLimitsCtrl.removeWhere((item) => item == id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CheckboxField> foodHelps = [];
    for (final item in _bettyCtrl.foodHelpList) {
      final food = CheckboxField(
        selected: _bettyCtrl.foodHelpsCtrl.any((id) => id == item.id),
        text: item.name,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        onSelected: (value) => _onFoodHelps(item.id, value),
      );
      foodHelps.add(food);
    }

    List<GridImageItem> foodLikes = [];
    for (final item in _bettyCtrl.foodList) {
      final food = GridImageItem(
        tooltip: item.name,
        image: item.image!,
        selected: _bettyCtrl.foodLikesCtrl.any((id) => id == item.id),
        onSelected: (value) => _onFoodLikes(item.id, value),
      );
      foodLikes.add(food);
    }

    List<GridImageItem> foodNoLikes = [];
    for (final item in _bettyCtrl.foodList) {
      final food = GridImageItem(
        tooltip: item.name,
        image: item.image!,
        selected: _bettyCtrl.foodNoLikesCtrl.any((id) => id == item.id),
        onSelected: (value) => _onFoodNoLikes(item.id, value),
      );
      foodNoLikes.add(food);
    }

    List<SizedBox> foodLimits = [];
    for (final item in _bettyCtrl.foodLimitList) {
      final food = SizedBox(
        width: (MediaQuery.of(context).size.width) / 2,
        child: CheckboxField(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          selected: _bettyCtrl.foodLimitsCtrl.any((id) => id == item.id),
          text: item.name,
          onSelected: (value) => _onFoodLimits(item.id, value),
        ),
      );
      foodLimits.add(food);
    }

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
                  const Text('Você quer perder peso?'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ChipField(
                        text: 'Sim',
                        selected: _bettyCtrl.lostWeightFoodCtrl == true,
                        onSelected: (value) =>
                            _onLostWeight(value == true ? true : null),
                      ),
                      const SizedBox(width: 10),
                      ChipField(
                        text: 'Não',
                        selected: _bettyCtrl.lostWeightFoodCtrl == false,
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
                      ChipField(
                        text: 'Sim',
                        selected: _bettyCtrl.adequateFoodCtrl == true,
                        onSelected: (value) =>
                            _onAdequateFood(value == true ? true : null),
                      ),
                      const SizedBox(width: 10),
                      ChipField(
                        text: 'Não',
                        selected: _bettyCtrl.adequateFoodCtrl == false,
                        onSelected: (value) =>
                            _onAdequateFood(value == true ? false : null),
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
                      ChipField(
                        text: 'Sim',
                        selected: _help == true,
                        onSelected: (value) =>
                            _onHelp(value == true ? true : null),
                      ),
                      const SizedBox(width: 10),
                      ChipField(
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
                      children: foodHelps,
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
                      children: foodLikes,
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
                      children: foodNoLikes,
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
                        ChipField(
                          text: 'Sim',
                          selected: _limit == true,
                          onSelected: (value) =>
                              _onLimit(value == true ? true : null),
                        ),
                        const SizedBox(width: 10),
                        ChipField(
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
                    child: Wrap(
                      children: foodLimits,
                    ),
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
