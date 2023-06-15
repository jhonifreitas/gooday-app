import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class UtilService {
  const UtilService(this.context);

  final BuildContext context;

  Future<void> loading([String? text]) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 50),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
                const SizedBox(width: 10),
                Text(text ?? 'Aguarde...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> dialogConfirm(String title, String message) async {
    final dialog = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Não'),
              onPressed: () => context.pop(false),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(Colors.red),
                overlayColor:
                    MaterialStatePropertyAll(Colors.red.withOpacity(0.1)),
              ),
              child: const Text('Sim'),
              onPressed: () => context.pop(true),
            ),
          ],
        );
      },
    );
    return dialog ?? false;
  }

  void dateTimePicker({
    required ValueChanged<DateTime> onChange,
    DateTime? initialDateTime,
    DateTime? maximumDate,
    DateTime? minimumDate,
    int minuteInterval = 1,
    CupertinoDatePickerMode? mode,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: CupertinoDatePicker(
            use24hFormat: true,
            maximumDate: maximumDate,
            minimumDate: minimumDate,
            minuteInterval: minuteInterval,
            initialDateTime: initialDateTime,
            dateOrder: DatePickerDateOrder.dmy,
            mode: mode ?? CupertinoDatePickerMode.date,
            onDateTimeChanged: onChange,
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
