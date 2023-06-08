import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/services/util_service.dart';
import 'package:gooday/src/providers/user_provider.dart';
import 'package:gooday/src/widgets/form/input_field.dart';
import 'package:gooday/src/widgets/form/dropdown_field.dart';
import 'package:gooday/src/controllers/goal_controller.dart';

class GoalConfigPage extends StatefulWidget {
  const GoalConfigPage({super.key});

  @override
  State<GoalConfigPage> createState() => _GoalConfigPageState();
}

class _GoalConfigPageState extends State<GoalConfigPage> {
  final _formKey = GlobalKey<FormState>();

  final _goalCtrl = GoalController();
  late final UserProvider _userProvider;

  List<Item> _stepList = const [];

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = _userProvider.data;
    if (user != null) {
      _goalCtrl.initData(user);

      setState(() {
        _stepList = _goalCtrl.stepList(user.dateBirth!);
      });
    }
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      UtilService(context).loading('Salvando...');
      final data = _goalCtrl.clearValues();

      if (!mounted) return;

      final config = _userProvider.data!.config!.toJson();
      config['goal'] = data;
      await _userProvider.update({'config': config});

      if (!mounted) return;

      context.pop();
      context.pop();
    } else {
      UtilService(context).message('Verifique os campos destacados!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBarCustom(
            title: Image.asset('assets/images/logo.png', width: 80),
          ),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configure suas metas!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                      'As metas são importantes para você ganha todo dia '
                      'goodies, caso atinja suas metas.',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 10),
                  DropdownField(
                    label: 'Passos',
                    isRequired: true,
                    controller: _goalCtrl.stepsCtrl,
                    icon: SvgPicture.asset(
                      'assets/icons/shoe.svg',
                      width: 30,
                    ),
                    options: _stepList,
                  ),
                  InputField(
                    label: 'Quilometros',
                    controller: _goalCtrl.distanceCtrl,
                    inputType: TextInputType.number,
                    icon: SvgPicture.asset(
                      'assets/icons/pin.svg',
                      width: 30,
                    ),
                  ),
                  InputField(
                    label: 'Calorias',
                    controller: _goalCtrl.caloriesCtrl,
                    inputType: TextInputType.number,
                    icon: SvgPicture.asset(
                      'assets/icons/fire.svg',
                      width: 30,
                    ),
                  ),
                  InputField(
                    label: 'Minutos ativos',
                    controller: _goalCtrl.exerciseTimeCtrl,
                    inputType: TextInputType.number,
                    icon: SvgPicture.asset(
                      'assets/icons/clock-race.svg',
                      width: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: SizedBox(
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
    );
  }
}
