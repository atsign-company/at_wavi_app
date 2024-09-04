// import 'package:at_common_flutter/at_common_flutter.dart' as CommonFlutter;
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
// import 'package:at_wavi_app/services/size_config.dart' as SizeConfig;
import 'package:flutter/material.dart';

import 'custom_button.dart';

Future<bool?> confirmationDialog(String atsign) async {
  bool? choice;
  await showDialog<bool>(
    context: NavService.navKey.currentContext!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SizedBox(
        width: SizeConfig().screenWidth * 0.8,
        child: AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : ColorConstants.darkGrey,
          contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(
                    'Are you sure, you want to unfollow $atsign ?',
                    style: TextStyles.grey16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    onTap: () {
                      choice = true;
                      Navigator.pop(NavService.navKey.currentContext!, choice);
                    },
                    bgColor: Theme.of(context).primaryColor,
                    highlightColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : ColorConstants.darkGrey,
                    width: 164.toWidth,
                    height: 48.toHeight,
                    child: Text(
                      'Yes!',
                      style: TextStyle(
                          fontSize: 15.toFont,
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    onTap: () {
                      choice = false;
                      Navigator.pop(NavService.navKey.currentContext!, choice);
                    },
                    bgColor: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).scaffoldBackgroundColor
                        : ColorConstants.darkGrey,
                    highlightColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).scaffoldBackgroundColor
                            : ColorConstants.darkGrey,
                    width: 164.toWidth,
                    height: 48.toHeight,
                    child: Text(
                      'No',
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextStyles.black(size: 14)
                          : CustomTextStyles.white(size: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  return choice;
}
