import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';

showPublicPrivateBottomSheet(
    {required Function onPublicClicked, required Function onPrivateClicked, double height = 200}) {
  return showModalBottomSheet(
      context: NavService.navKey.currentContext!,
      backgroundColor: Theme.of(NavService.navKey.currentContext!).scaffoldBackgroundColor,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
                child: InkWell(
                  onTap: () {
                    onPublicClicked();
                    Navigator.of(context).pop();
                  },
                  child: publicRow(),
                ),
              ),
              const Divider(),
              SizedBox(
                height: 50,
                child: InkWell(
                  onTap: () {
                    onPrivateClicked();
                    Navigator.of(context).pop();
                  },
                  child: privateRow(),
                ),
              ),
            ],
          ),
        );
      });
}

Widget privateRow() {
  return Row(
    children: [
      Icon(
        Icons.lock,
        color: Theme.of(NavService.navKey.currentContext!).primaryColor,
      ),
      SizedBox(width: 5.toWidth),
      Text(
        'Private',
        style: TextStyles.lightText(Theme.of(NavService.navKey.currentContext!).primaryColor, size: 16),
      )
    ],
  );
}

Widget publicRow() {
  return Row(
    children: [
      Icon(
        Icons.public,
        color: Theme.of(NavService.navKey.currentContext!).primaryColor,
      ),
      SizedBox(width: 5.toWidth),
      Text(
        'Public',
        style: TextStyles.lightText(Theme.of(NavService.navKey.currentContext!).primaryColor, size: 16),
      )
    ],
  );
}
