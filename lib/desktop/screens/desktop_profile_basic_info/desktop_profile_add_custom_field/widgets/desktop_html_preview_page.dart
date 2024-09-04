import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class DesktopHtmlPreviewPage extends StatelessWidget {
  final String html;

  const DesktopHtmlPreviewPage({
    Key? key,
    required this.html,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: appTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8)),
            child: SingleChildScrollView(
              child: Container(
                child: HtmlWidget(
                  html,
                  // hyperlinkColor: Colors.blue, //Todo
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: DesktopIconButton(
              iconData: Icons.close_rounded,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
