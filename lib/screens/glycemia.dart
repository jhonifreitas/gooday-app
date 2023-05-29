import 'package:flutter/material.dart';
import 'package:gooday/models/option.dart';
import 'package:gooday/components/button.dart';
import 'package:gooday/components/form_field.dart';

class GlycemiaScreen extends StatefulWidget {
  const GlycemiaScreen({super.key});

  @override
  State<GlycemiaScreen> createState() => _GlycemiaScreenState();
}

class _GlycemiaScreenState extends State<GlycemiaScreen> {
  final _ctrl = TextEditingController();
  final List<String> _typeCtrl = [];
  final List<Option> _typeList = const [
    Option(id: 'before-breakfast', name: 'Antes do Café'),
    Option(id: 'after-breakfast', name: 'Depois do Café'),
    Option(id: 'before-lunch', name: 'Antes do Almoço'),
    Option(id: 'after-lunch', name: 'Depois do Almoço'),
    Option(id: 'before-dinner', name: 'Antes do Jantar'),
    Option(id: 'after-dinner', name: 'Depois do Jantar'),
    Option(id: 'sleep', name: 'Ao dormir/Madrugada'),
  ];

  void _onSubmit() {}

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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Registrar Glicemia',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FormFieldCustom(
            label: 'Informe sua glicemia',
            placeholder: '000 mg/dL',
            controller: _ctrl,
            isRequired: true,
            inputType: TextInputType.number,
            maxLength: 3,
          ),
          const SizedBox(height: 10),
          const Text('Selecione o tipo de glicemia'),
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            children: [
              for (var item in _typeList)
                CheckboxListTile(
                  value: _typeCtrl.any((id) => id == item.id),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) => _onType(item.id, value),
                )
            ],
          ),
          const SizedBox(height: 20),
          ButtonCustom(text: 'Salvar', onPressed: _onSubmit)
        ],
      ),
    );
  }
}
