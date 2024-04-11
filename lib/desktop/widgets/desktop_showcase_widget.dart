import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class DesktopShowCaseWidget extends StatelessWidget {
  GlobalKey globalKey;
  Widget container;
  IconData iconData;
  double iconSize;
  double childSize;
  double overlayOpacity;
  Color overlayColor;

  DesktopShowCaseWidget({
    Key? key,
    required this.globalKey,
    required this.container,
    required this.iconData,
    this.overlayOpacity = 0.75,
    this.overlayColor = Colors.black,
    this.iconSize = 16,
    this.childSize = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Showcase.withWidget(
      key: globalKey,
      targetShapeBorder: CircleBorder(),
      disableMovingAnimation: true,
      container: container,
      targetPadding: EdgeInsets.all(6),
      overlayOpacity: overlayOpacity,
      overlayColor: overlayColor,
      height: childSize * 1.5,
      width: childSize * 1.5,
      child: Container(
        height: childSize,
        width: childSize,
        child: RawMaterialButton(
          shape: new CircleBorder(),
          elevation: 0.0,
          fillColor: appTheme.borderColor,
          child: Icon(
            iconData,
            size: iconSize,
            color: ColorConstants.blackShade2,
          ),
          onPressed: () {
            ShowCaseWidget.of(context).dismiss();
            ShowCaseWidget.of(context).startShowCase([globalKey]);
          },
        ),
      ),
    );
  }
}
