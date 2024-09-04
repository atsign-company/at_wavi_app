import 'dart:convert';
import 'dart:typed_data';

import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class User {
  bool allPrivate;
  String atsign;
  BasicData image;
  BasicData firstname;
  BasicData lastname;
  BasicData phone;
  BasicData email;
  BasicData about;
  BasicData location;
  BasicData locationNickName;
  BasicData pronoun;
  BasicData twitter;
  BasicData facebook;
  BasicData linkedin;
  BasicData instagram;
  BasicData youtube;
  BasicData tumbler;
  BasicData tiktok;
  BasicData snapchat;
  BasicData pinterest;
  BasicData github;
  BasicData medium;
  BasicData ps4;
  BasicData xbox;
  BasicData steam;
  BasicData discord;
  BasicData twitch;
  BasicData htmlToastView;
  BasicData switchField;
  BasicData epic;
  Map<String, List<BasicData>> customFields;

  User({
    allPrivate,
    atsign,
    image,
    firstname,
    lastname,
    location,
    locationNickName,
    pronoun,
    phone,
    email,
    about,
    twitter,
    facebook,
    linkedin,
    instagram,
    youtube,
    tumbler,
    medium,
    tiktok,
    snapchat,
    pinterest,
    github,
    ps4,
    xbox,
    steam,
    discord,
    twitch,
    htmlToastView,
    switchField,
    epic,
    customFields,
  })  : allPrivate = allPrivate,
        atsign = atsign,
        image = image ?? BasicData(),
        firstname = firstname ?? BasicData(),
        lastname = lastname ?? BasicData(),
        location = location ?? BasicData(),
        locationNickName = locationNickName ?? BasicData(),
        pronoun = pronoun ?? BasicData(),
        phone = phone ?? BasicData(),
        email = email ?? BasicData(),
        about = about ?? BasicData(),
        twitter = twitter ?? BasicData(),
        facebook = facebook ?? BasicData(),
        linkedin = linkedin ?? BasicData(),
        instagram = instagram ?? BasicData(),
        youtube = youtube ?? BasicData(),
        tumbler = tumbler ?? BasicData(),
        medium = medium ?? BasicData(),
        tiktok = tiktok ?? BasicData(),
        github = github ?? BasicData(),
        snapchat = snapchat ?? BasicData(),
        pinterest = pinterest ?? BasicData(),
        ps4 = ps4 ?? BasicData(),
        xbox = xbox ?? BasicData(),
        steam = steam ?? BasicData(),
        discord = discord ?? BasicData(),
        twitch = twitch ?? BasicData(),
        htmlToastView = htmlToastView ?? BasicData(),
        switchField = switchField ?? BasicData(),
        epic = epic ?? BasicData(),
        customFields = customFields ?? {};

  static Map<dynamic, dynamic> toJson(User? user) {
    return {
      'allPrivate': user?.allPrivate,
      FieldsEnum.ATSIGN.name: user?.atsign,
      FieldsEnum.IMAGE.name: user?.image,
      FieldsEnum.FIRSTNAME.name: user?.firstname,
      FieldsEnum.LASTNAME.name: user?.lastname,
      FieldsEnum.PHONE.name: user?.phone,
      FieldsEnum.EMAIL.name: user?.email,
      FieldsEnum.ABOUT.name: user?.about,
      FieldsEnum.LOCATION.name: user?.location,
      FieldsEnum.LOCATIONNICKNAME.name: user?.locationNickName,
      FieldsEnum.PRONOUN.name: user?.pronoun,
      FieldsEnum.TWITTER.name: user?.twitter,
      FieldsEnum.FACEBOOK.name: user?.facebook,
      FieldsEnum.LINKEDIN.name: user?.linkedin,
      FieldsEnum.INSTAGRAM.name: user?.instagram,
      FieldsEnum.YOUTUBE.name: user?.youtube,
      FieldsEnum.TUMBLR.name: user?.tumbler,
      FieldsEnum.MEDIUM.name: user?.medium,
      FieldsEnum.TIKTOK.name: user?.tiktok,
      FieldsEnum.SNAPCHAT.name: user?.snapchat,
      FieldsEnum.PINTEREST.name: user?.pinterest,
      FieldsEnum.GITHUB.name: user?.github,
      FieldsEnum.TWITCH.name: user?.twitch,
      FieldsEnum.PS4.name: user?.ps4,
      FieldsEnum.XBOX.name: user?.xbox,
      FieldsEnum.STEAM.name: user?.steam,
      FieldsEnum.DISCORD.name: user?.discord,
      FieldsEnum.HTMLTOASTVIEW.name: user?.htmlToastView,
      FieldsEnum.SWITCH.name: user?.switchField,
      FieldsEnum.EPIC.name: user?.epic,
      'customFields': user?.customFields
    };
  }

  /// return [true] if [user1], [user2] have same data
  static bool isEqual(User user1, User user2) {
    var u1 = User.toJson(user1);
    var u2 = User.toJson(user2);

    var result = true;

    // to remove empty customfields, for eg sometimes, we have empty 'IMAGE: []' in userPreview data
    for (var _value in CustomContentType.values) {
      if (u1['customFields'][_value.name.toUpperCase()] == null ||
          (u1['customFields'][_value.name.toUpperCase()]).length == 0) {
        (u1['customFields'] as Map).remove(_value.name.toUpperCase());
      }

      if (u2['customFields'][_value.name.toUpperCase()] == null ||
          (u2['customFields'][_value.name.toUpperCase()]).length == 0) {
        (u2['customFields'] as Map).remove(_value.name.toUpperCase());
      }
    }

    u1.forEach((key, value) {
      if (result) {
        if (key == FieldsEnum.IMAGE.name) {
          Function eq = const ListEquality().equals;
          if (!eq(u1[key].value, u2[key].value)) {
            result = false;
          }
        }

        if (key != FieldsEnum.IMAGE.name) {
          if (key == 'customFields') {
            if (u1[key].length != u2[key].length) {
              result = false;
            } else {
              var key1 = u1[key];
              var key2 = u2[key];

              if (key1.toString() != key2.toString()) {
                result = false;
              }
            }
          } else {
            if ((u1[key] is BasicData) &&
                (u2[key] is BasicData) &&
                (u2[key].value != u1[key].value)) {
              result = false;

              /// sometimes, values dont match because we have null in some and empty string
              if ((u1[key].value == null ||
                      u1[key].value == '' ||
                      u1[key].value == 'null') &&
                  (u2[key].value == null ||
                      u2[key].value == '' ||
                      u2[key].value == 'null')) {
                result = true;
              }
            }
          }
        }
      }
    });

    return result;
  }

  static fromJson(Map<dynamic, dynamic> userMap) {
    try {
      Map<String, List<BasicData>> customFields = {};

      for (AtCategory atCategory in AtCategory.values) {
        List<BasicData> basicDataList = [];
        if (userMap['customFields'][atCategory.name] != null) {
          userMap['customFields'][atCategory.name].forEach((data) {
            var basicData = BasicData.fromJson(jsonDecode(data));
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
        image: BasicData.fromJson(json.decode(userMap[FieldsEnum.IMAGE.name])),
        firstname:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.FIRSTNAME.name])),
        lastname:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.LASTNAME.name])),
        location:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.LOCATION.name])),
        locationNickName: BasicData.fromJson(
            json.decode(userMap[FieldsEnum.LOCATIONNICKNAME.name])),
        pronoun:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.PRONOUN.name])),
        phone: BasicData.fromJson(json.decode(userMap[FieldsEnum.PHONE.name])),
        email: BasicData.fromJson(json.decode(userMap[FieldsEnum.EMAIL.name])),
        about: BasicData.fromJson(json.decode(userMap[FieldsEnum.ABOUT.name])),
        twitter:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.TWITTER.name])),
        facebook:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.FACEBOOK.name])),
        linkedin:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.LINKEDIN.name])),
        instagram:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.INSTAGRAM.name])),
        youtube:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.YOUTUBE.name])),
        tumbler:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.TUMBLR.name])),
        medium:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.MEDIUM.name])),
        tiktok:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.TIKTOK.name])),
        pinterest:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.PINTEREST.name])),
        github:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.GITHUB.name])),
        twitch:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.TWITCH.name])),
        snapchat:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.SNAPCHAT.name])),
        ps4: BasicData.fromJson(json.decode(userMap[FieldsEnum.PS4.name])),
        xbox: BasicData.fromJson(json.decode(userMap[FieldsEnum.XBOX.name])),
        steam: BasicData.fromJson(json.decode(userMap[FieldsEnum.STEAM.name])),
        discord:
            BasicData.fromJson(json.decode(userMap[FieldsEnum.DISCORD.name])),
        htmlToastView: BasicData.fromJson(
            json.decode(userMap[FieldsEnum.HTMLTOASTVIEW.name])),
        switchField: BasicData.fromJson(
            json.decode(userMap[FieldsEnum.SWITCH.name])),
        epic: BasicData.fromJson(
            json.decode(userMap[FieldsEnum.EPIC.name])),
        customFields: customFields,
      );
    } catch (e) {
      print('error : in User from json: $e');
      return User();
    }
  }
}

/// [accountName] is the label of the data
/// [valueDescription] is any description of the data
class BasicData {
  var value;
  bool isPrivate = false;
  Icon? icon;
  String? accountName, valueDescription;
  var type;

  BasicData({
    this.value,
    this.isPrivate = false,
    this.icon,
    this.accountName,
    this.type,
    this.valueDescription,
  });

  String? get displayingAccountName {
    if (FieldNames().basicDetailsFields.contains(accountName) ||
        FieldNames().additionalDetailsFields.contains(accountName) ||
        FieldNames().socialAccountsFields.contains(accountName) ||
        FieldNames().gameFields.contains(accountName)) {
      switch (accountName?.toLowerCase()) {
        case 'firstname':
          return 'First Name';
        case 'lastname':
          return 'Last Name';
      }
      return accountName?.toCapitalized();
    } else {
      return accountName;
    }
  }

  factory BasicData.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null &&
        json['accountName'] != null &&
        json['value'] != 'null' &&
        json['accountName'] != 'null') {
      if (json['type'] == CustomContentType.Image.name ||
          json['accountName'] == FieldsEnum.IMAGE.name &&
              json['value'] != null &&
              json['value'] != '') {
        json['value'] = jsonDecode(json['value']);
        json['value'] = json['value']!.cast<int>();
        json['value'] = Uint8List.fromList(json['value']);
      }
      if (json['value'] == '') {
        json['value'] = null;
      }
      return BasicData(
          value: json['value'],
          isPrivate: json['isPrivate'] == 'false' ? false : true,
          accountName: json['accountName'],
          valueDescription: json['valueDescription'],
          type: json['type']);
    } else {
      return BasicData();
    }
  }

  toJson() {
    return json.encode({
      'value': value?.toString(),
      // 'location': 'NH 18, Chas, Bokaro, 827013, Jharkhand, India',
      'isPrivate': isPrivate.toString(),
      'accountName': accountName.toString(),
      'valueDescription': valueDescription?.toString(),
      'type': type.toString(),
    });
  }

  @override
  String toString() {
    return 'value: $value, isPrivate: $isPrivate, icon: $icon, accountName:$accountName, type:$type, valueDescription:$valueDescription';
  }
}

BasicData formData(name, value, {private, type, valueDescription}) {
  BasicData basicdata = BasicData(
      accountName: name,
      // icon: setIcon(name),
      isPrivate: private ?? false,
      type: type ?? TextInputType.text,
      value: value,
      valueDescription: valueDescription);
  return basicdata;
}

// setIcon(fieldName) {
//   FieldsEnum field = valueOf(fieldName);

//   switch (field) {
//     case FieldsEnum.TWITTER:
//       return Icon(FontAwesomeIcons.twitter, color: Colors.blue, size: 30);
//       break;
//     case FieldsEnum.FACEBOOK:
//       return Icon(FontAwesomeIcons.facebook,
//           color: Colors.indigo[700], size: 30);
//       break;
//     case FieldsEnum.LINKEDIN:
//       return Icon(FontAwesomeIcons.linkedin,
//           color: Colors.indigo[700], size: 30);
//       break;
//     case FieldsEnum.INSTAGRAM:
//       return Icon(FontAwesomeIcons.instagram, color: Colors.red, size: 30);
//       break;
//     case FieldsEnum.YOUTUBE:
//       return Icon(FontAwesomeIcons.youtube, color: Colors.red[700], size: 30);
//       break;
//     case FieldsEnum.TUMBLR:
//       return Icon(FontAwesomeIcons.tumblr, color: Colors.indigo[800], size: 30);
//       break;
//     case FieldsEnum.MEDIUM:
//       return Icon(FontAwesomeIcons.medium, color: Colors.black, size: 30);
//       break;
//     case FieldsEnum.XBOX:
//       return Icon(MdiIcons.microsoftXbox, color: Colors.green[800], size: 30);
//       break;
//     case FieldsEnum.DISCORD:
//       return Icon(MdiIcons.discord, color: Colors.indigo, size: 30);
//       break;
//     case FieldsEnum.STEAM:
//       return Icon(MdiIcons.steam, color: Colors.blue, size: 30);
//       break;
//     case FieldsEnum.PS4:
//       return Icon(MdiIcons.sonyPlaystation, color: Colors.indigo, size: 30);
//     default:
//       return null;
//       break;
//   }
// }
extension StringCasingExtension on String {
  String toCapitalized() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}