import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: AppBar(
        leadingWidth: 20,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: prefix,
        title: title,
        actions: suffix != null ? [suffix!] : null,
      ),
    );
  }
}
