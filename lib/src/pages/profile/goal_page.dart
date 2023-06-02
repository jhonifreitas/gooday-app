import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/appbar.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/controllers/user_controller.dart';

class GoalConfigPage extends StatefulWidget {
  const GoalConfigPage({super.key});

  @override
  State<GoalConfigPage> createState() => _GoalConfigPageState();
}

class _GoalConfigPageState extends State<GoalConfigPage> {
  final _userCtrl = UserController();

  void _onSubmit() async {
    // if () {
    //   UtilService(context).loading('Salvando...');
    //   final data = _userCtrl.onSerialize();

    //   if (!mounted) return;

    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop();
    // } else {
    //   UtilService(context).message('Verifique os campos destacados!');
    // }
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
          Padding(
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
                FormFieldCustom(
                  label: 'Passos',
                  controller: _userCtrl.nameCtrl,
                  inputType: TextInputType.number,
                  prefixIcon: SvgPicture.asset(
                    'assets/icons/shoe.svg',
                    width: 30,
                  ),
                ),
                FormFieldCustom(
                  label: 'Kilometros',
                  controller: _userCtrl.nameCtrl,
                  inputType: TextInputType.number,
                  prefixIcon: SvgPicture.asset(
                    'assets/icons/pin.svg',
                    width: 30,
                  ),
                ),
                FormFieldCustom(
                  label: 'Calorias',
                  controller: _userCtrl.nameCtrl,
                  inputType: TextInputType.number,
                  prefixIcon: SvgPicture.asset(
                    'assets/icons/fire.svg',
                    width: 30,
                  ),
                ),
                FormFieldCustom(
                  label: 'Minutos ativos',
                  controller: _userCtrl.nameCtrl,
                  inputType: TextInputType.number,
                  prefixIcon: SvgPicture.asset(
                    'assets/icons/clock-race.svg',
                    width: 30,
                  ),
                ),
              ],
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
