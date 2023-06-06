import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';

class ChipCustom extends StatelessWidget {
  const ChipCustom({
    super.key,
    required this.text,
    required this.selected,
    this.isDisabled = false,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final bool isDisabled;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      selectedColor: primaryColor,
      side: const BorderSide(color: primaryColor),
      showCheckmark: false,
      selected: selected,
      isEnabled: !isDisabled,
      label: Text(
        text,
        style: TextStyle(
          color: selected == false ? primaryColor : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSelected: (value) {
        if (onSelected != null) onSelected!(value);
      },
    );
  }
}
