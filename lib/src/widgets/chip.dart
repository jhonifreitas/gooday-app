import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';

class ChipCustom extends StatelessWidget {
  const ChipCustom({
    super.key,
    required this.text,
    required this.selected,
    required this.onSelected,
    this.isDisabled = false,
  });

  final String text;
  final bool selected;
  final bool isDisabled;
  final ValueChanged<bool> onSelected;

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

    return InputChip(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      selectedColor: selectedColor,
      side: BorderSide(color: borderColor),
      showCheckmark: false,
      selected: selected,
      isEnabled: !isDisabled,
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSelected: onSelected,
    );
  }
}
