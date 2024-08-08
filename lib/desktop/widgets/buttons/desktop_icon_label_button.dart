import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:flutter/material.dart';

class DesktopIconLabelButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;
  final String label;
  final bool isPrefixIcon;
  final EdgeInsetsGeometry? padding;

  const DesktopIconLabelButton({
    Key? key,
    required this.iconData,
    required this.label,
    this.onPressed,
    this.isPrefixIcon = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return SizedBox(
      height: DesktopDimens.buttonHeight,
      child: Directionality(
        textDirection: isPrefixIcon ? TextDirection.ltr : TextDirection.rtl,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            color: appTheme.primaryColor,
          ),
          label: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: appTheme.primaryColor,
            ),
          ),
          style: ButtonStyle(
            padding:
                padding == null ? null : WidgetStateProperty.all(padding),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
          ),
        ),
      ),
    );
  }
}
