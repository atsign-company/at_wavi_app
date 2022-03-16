import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_logo.dart';
import 'package:flutter/material.dart';

class DesktopWelcomeWidget extends StatelessWidget {
  final String? titlePage;

  const DesktopWelcomeWidget({Key? key, this.titlePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Welcome to',
                style: appTheme.textTheme.headline4?.copyWith(
                  fontSize: 32,
                ),
              ),
              //note
              SizedBox(width: DesktopDimens.paddingSmall),
              Container(
                padding: EdgeInsets.only(bottom: 7),
                child: DesktopLogo(),
              ),
            ],
          ),
          SizedBox(height: DesktopDimens.paddingSmall),
          Text(
            titlePage ?? 'Please fill-in the necessary details to start using.',
            style: appTheme.textTheme.subtitle2?.copyWith(
              fontWeight: FontWeight.w500,
              color: appTheme.secondaryTextColor,
            ),
          )
        ],
      ),
    );
  }
}
