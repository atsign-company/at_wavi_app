import 'package:at_client/at_client.dart';
import 'package:at_wavi_app/desktop/routes/desktop_route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:flutter/material.dart';

class DesktopLoginModel extends ChangeNotifier {
  void checkToOnboard({
    required Color onBoardingColor,
  }) async {
    String? currentAtSign = await BackendService().getAtSign();
    AtClientPreference? atClientPreference;
    await BackendService()
        .getAtClientPreference()
        .then((value) => atClientPreference = value)
        .catchError((e) => print(e));

    if (currentAtSign != null && currentAtSign != '') {
      await BackendService().onboard(
        currentAtSign,
        atClientPreference: atClientPreference,
        appColor: onBoardingColor,
        onSuccess: openHomePage,
      );
    }
  }

  void openOnboard({
    required Color onBoardingColor,
  }) async {
    await BackendService().onboard(
      '',
      appColor: onBoardingColor,
      onSuccess: openHomePage,
    );
  }

  void openHomePage() {
    SetupRoutes.pushAndRemoveAll(
        NavService.navKey.currentContext!, DesktopRoutes.DESKTOP_MY_PROFILE);
  }
}
