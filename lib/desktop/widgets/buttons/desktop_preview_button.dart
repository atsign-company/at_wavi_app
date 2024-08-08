import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DesktopPreviewButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const DesktopPreviewButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return SizedBox(
      width: 40,
      height: 40,
      child: FloatingActionButton(
        onPressed: onPressed,
        elevation: 0,
        backgroundColor: appTheme.primaryLighterColor,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        child: Icon(
          Icons.remove_red_eye_outlined,
          color: appTheme.primaryColor,
          size: 22,
        ),
      ),
    );
  }
}
