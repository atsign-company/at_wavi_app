import 'package:another_flushbar/flushbar.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum SnackBarType {
  error,
  info,
  warning,
}

class SnackBarUtils {
  static Future<void> show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
  }) async {
    final appTheme = AppTheme.of(context);
    Color backgroundColor = appTheme.primaryColor;
    switch (type) {
      case SnackBarType.error:
        backgroundColor = Colors.red;
        break;
      case SnackBarType.info:
        backgroundColor = appTheme.primaryColor;
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.yellow;
        break;
    }
    await Flushbar(
      titleColor: Colors.white,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: backgroundColor,
      isDismissible: true,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
