import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DesktopTabBar extends StatelessWidget {
  final List<String> tabTitles;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final double spacer;

  const DesktopTabBar({Key? key, 
    this.tabTitles = const [],
    this.controller,
    this.onTap,
    this.spacer = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabs: tabTitles
            .map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Text(e),
              ),
            )
            .toList(),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        labelColor: appTheme.primaryTextColor,
        unselectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        unselectedLabelColor: appTheme.secondaryTextColor,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: appTheme.primaryColor),
            insets: EdgeInsets.only(right: spacer)),
        indicatorColor: appTheme.primaryColor,
        indicatorWeight: 3,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.only(right: spacer),
        enableFeedback: false,
        automaticIndicatorColorAdjustment: false,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: onTap,
      ),
    );
  }
}
