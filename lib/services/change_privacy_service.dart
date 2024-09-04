import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/screens/options.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:provider/provider.dart';

import 'at_key_set_service.dart';

class ChangePrivacyService {
  ChangePrivacyService._();
  static final ChangePrivacyService _instance = ChangePrivacyService._();
  factory ChangePrivacyService() => _instance;

  late User user;

  ///Returns 'true' on storing all fields in secondary.
  Future<bool> storeInSecondary() async {
    List<AtKey>? scanKeys = await BackendService().getAtKeys();
    //storing detail fields
    for (FieldsEnum field in FieldsEnum.values) {
      if ((field == FieldsEnum.ATSIGN) ||
          (field == FieldsEnum.PRIVATEACCOUNT) ||
          (field == FieldsEnum.HTMLTOASTVIEW)) {
        continue;
      }

      try {
        var data = get(field.name);
        if (data.value != null) {
          // String key = atkeys.get(field.name);
          var isUpdated = await AtKeySetService()
              .update(data, field.name, scanKeys: scanKeys);
          if (!isUpdated) return isUpdated;
        }
      } catch (e) {
        print('error in storeInSecondary for ${field.name}');
      }
    }
    // storing custom fields
    Map<String, List<BasicData>> customFields = user.customFields;
    for (var field in customFields.entries) {
      var isUpdated = await AtKeySetService()
          .updateCustomFields(field.key, field.value, scanKeys: scanKeys);
      print('For $field update $isUpdated');
      if (!isUpdated) return isUpdated;
    }
      return true;
  }

  setAllPrivate(bool private, User user) async {
    try {
      Provider.of<SetPrivateState>(NavService.navKey.currentContext!,
              listen: false)
          .setLoadingState(true);
      this.user = user;

      for (var field in FieldsEnum.values) {
        if ((field == FieldsEnum.ATSIGN) ||
            (field == FieldsEnum.PRIVATEACCOUNT) ||
            (field == FieldsEnum.HTMLTOASTVIEW)) {
          continue;
        }
        await setPrivacy(field.name, private);
      }
      var customFields =
          user.customFields.values.expand((element) => element).toList();
      for (var field in customFields) {
        field.isPrivate = private;
        print('For $field update $private');
      }
      // for (var field in user.customFields.entries) {
      //   for (var _key in field.value) {
      //     print('For $field update ${_key.isPrivate}');
      //   }
      // }

      await storeInSecondary();
      // update PRIVATEACCOUNT key
      await AtKeySetService().update(
          BasicData(value: private.toString()), FieldsEnum.PRIVATEACCOUNT.name);

      Provider.of<UserProvider>(NavService.navKey.currentContext!,
              listen: false)
          .user!
          .allPrivate = private;
      Provider.of<SetPrivateState>(NavService.navKey.currentContext!,
              listen: false)
          .setLoadingState(false);

      user.allPrivate = private;
    } catch (e) {
      print('Error in setAllPrivate $e');
      Provider.of<SetPrivateState>(NavService.navKey.currentContext!,
              listen: false)
          .setLoadingState(false);
    }
  }

  dynamic setPrivacy(property, bool value) async {
    try {
      BasicData field = get(property);
      // if (user.allPrivate != null && user.allPrivate == true)
      //   field.isPrivate = true;
      // else
      // field.isPrivate =
      //     field.value != '' && field.value != null ? value : false;

      if (field.value != '' && field.value != null) {
        field.isPrivate = value;
      }

      if (field.value == null) {
        return;
      }
      print('vaslue ${field.value} $property');
      // await AtKeySetService().update(field, property, isCheck: true);
    } catch (e) {
      print('error in setPrivacy for $property');
    }
  }

  dynamic get(String propertyName) {
    var mapRep = _toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
    throw ArgumentError('$propertyName propery not found');
  }

  Map<dynamic, dynamic> _toMap() {
    return {
      FieldsEnum.ATSIGN.name: user.atsign,
      FieldsEnum.PRIVATEACCOUNT.name: user.allPrivate,
      FieldsEnum.IMAGE.name: user.image,
      FieldsEnum.FIRSTNAME.name: user.firstname,
      FieldsEnum.LASTNAME.name: user.lastname,
      FieldsEnum.PHONE.name: user.phone,
      FieldsEnum.EMAIL.name: user.email,
      FieldsEnum.ABOUT.name: user.about,
      FieldsEnum.LOCATION.name: user.location,
      FieldsEnum.LOCATIONNICKNAME.name: user.locationNickName,
      FieldsEnum.PRONOUN.name: user.pronoun,
      FieldsEnum.TWITTER.name: user.twitter,
      FieldsEnum.FACEBOOK.name: user.facebook,
      FieldsEnum.LINKEDIN.name: user.linkedin,
      FieldsEnum.INSTAGRAM.name: user.instagram,
      FieldsEnum.YOUTUBE.name: user.youtube,
      FieldsEnum.TUMBLR.name: user.tumbler,
      FieldsEnum.MEDIUM.name: user.medium,
      FieldsEnum.PS4.name: user.ps4,
      FieldsEnum.XBOX.name: user.xbox,
      FieldsEnum.STEAM.name: user.steam,
      FieldsEnum.DISCORD.name: user.discord,

      ///
      FieldsEnum.TIKTOK.name: user.tiktok,
      FieldsEnum.SNAPCHAT.name: user.snapchat,
      FieldsEnum.PINTEREST.name: user.pinterest,
      FieldsEnum.GITHUB.name: user.github,
      FieldsEnum.TWITCH.name: user.twitch,
      FieldsEnum.SWITCH.name: user.switchField,
      FieldsEnum.EPIC.name: user.epic,
    };
  }
}
