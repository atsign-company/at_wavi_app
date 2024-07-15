import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:flutter/material.dart';

import '../desktop_side_menu.dart';

class DesktopSideMenuWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSelected;
  final DesktopSideMenu menu;

  const DesktopSideMenuWidget({
    Key? key,
    this.onPressed,
    this.isSelected = false,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DesktopDimens.paddingNormal),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Container(
          height: DesktopDimens.buttonHeight,
          alignment: Alignment.centerLeft,
          child: Text(
            menu.title,
            style: appTheme.textTheme.labelLarge?.copyWith(
              color: isSelected ? Colors.white : appTheme.secondaryTextColor,
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(isSelected ? appTheme.primaryColor : Colors.transparent),
          shadowColor: WidgetStateProperty.all(isSelected ? Colors.black.withOpacity(0.16) : Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }
}
