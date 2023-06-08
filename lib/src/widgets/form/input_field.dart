import 'package:flutter/material.dart';
import 'package:easy_mask/easy_mask.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    this.inputType,
    this.label,
    this.hint,
    this.helper,
    this.readOnly = false,
    this.obscureText = false,
    this.isRequired = false,
    this.isDisabled = false,
    this.showCounter = false,
    this.masks,
    this.maskReverse = false,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.minLength,
    this.onTap,
    this.onChange,
  });

  final TextEditingController controller;
  final TextInputType? inputType;

  final String? label;
  final String? hint;
  final String? helper;

  final bool readOnly;
  final bool obscureText;
  final bool isRequired;
  final bool isDisabled;
  final bool showCounter;

  final List<String>? masks;
  final bool maskReverse;

  final Widget? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final int? maxLength;
  final int? minLength;

  final VoidCallback? onTap;
  final ValueChanged<String?>? onChange;

  String? _validator(String? value) {
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
    TextInputMask? inputMask;

    if (masks != null) {
      inputMask = TextInputMask(mask: masks, reverse: maskReverse);
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
      validator: _validator,
      keyboardType: inputType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      inputFormatters: inputMask != null ? [inputMask] : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helper,
        icon: icon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: showCounter ? null : '',
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
