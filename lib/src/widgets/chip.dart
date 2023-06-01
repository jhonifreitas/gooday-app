import 'package:flutter/material.dart';

class ChipCustom extends StatelessWidget {
  const ChipCustom({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      selectedColor: Theme.of(context).primaryColor,
      side: BorderSide(color: Theme.of(context).primaryColor),
      showCheckmark: false,
      selected: selected,
      label: Text(
        text,
        style: TextStyle(
          color:
              selected == false ? Theme.of(context).primaryColor : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onSelected: (value) {
        if (onSelected != null) onSelected!(value);
      },
    );
  }
}
