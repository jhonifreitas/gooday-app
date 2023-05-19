import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ButtonCustom({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          if (onPressed != null) onPressed!();
        },
        child: Text(text),
      ),
    );
  }
}
