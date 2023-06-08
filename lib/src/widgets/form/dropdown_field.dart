import 'package:flutter/material.dart';

import 'package:gooday/src/common/item.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.controller,
    required this.options,
    this.label,
    this.hint,
    this.helper,
    this.readOnly = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.onChange,
  });

  final TextEditingController controller;
  final List<Item> options;

  final String? label;
  final String? hint;
  final String? helper;

  final bool readOnly;
  final bool isRequired;
  final bool isDisabled;

  final Widget? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final ValueChanged<String?>? onChange;

  String? _validator(String? value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$label obrigatório';
    }
    return null;
  }

  void _onChanged(String? value) {
    if (value != null) {
      controller.text = value;
    } else {
      controller.clear();
    }

    if (onChange != null) onChange!(value);
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> items = [];

    for (final option in options) {
      final item = DropdownMenuItem(
        value: option.id,
        child: Text(
          option.name,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
      items.add(item);
    }

    return DropdownButtonFormField<String>(
      items: items,
      validator: _validator,
      onChanged: _onChanged,
      focusColor: Colors.white,
      value: controller.text.isNotEmpty ? controller.text : null,
      decoration: InputDecoration(
        icon: icon,
        hintText: hint,
        labelText: label,
        helperText: helper,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
