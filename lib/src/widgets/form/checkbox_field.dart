import 'package:flutter/material.dart';

class CheckboxField extends StatelessWidget {
  const CheckboxField({
    super.key,
    required this.text,
    required this.selected,
    required this.onSelected,
    this.padding,
    this.isRequired = false,
    this.isDisabled = false,
  });

  final String text;
  final bool selected;
  final bool isDisabled;
  final bool isRequired;
  final EdgeInsets? padding;
  final ValueChanged<bool> onSelected;

  void _onChange(FormFieldState<bool> state, bool? value) {
    state.didChange(value);
    if (value != null) onSelected(value);
  }

  String? _validation(bool? value) {
    if (isRequired && value != true) return 'Campo obrigatório';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      validator: _validation,
      builder: (state) {
        Color textColor = Colors.grey.shade700;
        if (state.hasError) textColor = Theme.of(context).colorScheme.error;

        return ListTile(
          enabled: !isDisabled,
          horizontalTitleGap: 0,
          contentPadding: padding,
          title: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          onTap: () => _onChange(state, !selected),
          leading: Checkbox(
            value: selected,
            onChanged: (value) => _onChange(state, value),
          ),
        );
      },
    );
  }
}
