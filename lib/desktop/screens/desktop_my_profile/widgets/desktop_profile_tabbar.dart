import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:flutter/material.dart';

class DesktopProfileTabBar extends StatelessWidget {
  final TabController tab;
  final ValueChanged<int>? onTap;

  DesktopProfileTabBar({required this.tab, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      height: 48,
      width: 320,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: appTheme.separatorColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(56 / 2),
            ),
          ),
          TabBar(
            controller: tab,
            tabs: [
              Container(child: Center(child: Text(Strings.desktop_details))),
              Container(child: Center(child: Text(Strings.desktop_channels))),
              // Container(child: Center(child: Text(Strings.desktop_featured))),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: appTheme.primaryTextColor,
            labelStyle: appTheme.textTheme.titleMedium,
            unselectedLabelStyle: appTheme.textTheme.titleMedium,
            padding: EdgeInsets.zero,
            indicator: BoxDecoration(
              color: appTheme.primaryColor,
              borderRadius: BorderRadius.circular(56 / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(2, 4),
                  blurRadius: 6,
                )
              ],
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
