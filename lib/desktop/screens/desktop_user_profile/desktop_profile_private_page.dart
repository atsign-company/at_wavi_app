import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

class DesktopProfilePrivatePage extends StatefulWidget {
  const DesktopProfilePrivatePage({Key? key}) : super(key: key);

  @override
  _DesktopProfilePrivatePageState createState() =>
      _DesktopProfilePrivatePageState();
}

class _DesktopProfilePrivatePageState extends State<DesktopProfilePrivatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      color: ColorConstants.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/private_profile.png',
            fit: BoxFit.fitWidth,
            width: 120,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            Strings.desktop_private_profile,
            style: TextStyle(
              fontSize: 18,
              color: appTheme.primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            Strings.desktop_follow_user,
            style: TextStyle(
              fontSize: 14,
              color: appTheme.secondaryTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
