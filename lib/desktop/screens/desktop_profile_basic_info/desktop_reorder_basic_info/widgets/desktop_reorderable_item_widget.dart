import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DesktopReorderableItemWidget extends StatelessWidget {
  final int index;
  final String title;
  final EdgeInsets? margin;

  const DesktopReorderableItemWidget({
    Key? key,
    required this.index,
    required this.title,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      color: appTheme.backgroundColor,
      child: Container(
        height: 52,
        margin: margin,
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Container(
                width: 52,
                child: Center(
                  child: Icon(
                    Icons.reorder,
                    color: appTheme.secondaryColor,
                  ),
                ),
              ),
            ),
            Container(
              color: appTheme.borderColor,
              width: 1,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: TextStyle(
                  color: appTheme.primaryTextColor,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: appTheme.borderColor, width: 1),
        ),
      ),
    );
  }
}
