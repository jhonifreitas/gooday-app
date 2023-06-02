import 'package:flutter/material.dart';

import 'package:gooday/src/common/theme.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    super.key,
    required this.title,
    this.titleCenter = true,
    this.prefix,
    this.suffix,
  });

  final Widget title;
  final bool titleCenter;
  final Widget? prefix;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    Widget? backButton;
    if (prefix == null && Navigator.canPop(context)) {
      backButton = IconButton(
        tooltip: 'Voltar',
        icon: const Icon(Icons.keyboard_backspace, color: primaryColor),
        onPressed: () => Navigator.of(context).pop(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: AppBar(
        leadingWidth: prefix != null ? 20 : null,
        centerTitle: titleCenter,
        backgroundColor: Colors.transparent,
        leading: prefix ?? backButton,
        title: title,
        actions: suffix != null ? [suffix!] : null,
      ),
    );
  }
}