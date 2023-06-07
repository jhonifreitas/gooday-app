import 'package:flutter/material.dart';

import 'package:gooday/src/common/item.dart';
import 'package:gooday/src/common/theme.dart';
import 'package:gooday/src/widgets/button.dart';
import 'package:gooday/src/widgets/form_field.dart';
import 'package:gooday/src/widgets/checkbox_list_tile.dart';

class GlycemiaPage extends StatefulWidget {
  const GlycemiaPage({super.key});

  @override
  State<GlycemiaPage> createState() => _GlycemiaPageState();
}

class _GlycemiaPageState extends State<GlycemiaPage> {
  final _glycemiaCtrl = TextEditingController();
  final List<String> _typeCtrl = [];
  final List<Item> _typeList = const [
    Item(id: 'before-breakfast', name: 'Antes do Café'),
    Item(id: 'after-breakfast', name: 'Depois do Café'),
    Item(id: 'before-lunch', name: 'Antes do Almoço'),
    Item(id: 'after-lunch', name: 'Depois do Almoço'),
    Item(id: 'before-dinner', name: 'Antes do Jantar'),
    Item(id: 'after-dinner', name: 'Depois do Jantar'),
    Item(id: 'sleep', name: 'Ao dormir/Madrugada'),
  ];

  Future<void> _onSubmit() async {}

  void _onType(String id, bool? selected) {
    setState(() {
      if (selected == true) {
        _typeCtrl.add(id);
      } else {
        _typeCtrl.removeWhere((item) => item == id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Registrar Glicemia',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: FormFieldCustom(
              label: 'Informe sua glicemia',
              placeholder: '000 mg/dL',
              controller: _glycemiaCtrl,
              isRequired: true,
              inputType: TextInputType.number,
              maxLength: 3,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text('Selecione o tipo de glicemia'),
          ),
          Wrap(
            children: [
              for (var item in _typeList)
                SizedBox(
                  width: (MediaQuery.of(context).size.width) / 2,
                  child: CheckboxListTileCustom(
                    selected: _typeCtrl.any((id) => id == item.id),
                    text: item.name,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    onSelected: (value) => _onType(item.id, value),
                  ),
                )
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ButtonCustom(text: 'Salvar', onPressed: _onSubmit),
          )
        ],
      ),
    );
  }
}
