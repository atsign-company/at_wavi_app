import 'dart:convert';

import 'package:at_wavi_app/desktop/screens/desktop_my_profile/desktop_follow/desktop_follow_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_my_profile/desktop_settings/desktop_settings_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_user_profile/desktop_profile_info_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'desktop_profile_data_page.dart';
import 'desktop_search_atsign/desktop_search_atsign_page.dart';

class DesktopMyProfilePage extends StatefulWidget {
  const DesktopMyProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _DesktopMyProfilePageState createState() => _DesktopMyProfilePageState();
}

class _DesktopMyProfilePageState extends State<DesktopMyProfilePage> {
  final _globalKey = GlobalKey<ScaffoldState>();
  final _parentScaffoldKey = GlobalKey<ScaffoldState>();
  bool isFollower = true;

  @override
  void initState() {
    super.initState();
    FieldOrderService().setPreviewOrder = {...FieldOrderService().fieldOrders};
    var userJson =
        User.toJson(Provider.of<UserProvider>(context, listen: false).user);
    User previewUser = User.fromJson(json.decode(json.encode(userJson)));
    Provider.of<UserPreview>(context, listen: false).setUser = previewUser;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Scaffold(
      key: _parentScaffoldKey,
      endDrawer: const DesktopSettingsPage(),
      body: Scaffold(
        key: _globalKey,
        backgroundColor: ColorConstants.white,
        endDrawer: const DesktopSearchAtSignPage(),
        drawer: const DesktopFollowPage(),
        body: Row(
          children: [
            SizedBox(
              width: DesktopDimens.sideMenuWidth,
              child: DesktopProfileInfoPage(
                atSign: '',
                onFollowerPressed: () {
                  _globalKey.currentState?.openDrawer();
                },
                onFollowingPressed: () {
                  _globalKey.currentState?.openDrawer();
                },
                isPreview: false,
              ),
            ),
            Container(
              width: 1,
              color: appTheme.separatorColor,
            ),
            Expanded(
              child: DesktopProfileDataPage(
                isMyProfile: true,
                isEditable: false,
                onSearchPressed: () {
                  _globalKey.currentState?.openEndDrawer();
                },
                onSettingPressed: () {
                  _parentScaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
