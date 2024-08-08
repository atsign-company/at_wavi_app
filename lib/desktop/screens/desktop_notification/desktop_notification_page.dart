import 'package:at_wavi_app/desktop/screens/desktop_notification/desktop_new_request_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_notification/desktop_notification_list_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_tabbar.dart';
import 'package:flutter/material.dart';

class DesktopNotificationPage extends StatefulWidget {
  const DesktopNotificationPage({
    Key? key,
  }) : super(key: key);

  @override
  _DesktopNotificationPageState createState() =>
      _DesktopNotificationPageState();
}

class _DesktopNotificationPageState extends State<DesktopNotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
            },
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            right: 112,
            top: 112,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    color: appTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: appTheme.borderColor,
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        child: DesktopTabBar(
                          controller: _tabController,
                          tabTitles: const [
                            Strings.desktop_notifications,
                            Strings.desktop_new_request,
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: const [
                            DesktopNotificationListPage(),
                            DesktopNewRequestPage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
