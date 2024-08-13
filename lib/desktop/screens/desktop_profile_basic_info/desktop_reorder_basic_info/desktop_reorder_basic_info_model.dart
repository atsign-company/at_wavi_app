import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/cupertino.dart';

class DesktopReorderBasicDetailModel extends ChangeNotifier {
  final UserPreview userPreview;
  final AtCategory atCategory;

  final List<String> _fields = [];

  List<String> get fields => _fields;

  DesktopReorderBasicDetailModel({
    required this.userPreview,
    required this.atCategory,
  }) {
    fetchBasicData(atCategory);
  }

  void fetchBasicData(AtCategory atCategory) {
    _fields.clear();
    var userMap = User.toJson(userPreview.user());
    List<BasicData>? customFields =
        userPreview.user()?.customFields[atCategory.name] ?? [];

    var fields = <String>[];
    fields = [...FieldNames().getFieldList(atCategory, isPreview: true)];

    for (int i = 0; i < fields.length; i++) {
      BasicData basicData = BasicData();

      // commenting out as this is not being used anywhere else
      
      // bool isCustomField = false;

      if (userMap.containsKey(fields[i])) {
        basicData = userMap[fields[i]];
        basicData.accountName ??= fields[i];
        basicData.value ??= '';
      } else {
        var index =
        customFields.indexWhere((el) => el.accountName == fields[i]);
        if (index != -1) {
          basicData = customFields[index];
          // isCustomField = true;
        }
      }

      if (atCategory == AtCategory.LOCATION) {
        if (basicData.value is OsmLocationModel) {
          _fields.add(basicData.accountName!);
        }
      } else if (atCategory == AtCategory.FEATURED) {
        if (basicData.value != null && basicData.value.isNotEmpty) {
          _fields.add(basicData.accountName!);
        }
      } else {
        _fields.add(basicData.accountName!);
      }
    }
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = _fields.removeAt(oldIndex);
    _fields.insert(newIndex, item);
    notifyListeners();
  }

  void saveData(BuildContext context) {
    FieldOrderService().updateField(atCategory, fields);
    userPreview.notifyListeners();
    Navigator.of(context).pop(fields);
  }
}
