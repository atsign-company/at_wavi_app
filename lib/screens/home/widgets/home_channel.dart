import 'package:at_wavi_app/services/common_functions.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:provider/provider.dart';

class HomeChannels extends StatefulWidget {
  final ThemeData? themeData;
  final bool isPreview;

  HomeChannels({this.themeData, this.isPreview = false});
  @override
  _HomeChannelsState createState() => _HomeChannelsState();
}

class _HomeChannelsState extends State<HomeChannels> {
  late bool _isDark = false;
  ThemeData? _themeData;

  @override
  void initState() {
    if (widget.themeData != null) {
      _themeData = widget.themeData!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, _provider, _) {
      if (_provider.currentAtsignThemeData != null) {
        _themeData = _provider.currentAtsignThemeData;

        if (_themeData!.scaffoldBackgroundColor ==
            Themes.darkTheme().scaffoldBackgroundColor) {
          _isDark = true;
        }
      }

      if (_themeData == null) {
        return CircularProgressIndicator();
      } else {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CommonFunctions().isFieldsPresentForCategory(AtCategory.SOCIAL,
                      isPreview: widget.isPreview)
                  ? Text(
                      'Social Accounts',
                      style: TextStyles.boldText(_themeData!.primaryColor,
                          size: 18),
                    )
                  : SizedBox(),
              SizedBox(
                  height: CommonFunctions().isFieldsPresentForCategory(
                          AtCategory.SOCIAL,
                          isPreview: widget.isPreview)
                      ? 15.toHeight
                      : 0),
              Column(
                children: CommonFunctions().getCustomCardForFields(
                    _themeData!, AtCategory.SOCIAL,
                    isPreview: widget.isPreview),
              ),
              SizedBox(
                  height: CommonFunctions()
                          .isFieldsPresentForCategory(AtCategory.SOCIAL)
                      ? 40.toHeight
                      : 0),
              CommonFunctions().isFieldsPresentForCategory(AtCategory.GAMER,
                      isPreview: widget.isPreview)
                  ? Text(
                      'Game Accounts',
                      style: TextStyles.boldText(_themeData!.primaryColor,
                          size: 18),
                    )
                  : SizedBox(),
              SizedBox(height: 15.toHeight),
              Column(
                children: CommonFunctions().getCustomCardForFields(
                    _themeData!, AtCategory.GAMER,
                    isPreview: widget.isPreview),
              ),
              SizedBox(height: 15.toHeight),
            ],
          ),
        );
      }
    });
  }
}
