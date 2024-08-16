import 'dart:convert';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/twitter_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'at_key_get_service.dart';

class SearchService {
  SearchService._();
  static final SearchService _instance = SearchService._();
  factory SearchService() => _instance;

  final Map<String, SearchInstance> _searchData = {};

  Future<SearchInstance?> getAtsignDetails(String atsign,
      {bool serverLookup = false}) async {
    if ((!serverLookup) && (_searchData[atsign] != null)) {
      return _searchData[atsign]!;
    }

    SearchInstance atsignDetails = SearchInstance();
    var user = await atsignDetails.getAtsignDetails(atsign);
    if (user == null) {
      return null;
    }
    _searchData[atsign] = atsignDetails;
    return atsignDetails;
  }

  SearchInstance? getAlreadySearchedAtsignDetails(String atsign) {
    return _searchData[atsign];
  }
}

class SearchInstance {
  final String url = 'https://wavi.ng/api/?atp=';

  User user = User(allPrivate: false, atsign: '');
  ThemeColor? themeColor;
  ThemeData? currentAtsignThemeData;
  Color? highlightColor;

  int? followers_count;
  int? following_count;
  List<String>? followers;
  List<String>? following;
  late bool isPrivateAccount = false;
  Map<String, List<String>> fieldOrders = {};

  List<String> keysToIgnore = [
    // '',
    // 'at_followers_of_self.wavi',
    // 'at_following_by_self.wavi',
    'privateaccount.wavi'
  ];
  String privateAccountKey = 'privateaccount.wavi';
  String themeKey = 'theme.wavi';
  String themeColorKey = 'theme_color.wavi';
  String followers_key = 'at_followers_of_self.wavi';
  String following_key = 'at_following_by_self.wavi';
  String new_followers_key = 'followers_of_self.at_follows.wavi';
  String new_following_key = 'following_by_self.at_follows.wavi';
  String field_order_key = MixedConstants.fieldOrderKey;

  _updateThemeData(data) {
    if ((data ?? '').toLowerCase() == 'dark') {
      currentAtsignThemeData = Themes.darkTheme(
          highlightColor: highlightColor ?? ColorConstants.green);
      themeColor = ThemeColor.Dark;
    } else {
      currentAtsignThemeData = Themes.lightTheme(
          highlightColor: highlightColor ?? ColorConstants.green);
      themeColor = ThemeColor.Light;
    }
  }

  _updateHighlightColor(String color) {
<<<<<<< HEAD
    // ignore: unnecessary_null_comparison
=======
>>>>>>> be86b97 (fixed issues from dart analyze)
    highlightColor = (color != null)
        ? ThemeProvider().convertToHighlightColor(color)
        : ColorConstants.green;
    if (themeColor != null) {
      currentAtsignThemeData = themeColor == ThemeColor.Dark
          ? Themes.darkTheme(highlightColor: highlightColor!)
          : Themes.lightTheme(highlightColor: highlightColor!);
    }
  }

  Future<User?> getAtsignDetails(String atsign) async {
    try {
      followers = [];
      following = [];
      fieldOrders = {};
      currentAtsignThemeData = Themes.lightTheme(
          highlightColor: highlightColor ?? ColorConstants.green);
      themeColor = null;
      highlightColor = null;

      isPrivateAccount = false;
      user = User(allPrivate: false, atsign: atsign);
      var response = await http.get(Uri.parse('$url$atsign'));
      print('_jsonData ${response.body}');
      var jsonData = jsonDecode(response.body);

      jsonData.forEach((data) {
        var keyValuePair = data;
        for (var field in keyValuePair.entries) {
          if (field.key.contains(field_order_key)) {
            Map<String, dynamic> fielsOrder =
                jsonDecode(keyValuePair[field.key]);
            for (var field in fielsOrder.entries) {
              fieldOrders[field.key] =
                  _removeDuplicatesInFieldOrder(fielsOrder[field.key]);
            }
            continue;
          }

          if (field.key.contains(privateAccountKey)) {
            isPrivateAccount = keyValuePair[field.key] == 'true';
            continue;
          }

          if ((field.key.contains(followers_key)) ||
              (field.key.contains(new_followers_key))) {
            followers = keyValuePair[field.key].split(',');
            followers_count = followers?.length ?? 0;
            continue;
          }

          if ((field.key.contains(following_key)) ||
              (field.key.contains(new_following_key))) {
            following = keyValuePair[field.key].split(',');
            following_count = following?.length ?? 0;
            continue;
          }

          if (field.key.contains(themeKey)) {
            _updateThemeData(keyValuePair[field.key]);
            continue;
          }

          if (field.key.contains(themeColorKey)) {
            _updateHighlightColor(keyValuePair[field.key]);
            continue;
          }

          if (!keysToIgnore.contains(field.key)) {
            if (field.key.contains('custom_')) {
              _setCustomField(keyValuePair[field.key], false);
            } else {
              _setDefinedFields(field.key, keyValuePair[field.key]);
            }
          }
        }
      });

      if (user.twitter.value != null) {
        await TwitetrService().getTweets(searchedUsername: user.twitter.value);
      }

      return user;
    } catch (e) {
      print('Error in $e');
    }
    return null;
  }

  /// function to remove duplicate entries in 'field_order_of_self.wavi'
  List<String> _removeDuplicatesInFieldOrder(String data) {
    List<String> result = [];
    var temp = jsonDecode(data);
    for (var _str in (temp as List)) {
      if (!result.contains(_str)) {
        result.add(_str);
      }
    }
    return result;
  }

  void _setCustomField(String response, isPrivate) {
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

  dynamic _setDefinedFields(property, value) {
    property = property.toString().replaceAll('.wavi', '');
    // print('property $property');
    var field = valueOf(property);
    if (field is FieldsEnum) {
      if (field == FieldsEnum.IMAGE) {
        try {
          value = base64Decode(value);
        } catch (e) {
          value = null;
          print('Error in image decoding setDefinedFields $e');
        }
      }
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
