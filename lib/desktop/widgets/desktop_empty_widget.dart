import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:flutter/material.dart';

class DesktopEmptyWidget extends StatelessWidget {
  final Widget image;
  final String title;
  final String description;
  final String buttonTitle;
  final VoidCallback? onButtonPressed;
  final bool showAddButton;

  const DesktopEmptyWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonTitle,
    required this.onButtonPressed,
    this.showAddButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        image,
        SizedBox(height: DesktopDimens.paddingNormal),
        Text(
          title,
          style: appTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: appTheme.primaryTextColor,
          ),
        ),
        SizedBox(height: DesktopDimens.paddingSmall),
        Text(
          description,
          style: appTheme.textTheme.titleSmall?.copyWith(
            color: appTheme.secondaryTextColor,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        if (showAddButton) SizedBox(height: DesktopDimens.paddingNormal),
        if (showAddButton)
          ElevatedButton(
            onPressed: onButtonPressed,
            child: Text(
              buttonTitle,
              style: appTheme.textTheme.labelLarge?.copyWith(
                color: appTheme.primaryColor,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
              elevation: WidgetStateProperty.all<double>(0),
            ),
          )
      ],
    );
  }
}
