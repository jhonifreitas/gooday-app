import 'package:flutter/material.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Option {
  final String id;
  final String name;

  const Option({required this.id, required this.name});
}

class FormFieldCustom extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<Option>? options;

  final bool obscureText;
  final bool isRequired;
  final bool isDisabled;
  final bool isDropdown;

  final String? mask;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final int? maxLength;
  final int? minLength;

  final ValueChanged<String?>? onChange;

  const FormFieldCustom({
    super.key,
    required this.label,
    required this.controller,
    this.inputType,
    this.mask,
    this.obscureText = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.isDropdown = false,
    this.maxLength,
    this.minLength,
    this.options,
    this.onChange,
    this.suffixIcon,
    this.prefixIcon,
  });

  String? _valiation(String? value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$label obrigatório';
    }
    if (value != null && value.isNotEmpty) {
      if (inputType == TextInputType.emailAddress &&
          !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
              .hasMatch(value)) {
        return 'E-mail inválido';
      }
      if (minLength != null && value.length < minLength!) {
        return 'Carácteres mínimo $minLength, atual ${value.length}';
      }
    }
    return null;
  }

  void _onChanged(String? value) {
    if (onChange != null) onChange!(value);
  }

  @override
  Widget build(BuildContext context) {
    if (options != null) {
      if (isDropdown) return _dropownField();
    }

    return _inputField();
  }

  Widget _dropownField() {
    return DropdownButtonFormField<String>(
      value: controller.value.text != "" ? controller.value.text : null,
      items: [
        for (var option in options!)
          DropdownMenuItem(value: option.id, child: Text(option.name))
      ],
      focusColor: Colors.white,
      decoration: InputDecoration(labelText: label),
      validator: _valiation,
      onChanged: _onChanged,
    );
  }

  Widget _inputField() {
    final maskFormatter = MaskTextInputFormatter(
        mask: mask,
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: !isDisabled,
      maxLength: maxLength,
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
