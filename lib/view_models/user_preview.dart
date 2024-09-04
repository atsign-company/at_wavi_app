
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/at_key_constants.dart';
import 'package:at_wavi_app/view_models/base_model.dart';
import 'package:validators/validators.dart';

class UserPreview extends BaseModel {
  UserPreview._();
  static final UserPreview _instance = UserPreview._();
  factory UserPreview() => _instance;

  User? _user;

  set setUser(User? user) {
    _user = user;
  }

  setSearchedUser(User? user) {
    _user = user;
  }

  User? user() {
    return _user;
  }

  void notify() {
    notifyListeners();
  }

// deletes any custom key from preview data.
  addFieldToDelete(AtCategory category, BasicData basicData) {
    List<BasicData>? customFields = _user!.customFields[category.name];

    customFields!.add(BasicData(
        accountName: basicData.accountName! + AtText.IS_DELETED,
        isPrivate: basicData.isPrivate));
  }

  deletCustomField(AtCategory category, BasicData basicData) {
    List<BasicData>? customFields = _user!.customFields[category.name];
    var newIndex = customFields!
        .indexWhere((element) => element.accountName == basicData.accountName);
    // var index = customFields!.indexOf(basicData);
    var index = newIndex;
    customFields[index] = BasicData(
        accountName: customFields[index].accountName!.trim() + AtText.IS_DELETED,
        isPrivate: customFields[index].isPrivate);

    FieldOrderService().deleteField(category, basicData.accountName!);
  }

  sortCustomLocationFields() {
    // List<BasicData>? customFields =
    //     _user!.customFields[AtCategory.LOCATION.name];
    // print('before element');
    // customFields!.forEach((element) {
    //   print('element $element');
    // });
    // for (int i = 0; i < (customFields ?? []).length; i++) {
    //   if (customFields![i].toString().contains('_deleted')) {
    //     for (int j = (i + 1); j < (customFields).length; j++) {
    //       if (!customFields[j].toString().contains('_deleted')) {
    //         var _newField =
    //             BasicData.fromJson(jsonDecode(customFields[i].toJson()));
    //         customFields[i] =
    //             BasicData.fromJson(jsonDecode(customFields[j].toJson()));
    //         customFields[j] =
    //             BasicData.fromJson(jsonDecode(_newField.toJson()));
    //       }
    //     }
    //   }
    // }
    // print('after element');
    // customFields.forEach((element) {
    //   print('element $element');
    // });
  }

  bool isFormDataValid(value, CustomContentType type) {
    switch (type) {
      case CustomContentType.Link:
        return isURL(value);

      case CustomContentType.Youtube:
        return RegExp(AtText.YOUTUBE_PATTERN).hasMatch(value);

      case CustomContentType.Number:
        //Add condition to validate number
        return true;

      default:
        return false;
    }
  }

  iskeyNameTaken(BasicData basicData) {
    String fieldName = _formatFieldName(basicData.accountName!);
    bool response = false;
    var customFields = _user!.customFields;
    var values = customFields.values;
    for (var basicDataList in values) {
      var result = basicDataList.indexWhere((data) {
        return _formatFieldName(data.accountName!) == fieldName;
      });
      if (result != -1) {
        return true;
      }
    }

    var mapRep = User.toJson(_user!);
    response = mapRep.containsKey(fieldName);

    return response;
  }

  String _formatFieldName(String fieldname) {
    return fieldname.trim().toLowerCase().replaceAll(' ', '');
  }
}
