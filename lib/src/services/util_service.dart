import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

  void dateTimePicker({
    required ValueChanged<DateTime> onChange,
    DateTime? initialDateTime,
    DateTime? maximumDate,
    DateTime? minimumDate,
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
