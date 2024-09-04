import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

class DesktopAppearanceModel extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _color = Colors.black;
  final List<Color> _colorItems = [];

  bool get isDarkMode => _isDarkMode;

  Color get color => _color;

  List<Color> get colorItems => _colorItems;

  DesktopAppearanceModel({
    bool isDarkMode = false,
    Color? color,
  }) {
    _isDarkMode = isDarkMode;
    _color = color ?? ColorConstants.green;
  }

  void changeDarkMode(bool isDarkMode) {
    if (_isDarkMode == isDarkMode) {
      return;
    }
    _isDarkMode = isDarkMode;
    if (_isDarkMode) {
      final index = paletteColors.indexOf(_color);
      if (index != -1) {
        _color = darkPaletteColors[index];
      } else {
        _color = darkPaletteColors.first;
      }
    } else {
      final index = darkPaletteColors.indexOf(_color);
      if (index != -1) {
        _color = paletteColors[index];
      } else {
        _color = paletteColors.first;
      }
    }
    notifyListeners();
  }

  void changeHighlightColor(Color color) {
    _color = color;
    notifyListeners();
  }

  final List<Color> paletteColors = [
    ColorConstants.purple,
    ColorConstants.green,
    ColorConstants.blue,
    ColorConstants.solidPink,
    ColorConstants.fadedBrown,
    ColorConstants.solidRed,
    ColorConstants.solidPeach,
    ColorConstants.solidYellow,
  ];

  final List<Color> darkPaletteColors = [
    ColorConstants.darkThemePurple,
    ColorConstants.darkThemeGreen,
    ColorConstants.darkThemeBlue,
    ColorConstants.darkThemeSolidPink,
    ColorConstants.darkThemeFadedBrown,
    ColorConstants.darkThemeSolidRed,
    ColorConstants.darkThemeSolidPeach,
    ColorConstants.darkThemeSolidYellow,
  ];
}
