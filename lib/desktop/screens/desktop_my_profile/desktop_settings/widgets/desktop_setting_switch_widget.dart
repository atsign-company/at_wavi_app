import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:flutter/material.dart';

class DesktopSettingSwitchWidget extends StatelessWidget {
  final IconData prefixIcon;
  final String title;
  final bool isOn;
  final bool isUpdating;
  final ValueChanged<bool>? onChanged;

  const DesktopSettingSwitchWidget({
    Key? key,
    required this.prefixIcon,
    required this.title,
    required this.isOn,
    required this.isUpdating,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: DesktopDimens.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: DesktopDimens.paddingNormal),
          Icon(
            prefixIcon,
            color: appTheme.primaryTextColor,
          ),
          SizedBox(width: DesktopDimens.paddingNormal),
          Expanded(
            child: Text(
              title,
              style: appTheme.textTheme.titleMedium,
            ),
          ),
          SizedBox(width: DesktopDimens.paddingSmall),
          Container(
            width: 48,
            child: Center(
              child: isUpdating
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: appTheme.primaryColor,
                      ),
                    )
                  : Switch(
                      value: isOn,
                      onChanged: onChanged,
                      activeColor: appTheme.primaryColor,
                    ),
            ),
          ),
          SizedBox(width: DesktopDimens.paddingNormal),
        ],
      ),
    );
  }
}
