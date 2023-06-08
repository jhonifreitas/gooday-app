import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';

class ChipField extends StatelessWidget {
  const ChipField({
    super.key,
    required this.text,
    required this.selected,
    required this.onSelected,
    this.isRequired = false,
    this.isDisabled = false,
  });

  final String text;
  final bool selected;
  final bool isDisabled;
  final bool isRequired;
  final ValueChanged<bool> onSelected;

  String? _validator(bool? value) {
    if (isRequired && value != true) return 'Campo obrigatório';

    return null;
  }

  void _onSelected(FormFieldState<bool> state, bool value) {
    state.didChange(value);
    onSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    double? elevation = 8;
    Color textColor = Colors.white;
    Color borderColor = primaryColor;
    Color selectedColor = primaryColor;

    if (selected == false) textColor = primaryColor;

    if (isDisabled) {
      elevation = null;
      textColor = Colors.grey.shade800;
      borderColor = Colors.grey.shade400;
      selectedColor = Colors.grey.withAlpha(70);
      if (selected == true) borderColor = Colors.transparent;
    }

    return FormField<bool>(
      validator: _validator,
      builder: (state) {
        if (state.hasError) {
          textColor = borderColor = Theme.of(context).colorScheme.error;
        }

        return InputChip(
          elevation: elevation,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          selectedColor: selectedColor,
          side: BorderSide(color: borderColor),
          showCheckmark: false,
          selected: selected,
          isEnabled: !isDisabled,
          onSelected: (value) => _onSelected(state, value),
          label: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
