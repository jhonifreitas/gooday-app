import 'package:flutter/material.dart';
import 'package:easy_mask/easy_mask.dart';

import 'package:gooday/src/common/item.dart';

class FormFieldCustom extends StatelessWidget {
  const FormFieldCustom({
    super.key,
    required this.controller,
    this.label,
    this.inputType,
    this.masks,
    this.placeholder,
    this.helper,
    this.obscureText = false,
    this.readOnly = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.isDropdown = false,
    this.maskReverse = false,
    this.showCounter = false,
    this.maxLength,
    this.minLength,
    this.options,
    this.suffixIcon,
    this.prefixIcon,
    this.onChange,
    this.onTap,
  });

  final String? label;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<Item>? options;

  final bool readOnly;
  final bool obscureText;
  final bool isRequired;
  final bool isDisabled;
  final bool isDropdown;
  final bool showCounter;

  final List<String>? masks;
  final bool maskReverse;

  final String? helper;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final int? maxLength;
  final int? minLength;

  final VoidCallback? onTap;
  final ValueChanged<String?>? onChange;

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
    if (isDropdown) {
      controller.text = value ?? '';
    }
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
      value: controller.text.isNotEmpty ? controller.text : null,
      items: [
        for (var option in options!)
          DropdownMenuItem(
            value: option.id,
            child: Text(
              option.name,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
      ],
      focusColor: Colors.white,
      decoration: InputDecoration(labelText: label),
      validator: _valiation,
      onChanged: _onChanged,
    );
  }

  Widget _inputField() {
    TextInputMask? inputMask;

    if (masks != null) {
      inputMask = TextInputMask(
        mask: masks,
        reverse: maskReverse,
        maxLength: masks![masks!.length - 1].length,
      );
      if (controller.text.isNotEmpty) {
        controller.text = inputMask.magicMask.getMaskedString(controller.text);
      }
    }

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      enabled: !isDisabled,
      maxLength: maxLength,
      onTap: onTap,
      onChanged: _onChanged,
      validator: _valiation,
      keyboardType: inputType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      inputFormatters: inputMask != null ? [inputMask] : null,
      decoration: InputDecoration(
        labelText: label,
        icon: prefixIcon,
        helperText: helper,
        hintText: placeholder,
        suffixIcon: suffixIcon,
        counterText: showCounter ? null : '',
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}