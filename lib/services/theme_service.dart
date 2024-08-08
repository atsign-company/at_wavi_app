import 'package:at_commons/at_commons.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/utils/at_key_constants.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';

class ThemeService {
  ThemeService._();
  static final ThemeService _instance = ThemeService._();
  factory ThemeService() => _instance;

  /// Updates user theme preferences.
  ///
  /// Throws [assertionError] if [themePreference] and [highlightColor] both are null.
  Future<bool> updateProfile(
      {ThemeColor? themePreference, Color? highlightColor}) async {
    try {
      assert(themePreference != null || highlightColor != null);

      late String value;

      var metaData = Metadata()
        ..isPublic = true
        ..ccd = true

        /// TODO: true or false
        ..namespaceAware = true
        ..isEncrypted = false;

      var atKey = AtKey()..metadata = metaData;

      if (themePreference != null) {
        atKey.key = AtKeyConstants.themePreference;
        if (themePreference == ThemeColor.Dark) {
          value = 'dark'.toString();
        } else {
          value = 'light'.toString();
        }
      } else if (highlightColor != null) {
        atKey.key = AtKeyConstants.highlightColorPreference;
        value = highlightColor.toString().toLowerCase().substring(10, 16);
      }

      print('_value $value');

      var result = await BackendService().atClientInstance.put(atKey, value);
      print('_result $result');
      return result;
    } catch (e) {
      print('updateProfile throws exception $e');
      return false;
    }
  }

  Future<String?> getThemePreference(String atsign,
      {bool returnHighlightColorPreference = false}) async {
    try {
      if (!atsign.contains('@')) {
        atsign = '@$atsign';
      }

      var metadata = Metadata();
      metadata.isPublic = true;
      metadata.namespaceAware = true;

      var key = AtKey();
      key.sharedBy = atsign;
      key.metadata = metadata;

      key.key = returnHighlightColorPreference
          ? AtKeyConstants.highlightColorPreference
          : AtKeyConstants.themePreference;

      print('key.key ${key.key}');

      var result =
          await BackendService().atClientInstance.get(key).catchError((e) {
        print('error in get ${e.errorCode} ${e.errorMessage}');
      });

      // print('getThemePreference result $result');

      return result.value;
    } catch (e) {
      print('getThemePreference throws exception $e');
      return '';
    }
  }
}
