import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCard extends StatelessWidget {
  final String? title, subtitle;
  final bool isUrl;
  final String? url;
  final bool isEmail;
  final ThemeData themeData;
  CustomCard(
      {this.title,
      this.isEmail = false,
      this.url,
      required this.subtitle,
      this.isUrl = false,
      required this.themeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeData.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            title != null
                ? Text(
                    '${title![0].toUpperCase()}${title!.substring(1)}',
                    style: TextStyles.lightText(
                        themeData.primaryColor.withOpacity(0.5),
                        size: 16),
                  )
                : SizedBox(),
            SizedBox(height: 6),
            subtitle != null
                ? GestureDetector(
                    onTap: () async {
                      if (isEmail) {
                        Uri emailUrl = Uri(
                          scheme: "mailto",
                          path: subtitle,
                        );
                        await launchUrl(emailUrl);
                        return;
                      }
                      if (!isUrl) {
                        return;
                      }

                      if (await canLaunchUrl(Uri.parse(url ?? ""))) {
                        try {
                          await launchUrl(Uri.parse(url ?? ""),
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          SetupRoutes.push(context, Routes.WEB_VIEW,
                              arguments: {'title': title, 'url': url});
                        }
                      } else {
                        SetupRoutes.push(context, Routes.WEB_VIEW,
                            arguments: {'title': title, 'url': url});
                      }
                    },
                    child: HtmlWidget(
                      subtitle!,
                      textStyle: TextStyle(
                        color: isUrl || isEmail
                            ? ColorConstants.orange
                            : themeData.primaryColor,
                        fontSize: 16.toFont,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
