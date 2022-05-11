import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/enums.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

import 'item/desktop_notification_item.dart';

class DesktopNotificationListPage extends StatefulWidget {

  DesktopNotificationListPage({
    Key? key,
  }) : super(key: key);

  @override
  _DesktopNotificationListPageState createState() =>
      _DesktopNotificationListPageState();
}

class _DesktopNotificationListPageState
    extends State<DesktopNotificationListPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ListView.separated(
      itemCount: 5,
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.transparent,
          height: 0.5,
        );
      },
      itemBuilder: (context, i) {
        return DesktopNotificationItem(
          type: i % 2 == 0
              ? NotificationItemType.Normal
              : NotificationItemType.Media,
        );
      },
    );
  }
}
