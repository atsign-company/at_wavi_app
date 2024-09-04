import 'package:at_wavi_app/desktop/screens/desktop_edit_profile/desktop_edit_profile_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_login/desktop_login_landing_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_my_profile/desktop_my_profile_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_user_profile/desktop_user_profile_page.dart';
import 'package:flutter/material.dart';

import 'desktop_route_names.dart';

class DesktopSetupRoutes {
  static String initialRoute = DesktopRoutes.DESKTOP_LOGIN;

  static Map<String, WidgetBuilder> get routes {
    return {
      DesktopRoutes.DESKTOP_LOGIN: (context) => const DesktopLoginLandingPage(),
      DesktopRoutes.DESKTOP_EDIT_PROFILE: (context) => const DesktopEditProfilePage(),
      DesktopRoutes.DESKTOP_USER_PROFILE: (context) => const DesktopUserProfilePage(),
      DesktopRoutes.DESKTOP_MY_PROFILE: (context) => const DesktopMyProfilePage(),
    };
  }

  static Future push(BuildContext context, String value,
      {Object? arguments, Function? callbackAfterNavigation}) {
    return Navigator.of(context)
        .pushNamed(value, arguments: arguments)
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }

  // ignore: always_declare_return_types
  static replace(BuildContext context, String value,
      {dynamic arguments, Function? callbackAfterNavigation}) {
    Navigator.of(context)
        .pushReplacementNamed(value, arguments: arguments)
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }

  // ignore: always_declare_return_types
  static pushAndRemoveAll(BuildContext context, String value,
      {dynamic arguments, Function? callbackAfterNavigation}) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(
      value,
      (_) => false,
      arguments: arguments,
    )
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }
}