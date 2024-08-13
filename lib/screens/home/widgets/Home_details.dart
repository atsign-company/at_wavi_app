import 'package:at_wavi_app/services/common_functions.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
// commenting out since its not being used
// import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:provider/provider.dart';

class HomeDetails extends StatefulWidget {
  final ThemeData? themeData;
  final bool isPreview;
  const HomeDetails({Key? key, this.themeData, this.isPreview = false}) : super(key: key);
  @override
  _HomeDetailsState createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  // Removed the unused field since its not being used 
  //  late bool _isDark = false;
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


// commenting out since its not being used
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
            CommonFunctions().isFieldsPresentForCategory(AtCategory.DETAILS,
                    isPreview: widget.isPreview)
                ? Text(
                    'Basic Details',
                    style:
                        TextStyles.boldText(_themeData!.primaryColor, size: 18),
                  )
                : const SizedBox(),
            SizedBox(height: 15.toHeight),
            Column(
              children: CommonFunctions().getCustomCardForFields(
                  _themeData!, AtCategory.DETAILS,
                  isPreview: widget.isPreview),
            ),
            SizedBox(
                height: CommonFunctions().isFieldsPresentForCategory(
                        AtCategory.DETAILS,
                        isPreview: widget.isPreview)
                    ? 40.toHeight
                    : 0),
            CommonFunctions().isFieldsPresentForCategory(
                    AtCategory.ADDITIONAL_DETAILS,
                    isPreview: widget.isPreview)
                ? Text('Additional Details',
                    style:
                        TextStyles.boldText(_themeData!.primaryColor, size: 18))
                : const SizedBox(),
            SizedBox(height: 15.toHeight),
            Column(
              children: CommonFunctions().getCustomCardForFields(
                  _themeData!, AtCategory.ADDITIONAL_DETAILS,
                  isPreview: widget.isPreview),
            ),
            SizedBox(
                height: CommonFunctions().isFieldsPresentForCategory(
                        AtCategory.ADDITIONAL_DETAILS,
                        isPreview: widget.isPreview)
                    ? 40.toHeight
                    : 0),
            CommonFunctions().isFieldsPresentForCategory(AtCategory.LOCATION,
                    isPreview: widget.isPreview)
                ? Text('Location',
                    style:
                        TextStyles.boldText(_themeData!.primaryColor, size: 18))
                : const SizedBox(),
            SizedBox(height: 15.toHeight),
            Column(
              children: CommonFunctions().getAllLocationCards(_themeData!,
                  isPreview: widget.isPreview),
            ),
          ],
        ),
      );
    }
  }
}
