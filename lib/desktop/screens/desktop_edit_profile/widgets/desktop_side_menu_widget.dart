import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            menu.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: isSelected ? Colors.white : appTheme.secondaryTextColor,
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              isSelected ? appTheme.primaryColor : Colors.transparent),
          shadowColor: MaterialStateProperty.all(
              isSelected ? Colors.black.withOpacity(0.16) : Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }
}
