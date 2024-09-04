import 'package:at_wavi_app/desktop/screens/desktop_my_profile/desktop_profile_data_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

import 'desktop_profile_info_page.dart';

class DesktopUserProfilePage extends StatefulWidget {
  const DesktopUserProfilePage({Key? key}) : super(key: key);

  @override
  _DesktopUserProfilePageState createState() => _DesktopUserProfilePageState();
}

class _DesktopUserProfilePageState extends State<DesktopUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: Container(
        child: Row(
          children: [
            const SizedBox(
              width: DesktopDimens.sideMenuWidth,
              child: DesktopProfileInfoPage(
                atSign: '',
                isPreview: true,
              ),
            ),
            Container(
              width: 1,
              color: appTheme.separatorColor,
            ),
            Expanded(
              child: DesktopProfileDataPage(
                isMyProfile: false,
                isEditable: false,
                onSearchPressed: () {},
                onSettingPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
