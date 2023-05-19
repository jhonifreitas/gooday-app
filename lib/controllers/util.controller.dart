import 'package:flutter/material.dart';

class UtilController {
  final BuildContext context;

  const UtilController({required this.context});

  Future<void> loading([String? text]) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 100),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                ),
                Text(text ?? 'Aguarde...'),
              ],
            ),
          ),
        );
      },
    );
  }

  void message(String text, {Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 5),
        padding: const EdgeInsets.only(left: 20, right: 5, top: 5, bottom: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
