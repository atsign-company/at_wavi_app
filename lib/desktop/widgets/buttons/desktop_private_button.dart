import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:flutter/material.dart';

class DesktopPublicController extends ValueNotifier<bool> {
  DesktopPublicController({bool isPublic = true}) : super(isPublic);
}

class DesktopPublicButton extends StatelessWidget {
  final DesktopPublicController controller;

  DesktopPublicButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.public_rounded,
                  size: 18,
                  color: appTheme.primaryTextColor,
                ),
                SizedBox(width: DesktopDimens.paddingSmall),
                Text(
                  "Public",
                  style: appTheme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          value: 1,
        ),
        PopupMenuItem(
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 18,
                  color: appTheme.primaryTextColor,
                ),
                SizedBox(width: DesktopDimens.paddingSmall),
                Text(
                  "Private",
                  style: appTheme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          value: 2,
        )
      ],
      tooltip: null,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (BuildContext context, bool value, Widget? child) {
          return Row(
            children: [
              Icon(
                value ? Icons.public_rounded : Icons.lock_outline_rounded,
                size: 20,
                color: appTheme.secondaryTextColor,
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
                size: 32,
                color: appTheme.secondaryTextColor,
              ),
            ],
          );
        },
      ),
      onSelected: (index) {
        print(index);
        if (index == 1) {
          controller.value = true;
        } else if (index == 2) {
          controller.value = false;
        }
      },
    );
  }
}
