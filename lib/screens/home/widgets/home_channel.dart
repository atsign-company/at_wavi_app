import 'package:at_wavi_app/services/common_functions.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
// commented out as it is not used
// import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:provider/provider.dart';

class HomeChannels extends StatefulWidget {
  final ThemeData? themeData;
  final bool isPreview;

  const HomeChannels({Key? key, this.themeData, this.isPreview = false}) : super(key: key);
  @override
  _HomeChannelsState createState() => _HomeChannelsState();
}

class _HomeChannelsState extends State<HomeChannels> {

// commented out as it is not used
  // late bool _isDark = false;
  ThemeData? _themeData;

  @override
  void initState() {
    if (widget.themeData != null) {
      _themeData = widget.themeData!;
    }
    _getThemeData();
    super.initState();
  }

  _getThemeData() async {
    if (widget.themeData != null) {
      _themeData = widget.themeData!;
    } else {
      _themeData =
          await Provider.of<ThemeProvider>(context, listen: false).getTheme();
    }

// commented out as it is not used
    // if (_themeData!.scaffoldBackgroundColor ==
    //     Themes.darkTheme().scaffoldBackgroundColor) {
    //   _isDark = true;
    // }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_themeData == null) {
      return const CircularProgressIndicator();
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CommonFunctions().isFieldsPresentForCategory(AtCategory.SOCIAL,
                    isPreview: widget.isPreview)
                ? Text(
                    'Social Accounts',
                    style:
                        TextStyles.boldText(_themeData!.primaryColor, size: 18),
                  )
                : const SizedBox(),
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
                    style:
                        TextStyles.boldText(_themeData!.primaryColor, size: 18),
                  )
                : const SizedBox(),
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
  }
}
