import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/logger.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/internet_connectivity_checker.dart';
import 'desktop_onboarding_page.dart';
import 'desktop_login_page.dart';

class DesktopLoginLandingPage extends StatefulWidget {
  const DesktopLoginLandingPage({Key? key}) : super(key: key);

  @override
  _DesktopLoginLandingPageState createState() =>
      _DesktopLoginLandingPageState();
}

class _DesktopLoginLandingPageState extends State<DesktopLoginLandingPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("home called from desktop");
      await Provider.of<InternetConnectivityChecker>(context, listen: false)
          .checkConnectivity();
    });

    setup();
  }

  void setup() async {
    logger.d((await path_provider.getApplicationDocumentsDirectory()).path);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final appTheme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: appTheme.backgroundColor,
      body: Container(
        child: const Row(
          children: [
            Expanded(
              flex: 1,
              child: DesktopLoginPage(),
            ),
            Expanded(
              flex: 1,
              child: DesktopOnBoardingPage(),
            ),
          ],
        ),
      ),
    );
  }
}
