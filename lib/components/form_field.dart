import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? inputType;
  final bool obscureText;
  final bool isRequired;
  final bool isDisabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? mask;
  final ValueChanged<String?>? onChange;

  const FormFieldWidget(
      {super.key,
      required this.label,
      required this.controller,
      this.inputType,
      this.mask,
      this.obscureText = false,
      this.isRequired = false,
      this.isDisabled = false,
      this.onChange,
      this.suffixIcon,
      this.prefixIcon});

  String? _valiation(String? value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'Campo obrigatório';
    }
    if (value != null && value.isNotEmpty) {
      if (inputType == TextInputType.emailAddress &&
          !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
              .hasMatch(value)) {
        return 'E-mail inválido';
      }
    }
    return null;
  }

  void _onChanged(String? value) {
    if (onChange != null) onChange!(value);
  }

  @override
  Widget build(BuildContext context) {
    final maskFormatter = MaskTextInputFormatter(
        mask: mask,
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: !isDisabled,
      onChanged: _onChanged,
      inputFormatters: [if (mask != null) maskFormatter],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(fontSize: 14),
      keyboardType: inputType,
      validator: _valiation,
      onSaved: (value) {
        if (mask != null) controller.text = maskFormatter.getUnmaskedText();
      },
    );
  }
}
