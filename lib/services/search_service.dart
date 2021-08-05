import 'dart:convert';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'at_key_get_service.dart';

class SearchService {
  SearchService._();
  static SearchService _instance = SearchService._();
  factory SearchService() => _instance;
  final String url = 'https://wavi.ng/api/?atp=minorgettingplayed7';

  late User user;
  ThemeColor? themeColor;
  ThemeData? currentAtsignThemeData;
  Color? highlightColor;

  List<String> keysToIgnore = [
    // '',
    'at_followers_of_self.wavi',
    'at_following_by_self.wavi',
    'privateaccount.wavi'
  ];
  String themeKey = 'theme.wavi';
  String themeColorKey = 'theme_color.wavi';

  updateThemeData(_data) {
    if ((_data ?? '').toLowerCase() == 'dark') {
      currentAtsignThemeData =
          Themes.darkTheme(highlightColor ?? ColorConstants.purple);
      themeColor = ThemeColor.Dark;
    } else {
      currentAtsignThemeData =
          Themes.lightTheme(highlightColor ?? ColorConstants.purple);
      themeColor = ThemeColor.Light;
    }
  }

  updateHighlightColor(String _color) {
    highlightColor = (_color != null)
        ? ThemeProvider().convertToHighlightColor(_color)
        : ColorConstants.purple;
    if (themeColor != null) {
      currentAtsignThemeData = themeColor == ThemeColor.Dark
          ? Themes.darkTheme(highlightColor!)
          : Themes.lightTheme(highlightColor!);
    }
  }

  Future<User> getAtsignDetails(String atsign) async {
    user = User(allPrivate: false, atsign: atsign);
    var _response = await http.get(Uri.parse(url));
    var _jsonData = jsonDecode(_response.body);
    print('_jsonData ${_jsonData}');

    _jsonData.forEach((_data) {
      var _keyValuePair = _data;
      for (var field in _keyValuePair.entries) {
        if (field.key.contains(themeKey)) {
          updateThemeData(_keyValuePair[field.key]);
          continue;
        }

        if (field.key.contains(themeColorKey)) {
          updateHighlightColor(_keyValuePair[field.key]);
          continue;
        }

        if (!keysToIgnore.contains(field.key)) {
          if (field.key.contains('custom_')) {
            setCustomField(_keyValuePair[field.key], false);
          } else {
            setDefinedFields(field.key, _keyValuePair[field.key]);
          }
        }
      }
    });

    return user;
  }

  void setCustomField(String response, isPrivate) {
    var json = jsonDecode(response);
    if (json != 'null' && json != null) {
      String category = json[CustomFieldConstants.category];
      var type = AtKeyGetService().getType(json[CustomFieldConstants.type]);
      var value =
          AtKeyGetService().getCustomContentValue(type: type, json: json);
      String label = json[CustomFieldConstants.label];
      String? valueDescription = json[CustomFieldConstants.valueDescription];
      BasicData basicData = BasicData(
          accountName: label,
          value: value,
          isPrivate: isPrivate,
          type: type,
          valueDescription: valueDescription ?? '');
      // _container.createCustomField(basicData, category.toUpperCase());
      // print('setCustomField $label $value');
      if (user.customFields[category.toUpperCase()] == null) {
        user.customFields[category.toUpperCase()] = [];
      }
      user.customFields[category.toUpperCase()]!.add(basicData);

      if (!basicData.isPrivate) {
        user.allPrivate = false;
      }
    }
  }

  dynamic setDefinedFields(property, value) {
    property = property.toString().replaceAll('.wavi', '');
    // print('property $property');
    var field = valueOf(property);
    if (field is FieldsEnum) {
      var data =
          formData(property, value, private: false, valueDescription: '');
      switch (field) {
        case FieldsEnum.ATSIGN:
          user.atsign = value;
          break;
        case FieldsEnum.IMAGE:
          user.image = data;
          break;
        case FieldsEnum.FIRSTNAME:
          user.firstname = data;
          break;
        case FieldsEnum.LASTNAME:
          user.lastname = data;
          break;
        case FieldsEnum.PHONE:
          user.phone = data;
          break;
        case FieldsEnum.EMAIL:
          user.email = data;
          break;
        case FieldsEnum.ABOUT:
          user.about = data;
          break;
        case FieldsEnum.PRONOUN:
          user.pronoun = data;
          break;
        case FieldsEnum.LOCATION:
          user.location = data;
          break;
        case FieldsEnum.LOCATIONNICKNAME:
          user.locationNickName = data;
          break;
        case FieldsEnum.TWITTER:
          user.twitter = data;
          break;
        case FieldsEnum.FACEBOOK:
          user.facebook = data;
          break;
        case FieldsEnum.LINKEDIN:
          user.linkedin = data;
          break;
        case FieldsEnum.INSTAGRAM:
          user.instagram = data;
          break;
        case FieldsEnum.YOUTUBE:
          user.youtube = data;
          break;
        case FieldsEnum.TUMBLR:
          user.tumbler = data;
          break;
        case FieldsEnum.MEDIUM:
          user.medium = data;
          break;
        case FieldsEnum.PS4:
          user.ps4 = data;
          break;
        case FieldsEnum.XBOX:
          user.xbox = data;
          break;
        case FieldsEnum.STEAM:
          user.steam = data;
          break;
        case FieldsEnum.DISCORD:
          user.discord = data;
          break;
        default:
          break;
      }
    }
  }
}