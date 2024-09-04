import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/theme_service.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'base_model.dart';

class ThemeProvider extends BaseModel {
  // ignore: non_constant_identifier_names
  String SET_THEME = 'set_theme';

  ThemeColor themeColor = ThemeColor.Light;
  ThemeData darktheme = Themes.darkTheme();
  ThemeData lighttheme = Themes.lightTheme();
  ThemeData? currentAtsignThemeData;
  Color? highlightColor;

  ThemeProvider();

  resetThemeData() {
    reset(SET_THEME);
    currentAtsignThemeData = null;
    highlightColor = null;
  }

  setHighlightColor(Color color) {
    darktheme = Themes.darkTheme(highlightColor: color);
    lighttheme = Themes.lightTheme(highlightColor: color);
    highlightColor = color;
    currentAtsignThemeData =
        (themeColor == ThemeColor.Light) ? lighttheme : darktheme;
  }

  Future<ThemeData> getTheme() async {
    await checkThemeFromSecondary(notifyListener: false);
    return currentAtsignThemeData!;
  }

  // ignore: always_declare_return_types
  checkThemeFromSecondary({bool notifyListener = true}) async {
    if (currentAtsignThemeData == null) {
      var themePreference = await ThemeService().getThemePreference(
          BackendService().atClientInstance.getCurrentAtSign()!);

      if ((themePreference ?? '').toLowerCase() == 'dark') {
        currentAtsignThemeData = darktheme;
        themeColor = ThemeColor.Dark;
      } else {
        currentAtsignThemeData = lighttheme;
        themeColor = ThemeColor.Light;
      }
    }

    if (highlightColor == null) {
      var highlightColorPreference = await ThemeService().getThemePreference(
          BackendService().atClientInstance.getCurrentAtSign()!,
          returnHighlightColorPreference: true);

      highlightColor = (highlightColorPreference != null)
          ? convertToHighlightColor(highlightColorPreference)
          : ColorConstants.green;

      // theme.highlightColor = highlightColor!;
      setHighlightColor(highlightColor!);
    }

    if (notifyListener) {
      notifyListeners();
    }
  }

  // ignore: always_declare_return_types
  setTheme({ThemeColor? themeColor, Color? highlightColor}) async {
    setStatus(SET_THEME, Status.Loading);

    if (highlightColor != null) {
      // added color check for light/dark theme
      highlightColor = this.themeColor == ThemeColor.Dark
          ? convertHighlightColorForDarktheme(highlightColor)
          : convertHighlightColorForLighttheme(highlightColor);

      var res =
          await ThemeService().updateProfile(highlightColor: highlightColor);
      if (res) {
        setHighlightColor(highlightColor);
        setStatus(SET_THEME, Status.Done);
      } else {
        setStatus(SET_THEME, Status.Error);
      }
    }

    if (themeColor != null) {
      var res =
          await ThemeService().updateProfile(themePreference: themeColor);
      if (res) {
        if (themeColor == ThemeColor.Dark) {
          currentAtsignThemeData = darktheme;
          this.themeColor = ThemeColor.Dark;
        } else {
          currentAtsignThemeData = lighttheme;
          this.themeColor = ThemeColor.Light;
        }
        setStatus(SET_THEME, Status.Done);
      } else {
        setStatus(SET_THEME, Status.Error);
      }
    }
  }

  Color convertHighlightColorForDarktheme(Color color) {
    String colorStr = color.toString().toLowerCase().substring(10, 16);

    switch (colorStr.toUpperCase()) {
      case '58419C':
        return ColorConstants.darkThemePurple;
      case '6EBCB7':
        return ColorConstants.darkThemeGreen;
      case '3FC0F3':
        return ColorConstants.darkThemeBlue;
      case 'FF4081':
        return ColorConstants.darkThemeSolidPink;
      case 'A77D60':
        return ColorConstants.darkThemeFadedBrown;
      case 'EF5743':
        return ColorConstants.darkThemeSolidRed;
      case 'C47E61':
        return ColorConstants.darkThemeSolidPeach;
      case 'CC981A':
        return ColorConstants.darkThemeSolidYellow;
      case 'BB86FC':
        return ColorConstants.darkThemePurple;
      case 'FEB8D5':
        return ColorConstants.darkThemeSolidPink;
      case 'F2A384':
        return ColorConstants.darkThemeSolidPeach;
      case 'FFBE21':
        return ColorConstants.darkThemeSolidYellow;
      default:
        return ColorConstants.darkThemeGreen;
    }
  }

  Color convertHighlightColorForLighttheme(Color color) {
    String colorStr = color.toString().toLowerCase().substring(10, 16);

    switch (colorStr.toUpperCase()) {
      case '58419C':
        return ColorConstants.purple;
      case '6EBCB7':
        return ColorConstants.green;
      case '3FC0F3':
        return ColorConstants.blue;
      case 'FF4081':
        return ColorConstants.solidPink;
      case 'A77D60':
        return ColorConstants.fadedBrown;
      case 'EF5743':
        return ColorConstants.solidRed;
      case 'C47E61':
        return ColorConstants.solidPeach;
      case 'CC981A':
        return ColorConstants.solidYellow;
      case 'BB86FC':
        return ColorConstants.purple;
      case 'FEB8D5':
        return ColorConstants.solidPink;
      case 'F2A384':
        return ColorConstants.solidPeach;
      case 'FFBE21':
        return ColorConstants.solidYellow;
      default:
        return ColorConstants.darkThemeGreen;
    }
  }

  convertToHighlightColor(String color) {
    switch (color.toUpperCase()) {
      case '58419C':
        return ColorConstants.purple;
      case '6EBCB7':
        return ColorConstants.green;
      case '3FC0F3':
        return ColorConstants.blue;
      case 'FF4081':
        return ColorConstants.solidPink;
      case 'A77D60':
        return ColorConstants.fadedBrown;
      case 'EF5743':
        return ColorConstants.solidRed;
      case 'C47E61':
        return ColorConstants.solidPeach;
      case 'CC981A':
        return ColorConstants.solidYellow;
      case 'FEB8D5':
        return ColorConstants.darkThemeSolidPink;
      case 'F2A384':
        return ColorConstants.darkThemeSolidPeach;
      case 'FFBE21':
        return ColorConstants.darkThemeSolidYellow;
      case 'BB86FC':
        return ColorConstants.darkThemePurple;

      default:
        return ColorConstants.green;
    }
  }
}

enum ThemeColor { Light, Dark }
