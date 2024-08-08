import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

class DesktopMainTabBar extends StatefulWidget {
  final Function(int?)? onSelected;

  const DesktopMainTabBar({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  _DesktopMainTabBarState createState() => _DesktopMainTabBarState();
}

class _DesktopMainTabBarState extends State<DesktopMainTabBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: appTheme.borderColor,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              selectedIndex = 0;
              widget.onSelected!(0);
              setState(() {});
            },
            child: Container(
              decoration: selectedIndex == 0
                  ? BoxDecoration(
                      color: appTheme.primaryColor,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.borderColor,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    )
                  : null,
              padding:
                  const EdgeInsets.only(left: 24, top: 12, bottom: 12, right: 24),
              child: Text(
                Strings.desktop_details,
                style: TextStyle(
                  color: selectedIndex == 0
                      ? ColorConstants.white
                      : appTheme.primaryTextColor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              selectedIndex = 1;
              widget.onSelected!(1);
              setState(() {});
            },
            child: Container(
              decoration: selectedIndex == 1
                  ? BoxDecoration(
                      color: appTheme.primaryColor,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.borderColor,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    )
                  : null,
              padding:
                  const EdgeInsets.only(left: 24, top: 12, bottom: 12, right: 24),
              child: Text(
                Strings.desktop_channels,
                style: TextStyle(
                  color: selectedIndex == 1
                      ? ColorConstants.white
                      : appTheme.primaryTextColor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              selectedIndex = 2;
              widget.onSelected!(2);
              setState(() {});
            },
            child: Container(
              decoration: selectedIndex == 2
                  ? BoxDecoration(
                      color: appTheme.primaryColor,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.borderColor,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    )
                  : null,
              padding:
                  const EdgeInsets.only(left: 24, top: 12, bottom: 12, right: 24),
              child: Text(
                Strings.desktop_featured,
                style: TextStyle(
                  color: selectedIndex == 2
                      ? ColorConstants.white
                      : appTheme.primaryTextColor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
