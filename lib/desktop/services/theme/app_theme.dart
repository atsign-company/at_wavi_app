import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'inherited_app_theme.dart';

class AppTheme {
  /// The overall brightness of this color scheme.
  final Brightness brightness;

  /// The color displayed most frequently across your app’s screens and components.
  final Color primaryColor;

  Color get primaryLighterColor => brightness == Brightness.light
      ? primaryColor.withOpacity(0.05)
      : const Color(0xFF171717);

  /// An accent color that, when used sparingly, calls attention to parts
  /// of your app.
  final Color secondaryColor;

  Color get accentColor => secondaryColor;

  /// A color that typically appears behind scrollable content.
  final Color backgroundColor;
  final Color secondaryBackgroundColor;

  final Color primaryTextColor;
  final Color secondaryTextColor;

  final Color separatorColor;
  final Color borderColor;
  final Color shadowColor;

  bool get isDark => brightness == Brightness.dark;

  /// Material design text theme.
  /// ```
  /// NAME         SIZE  WEIGHT  SPACING
  /// headline1    96.0  light   -1.5
  /// headline2    60.0  light   -0.5
  /// headline3    48.0  regular  0.0
  /// headline4    34.0  regular  0.25
  /// headline5    24.0  regular  0.0
  /// headline6    20.0  medium   0.15
  /// subtitle1    16.0  regular  0.15
  /// subtitle2    14.0  medium   0.1
  /// body1        16.0  regular  0.5   (bodyText1)
  /// body2        14.0  regular  0.25  (bodyText2)
  /// button       14.0  medium   1.25
  /// caption      12.0  regular  0.4
  /// overline     10.0  regular  1.5
  late TextTheme textTheme;

  /// Create a ColorScheme instance.
  AppTheme({
    required this.brightness,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.secondaryBackgroundColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.separatorColor,
    required this.borderColor,
    required this.shadowColor,
  }) {
    textTheme = TextTheme(
      displayLarge: TextStyle(fontSize: 96.0, color: primaryTextColor),
      displayMedium: TextStyle(fontSize: 60.0, color: primaryTextColor),
      displaySmall: TextStyle(fontSize: 48.0, color: primaryTextColor),
      headlineMedium: TextStyle(fontSize: 34.0, color: primaryTextColor),
      headlineSmall: TextStyle(fontSize: 24.0, color: primaryTextColor),
      titleLarge: TextStyle(
          fontSize: 20.0,
          color: primaryTextColor,
          fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontSize: 16.0, color: primaryTextColor),
      titleSmall: TextStyle(
          fontSize: 14.0,
          color: primaryTextColor,
          fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16.0, color: primaryTextColor),
      bodyMedium: TextStyle(fontSize: 14.0, color: primaryTextColor),
      labelLarge: TextStyle(
          fontSize: 14.0,
          color: primaryTextColor,
          fontWeight: FontWeight.w500),
      bodySmall: TextStyle(fontSize: 12.0, color: primaryTextColor),
      labelSmall: TextStyle(fontSize: 14.0, color: primaryTextColor),
    );
  }

  factory AppTheme.from({
    Brightness brightness = Brightness.light,
    Color primaryColor = ColorConstants.desktopPrimaryDefault,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? secondaryBackgroundColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    Color? separatorColor,
    Color? borderColor,
    Color? shadowColor,
  }) {
    return AppTheme(
      brightness: brightness,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor ?? ColorConstants.desktopSecondary,
      backgroundColor: backgroundColor ??
          (brightness == Brightness.dark
              ? ColorConstants.desktopBackgroundDark
              : ColorConstants.desktopBackgroundLight),
      secondaryBackgroundColor: secondaryBackgroundColor ??
          (brightness == Brightness.dark
              ? ColorConstants.desktopSecondaryBackgroundDark
              : ColorConstants.desktopSecondaryBackgroundLight),
      primaryTextColor: primaryTextColor ??
          (brightness == Brightness.dark
              ? ColorConstants.desktopPrimaryTextDark
              : ColorConstants.desktopPrimaryTextLight),
      secondaryTextColor: secondaryTextColor ??
          (brightness == Brightness.dark
              ? ColorConstants.desktopSecondaryTextDark
              : ColorConstants.desktopSecondaryTextLight),
      separatorColor: separatorColor ??
          (brightness == Brightness.dark
              ? ColorConstants.desktopSeparatorDark
              : ColorConstants.desktopSeparatorLight),
      borderColor: borderColor ??
          (brightness == Brightness.dark
              ? ColorConstants.desktopBorderDark
              : ColorConstants.desktopBorderLight),
      shadowColor: shadowColor ??
          (brightness == Brightness.dark
              ? ColorConstants.desktopShadowDark
              : ColorConstants.desktopShadowLight),
    );
  }

  ThemeData toThemeData() {
    return ThemeData(
      // brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Inter',
      textTheme: textTheme,
      colorScheme: ThemeData.dark().colorScheme.copyWith(
            brightness: brightness,
            primary: primaryColor,
            surface: backgroundColor,
            secondary: accentColor,
          ),
    );
  }

  static AppTheme of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedAppTheme>()!
        .theme;
  }
}
