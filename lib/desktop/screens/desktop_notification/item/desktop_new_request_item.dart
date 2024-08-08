import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:at_wavi_app/desktop/widgets/images/desktop_circle_avatar.dart';

class DesktopNewRequestItem extends StatelessWidget {

  const DesktopNewRequestItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      color: appTheme.backgroundColor,
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DesktopCircleAvatar(
            url: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
            size: 48,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '@lauren changed her profile picture',
                  style: TextStyle(
                    color: ColorConstants.blackShade2,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '15 min ago',
                  style: TextStyle(
                    color: appTheme.secondaryTextColor,
                    fontSize: 11,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          DesktopButton(
            width: 56,
            height: 32,
            textSize: 10,
            titleColor: appTheme.primaryTextColor,
            backgroundColor: appTheme.borderColor,
            borderColor: appTheme.separatorColor,
            title: Strings.desktop_delete,
            onPressed: () async {},
          ),
          const SizedBox(
            width: 5,
          ),
          DesktopButton(
            width: 56,
            height: 32,
            textSize: 10,
            backgroundColor: appTheme.primaryColor,
            title: Strings.desktop_confirm,
            onPressed: () async {},
          ),
        ],
      ),
    );
  }
}
