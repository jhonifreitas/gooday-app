import 'package:flutter/material.dart';

class CheckboxListTileCustom extends StatelessWidget {
  const CheckboxListTileCustom({
    super.key,
    required this.text,
    required this.selected,
    required this.onSelected,
    this.padding,
    this.isDisabled = false,
  });

  final String text;
  final bool selected;
  final bool isDisabled;
  final EdgeInsets? padding;
  final ValueChanged<bool> onSelected;

  void _onTap() {
    onSelected(!selected);
  }

  void _onChange(bool? value) {
    if (value != null) onSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: !isDisabled,
      horizontalTitleGap: 0,
      contentPadding: padding,
      title: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade700,
        ),
      ),
      onTap: _onTap,
      leading: Checkbox(
        value: selected,
        onChanged: _onChange,
      ),
    );
  }
}
