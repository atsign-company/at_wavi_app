import 'package:at_wavi_app/model/basic_data_model.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DesktopEditBasicDetailModel extends ChangeNotifier {
  final UserPreview userPreview;
  final AtCategory atCategory;

  final List<BasicDataModel> _basicData = [];

  List<BasicDataModel> get basicData => _basicData;

  bool get allFieldPrivate {
    return _basicData
            .map((e) => e.data.isPrivate ? 0 : 1)
            .toList()
            .reduce((a, b) => a + b) ==
        0;
  }

  bool get allFieldPublic {
    return _basicData
            .map((e) => e.data.isPrivate ? 1 : 0)
            .toList()
            .reduce((a, b) => a + b) ==
        0;
  }

  DesktopEditBasicDetailModel({
    required this.userPreview,
    required this.atCategory,
  }) {
    try {
      FieldOrderService().initCategoryFields(atCategory);
      fetchBasicData();
    } catch (e) {}
  }

  void fetchBasicData() {
    _basicData.clear();
    var userMap = User.toJson(userPreview.user());
    List<BasicData>? customFields =
        userPreview.user()?.customFields[atCategory.name] ?? [];

    var fields = <String>[];
    fields = [...FieldNames().getFieldList(atCategory, isPreview: true)];

    for (int i = 0; i < fields.length; i++) {
      BasicData basicData = BasicData();
      bool isCustomField = false;

      if (userMap.containsKey(fields[i])) {
        basicData = userMap[fields[i]];
        basicData.accountName ??= fields[i];
        basicData.value ??= '';
      } else {
        var index =
            customFields.indexWhere((el) => el.accountName == fields[i]);
        if (index != -1) {
          basicData = customFields[index];
          isCustomField = true;
        }
      }

      if (basicData.accountName == null) {
        continue;
      }
      _basicData.add(
        BasicDataModel(
          data: basicData,
          isCustomField: isCustomField,
        ),
      );
    }
    notifyListeners();
  }

  void saveData(BuildContext context) async {
    for (var data in _basicData) {
      final newBasicData = data.data;
      newBasicData.value = data.controller?.text.trim();
      newBasicData.isPrivate = !(data.publicController.value);
      await updateDefinedFields(context, newBasicData);
    }
    Provider.of<UserPreview>(context, listen: false).notifyListeners();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void saveAllFieldPublic() {
    for (var data in _basicData) {
      data.publicController.value = true;
    }
  }

  void saveAllFieldPrivate() {
    for (var data in _basicData) {
      data.publicController.value = false;
    }
  }

  /// [updateDefinedFields]can be used to either update or delete value
  /// when deleting send [BasicData] with just accountname
  /// when updating send complete [BasicData].
  updateDefinedFields(BuildContext context, BasicData basicData) {
    if (basicData.accountName == FieldsEnum.IMAGE.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.image =
          basicData;
    } else if (basicData.accountName == FieldsEnum.LASTNAME.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.lastname =
          basicData;
    } else if (basicData.accountName == FieldsEnum.FIRSTNAME.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.firstname =
          basicData;
    } else if (basicData.accountName == FieldsEnum.PHONE.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.phone =
          basicData;
    } else if (basicData.accountName == FieldsEnum.EMAIL.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.email =
          basicData;
    } else if (basicData.accountName == FieldsEnum.ABOUT.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.about =
          basicData;
    } else if (basicData.accountName == FieldsEnum.LOCATION.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.location =
          basicData;
    } else if (basicData.accountName == FieldsEnum.LOCATIONNICKNAME.name) {
      Provider.of<UserPreview>(context, listen: false)
          .user()!
          .locationNickName = basicData;
    } else if (basicData.accountName == FieldsEnum.PRONOUN.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.pronoun =
          basicData;
    } else if (basicData.accountName == FieldsEnum.TWITTER.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.twitter =
          basicData;
    } else if (basicData.accountName == FieldsEnum.FACEBOOK.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.facebook =
          basicData;
    } else if (basicData.accountName == FieldsEnum.LINKEDIN.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.linkedin =
          basicData;
    } else if (basicData.accountName == FieldsEnum.INSTAGRAM.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.instagram =
          basicData;
    } else if (basicData.accountName == FieldsEnum.YOUTUBE.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.youtube =
          basicData;
    } else if (basicData.accountName == FieldsEnum.TUMBLR.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.tumbler =
          basicData;
    } else if (basicData.accountName == FieldsEnum.MEDIUM.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.medium =
          basicData;
    } else if (basicData.accountName == FieldsEnum.PS4.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.ps4 = basicData;
    } else if (basicData.accountName == FieldsEnum.XBOX.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.xbox = basicData;
    } else if (basicData.accountName == FieldsEnum.STEAM.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.steam =
          basicData;
    } else if (basicData.accountName == FieldsEnum.DISCORD.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.discord =
          basicData;
    }
  }
}
