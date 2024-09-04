import 'dart:convert';

import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';

class MockData {
  MockData._();

  static User get getMockUser {
    return userFromJson(jsonDecode(mockUser));
  }

  static Map<String, List<String>> get getMockFieldOrders {
    Map<String, List<String>> result = <String, List<String>>{};
    (jsonDecode(mockFieldOrders) as Map<String, dynamic>).forEach((key, value) {
      result[key] = (value as List<dynamic>).map((e) => e.toString()).toList();
    });
    return result;
  }

  static Map<String, List<String>> get getMockPreviewOrders {
    Map<String, List<String>> result = <String, List<String>>{};
    (jsonDecode(mockPreviewOrders) as Map<String, dynamic>)
        .forEach((key, value) {
      result[key] = (value as List<dynamic>).map((e) => e.toString()).toList();
    });
    return result;
  }

  static userFromJson(Map<dynamic, dynamic> userMap) {
    try {
      Map<String, List<BasicData>> customFields = {};

      for (AtCategory atCategory in AtCategory.values) {
        List<BasicData> basicDataList = [];
        if (userMap['customFields'][atCategory.name] != null) {
          userMap['customFields'][atCategory.name].forEach((data) {
            var basicData = BasicData.fromJson(data as Map<String, dynamic>);
            if (basicData.accountName != null && basicData.value != null) {
              basicDataList.add(basicData);
            }
          });
        }
        customFields[atCategory.name] = basicDataList;
      }

      return User(
        allPrivate: userMap['allPrivate'],
        atsign: userMap[FieldsEnum.ATSIGN.name],
        image: BasicData.fromJson(
            userMap[FieldsEnum.IMAGE.name] as Map<String, dynamic>),
        firstname: BasicData.fromJson(
            userMap[FieldsEnum.FIRSTNAME.name] as Map<String, dynamic>),
        lastname: BasicData.fromJson(
            userMap[FieldsEnum.LASTNAME.name] as Map<String, dynamic>),
        location: BasicData.fromJson(
            userMap[FieldsEnum.LOCATION.name] as Map<String, dynamic>),
        locationNickName: BasicData.fromJson(
            userMap[FieldsEnum.LOCATIONNICKNAME.name] as Map<String, dynamic>),
        pronoun: BasicData.fromJson(
            userMap[FieldsEnum.PRONOUN.name] as Map<String, dynamic>),
        phone: BasicData.fromJson(
            userMap[FieldsEnum.PHONE.name] as Map<String, dynamic>),
        email: BasicData.fromJson(
            userMap[FieldsEnum.EMAIL.name] as Map<String, dynamic>),
        about: BasicData.fromJson(
            userMap[FieldsEnum.ABOUT.name] as Map<String, dynamic>),
        twitter: BasicData.fromJson(
            userMap[FieldsEnum.TWITTER.name] as Map<String, dynamic>),
        facebook: BasicData.fromJson(
            userMap[FieldsEnum.FACEBOOK.name] as Map<String, dynamic>),
        linkedin: BasicData.fromJson(
            userMap[FieldsEnum.LINKEDIN.name] as Map<String, dynamic>),
        instagram: BasicData.fromJson(
            userMap[FieldsEnum.INSTAGRAM.name] as Map<String, dynamic>),
        youtube: BasicData.fromJson(
            userMap[FieldsEnum.YOUTUBE.name] as Map<String, dynamic>),
        tumbler: BasicData.fromJson(
            userMap[FieldsEnum.TUMBLR.name] as Map<String, dynamic>),
        medium: BasicData.fromJson(
            userMap[FieldsEnum.MEDIUM.name] as Map<String, dynamic>),
        ps4: BasicData.fromJson(
            userMap[FieldsEnum.PS4.name] as Map<String, dynamic>),
        xbox: BasicData.fromJson(
            userMap[FieldsEnum.XBOX.name] as Map<String, dynamic>),
        steam: BasicData.fromJson(
            userMap[FieldsEnum.STEAM.name] as Map<String, dynamic>),
        discord: BasicData.fromJson(
            userMap[FieldsEnum.DISCORD.name] as Map<String, dynamic>),
        customFields: customFields,
      );
    } catch (e, s) {
      print('error : in User from json: $e');
      print('error : in User from json: $s');
      return User();
    }
  }
}

const mockFieldOrders = """
{
  "DETAILS": [
    "firstname",
    "lastname",
    "phone",
    "email",
    "Music"
  ],
  "ADDITIONAL_DETAILS": [
    "pronoun",
    "about"
  ],
  "LOCATION": [
    "location",
    "office",
    "locationnickname"
  ],
  "SOCIAL": [
    "twitter",
    "facebook",
    "linkedin",
    "instagram",
    "youtube",
    "tumblr",
    "medium"
  ],
  "GAMER": [
    "ps4",
    "xbox",
    "steam",
    "discord"
  ]
}
""";

const mockPreviewOrders = """
{
  "DETAILS": [
    "firstname",
    "lastname",
    "phone",
    "email",
    "Music"
  ],
  "ADDITIONAL_DETAILS": [
    "pronoun",
    "about"
  ],
  "LOCATION": [
    "location",
    "office",
    "locationnickname"
  ],
  "SOCIAL": [
    "twitter",
    "facebook",
    "linkedin",
    "instagram",
    "youtube",
    "tumblr",
    "medium"
  ],
  "GAMER": [
    "ps4",
    "xbox",
    "steam",
    "discord"
  ]
}
""";

const mockUser = """
{
  "allPrivate": false,
  "atsign": "@13nearbyblue",
  "image": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "firstname": {
    "value": "",
    "isPrivate": false,
    "accountName": "firstname",
    "valueDescription": null,
    "type": "TextInputType(name: TextInputType.text, signed: null, decimal: null)",
    "path": null
  },
  "lastname": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "phone": {
    "value": null,
    "isPrivate": false,
    "accountName": "phone",
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "email": {
    "value": null,
    "isPrivate": false,
    "accountName": "email",
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "about": {
    "value": null,
    "isPrivate": false,
    "accountName": "about",
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "location": {
    "value": "{\\"location\\":\\"null\\",\\"radius\\":\\"null\\",\\"diameter\\":\\"100.0\\",\\"zoom\\":\\"16.0\\",\\"latitude\\":\\"37.33233141\\",\\"longitude\\":\\"-122.0312186\\"}",
    "isPrivate": false,
    "accountName": "Home",
    "valueDescription": null,
    "type": "TextInputType(name: TextInputType.text, signed: null, decimal: null)",
    "path": null
  },
  "locationnickname": {
    "value": "{\\"location\\":\\"null\\",\\"radius\\":\\"null\\",\\"diameter\\":\\"100.0\\",\\"zoom\\":\\"16.0\\",\\"latitude\\":\\"37.33233141\\",\\"longitude\\":\\"-122.0312186\\"}",
    "isPrivate": false,
    "accountName": "Coffee",
    "valueDescription": null,
    "type": "TextInputType(name: TextInputType.text, signed: null, decimal: null)",
    "path": null
  },
  "pronoun": {
    "value": null,
    "isPrivate": false,
    "accountName": "pronoun",
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "twitter": {
    "value": "twitter.com/duc",
    "isPrivate": false,
    "accountName": "twitter",
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "facebook": {
    "value": "facebook.com/duc",
    "isPrivate": false,
    "accountName": "facebook",
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "linkedin": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "instagram": {
    "value": "instagram.com/duc",
    "isPrivate": false,
    "accountName": "instagram",
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "youtube": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "tumblr": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "medium": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "ps4": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "xbox": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "steam": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "discord": {
    "value": null,
    "isPrivate": false,
    "accountName": null,
    "valueDescription": null,
    "type": null,
    "path": null
  },
  "customFields": {
    "LOCATION": [
      {
        "value": "{\\"location\\":\\"null\\",\\"radius\\":\\"null\\",\\"diameter\\":\\"100.0\\",\\"zoom\\":\\"16.0\\",\\"latitude\\":\\"37.33233141\\",\\"longitude\\":\\"-122.0312186\\"}",
        "isPrivate": false,
        "accountName": "Office",
        "valueDescription": "",
        "type": "Text",
        "path": null
      }
    ],
    "DETAILS": [
      {
        "value": "https://www.youtube.com/watch?v=oTA3zaARDwo",
        "isPrivate": false,
        "accountName": "Music",
        "valueDescription": "",
        "type": "Youtube",
        "path": null
      }
    ]
  }
}
""";
