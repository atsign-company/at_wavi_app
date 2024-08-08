import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DesktopTutorialPopup extends StatelessWidget {
  final Widget? header;
  final Widget? child;

  const DesktopTutorialPopup({
    Key? key,
    this.header,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 72,
            height: 72,
            margin: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: appTheme.backgroundColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: header,
            ),
          ),
          Container(
            child: child,
          ),
        ],
      ),
    );
  }
}
