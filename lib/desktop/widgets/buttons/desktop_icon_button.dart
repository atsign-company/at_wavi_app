import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DesktopIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const DesktopIconButton({
    Key? key,
    required this.iconData,
    this.onPressed,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: RawMaterialButton(
        shape: const CircleBorder(),
        onPressed: onPressed,
        elevation: 0,
        fillColor: backgroundColor ?? appTheme.primaryLighterColor,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        child: Icon(
          iconData,
          color: iconColor ?? appTheme.primaryColor,
          size: size / 2,
        ),
      ),
    );
  }
}
