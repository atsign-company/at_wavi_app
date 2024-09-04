import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:flutter/material.dart';

class DesktopSettingWidget extends StatelessWidget {
  final IconData prefixIcon;
  final String title;
  final VoidCallback? onTapped;

  const DesktopSettingWidget({
    Key? key,
    required this.prefixIcon,
    required this.title,
    this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: onTapped,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: DesktopDimens.paddingSmall),
        child: Row(
          children: [
            const SizedBox(width: DesktopDimens.paddingNormal),
            Icon(
              prefixIcon,
              color: appTheme.primaryTextColor,
            ),
            const SizedBox(width: DesktopDimens.paddingNormal),
            Text(
              title,
              style: appTheme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
