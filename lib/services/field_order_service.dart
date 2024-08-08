import 'dart:convert';

import 'package:at_commons/at_commons.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:provider/provider.dart';

class FieldOrderService {
  FieldOrderService._();
  static final FieldOrderService _instance = FieldOrderService._();
  factory FieldOrderService() => _instance;

  Map<String, List<String>> _fieldOrders = {};
  Map<String, List<String>> _previewFieldOrders = {};

  Map<String, List<String>> get previewOrders => _previewFieldOrders;

  Map<String, List<String>> get fieldOrders => _fieldOrders;

  set setPreviewOrder(Map<String, List<String>> data) {
    _previewFieldOrders = {...data};
  }

  set setFieldOrder(Map<String, List<String>> data) {
    _fieldOrders = {...data};
  }

  addFieldOrder(AtValue atValue) {
    if (atValue.value != null && atValue.value != '') {
      Map<String, dynamic> fielsOrder = jsonDecode(atValue.value);
      for (var field in fielsOrder.entries) {
        _fieldOrders[field.key] = [
          ...jsonDecode(fielsOrder[field.key]).cast<String>()
        ];
      }
    }
  }

  getFieldOrder() async {
    AtKey atKey = AtKey()
      ..key = MixedConstants.fieldOrderKey
      ..metadata = Metadata()
      ..metadata.isPublic = true
      ..metadata.ccd = true;

    var atValue = await BackendService().get(atKey);
    if (atValue.value != null && atValue.value != '') {
      Map<String, dynamic> fielsOrder = jsonDecode(atValue.value);
      for (var field in fielsOrder.entries) {
        _fieldOrders[field.key] = [
          ...jsonDecode(fielsOrder[field.key]).cast<String>()
        ];
      }
    }
  }

  updateFieldsOrder() async {
    if (FieldOrderService().previewOrders.toString() ==
        FieldOrderService().fieldOrders.toString()) {
      return;
    }
    AtKey atKey = AtKey()
      ..key = MixedConstants.fieldOrderKey
      ..metadata = Metadata()
      ..metadata.isPublic = true
      ..metadata.ccd = true;

    var fieldOrder = {};
    for (var field in FieldOrderService().previewOrders.entries) {
      fieldOrder[field.key] =
          jsonEncode(FieldOrderService().previewOrders[field.key]);
    }

    var response = await BackendService().put(atKey, jsonEncode(fieldOrder));
    if (response) {
      FieldOrderService().setFieldOrder = {
        ...FieldOrderService().previewOrders
      };
      FieldOrderService().setPreviewOrder = {};
    }
  }

  /// updates[category] order with [fileds]
  updateField(AtCategory category, List<String> fields) {
    _previewFieldOrders[category.name] = [...fields];
  }

  /// deletes [field] of [category] in [_previewFieldOrders]
  deleteField(AtCategory category, String field) {
    if (!_previewFieldOrders.containsKey(category.name)) {
      return false;
    }
    var allFields = <String>[];
    if (_previewFieldOrders[category.name] != null) {
      allFields = [..._previewFieldOrders[category.name]!];
    }

    allFields.removeWhere((el) => el == field);
    _previewFieldOrders[category.name] = [...allFields];
  }

  addNewField(AtCategory category, String field) {
    if (_previewFieldOrders[category.name] != null) {
      var index = _previewFieldOrders[category.name]!
          .indexWhere((element) => element == field);

      if (index == -1) {
        _previewFieldOrders[category.name] = [
          ..._previewFieldOrders[category.name]!,
          field
        ];
      }
    } else {
      _previewFieldOrders[category.name] = [field];
    }
  }

  updateSingleField(AtCategory category, String oldField, String newField) {
    if (_previewFieldOrders[category.name] != null &&
        _previewFieldOrders[category.name]!.isNotEmpty) {
      var index = _previewFieldOrders[category.name]!
          .indexWhere((el) => el == oldField);

      var allFields = <String>[];
      if (_previewFieldOrders[category.name] != null) {
        allFields = [..._previewFieldOrders[category.name]!];
      }

      if ((index != -1) || oldField == '') {
        allFields[index] = newField;
        _previewFieldOrders[category.name] = [...allFields];
      } else {
        addNewField(category, newField);
      }
    }
  }

  List<String> getFieldList(AtCategory category, {bool isPreview = false}) {
    var fieldOrder = <String>[];
    if (isPreview) {
      if (_previewFieldOrders.containsKey(category.name)) {
        fieldOrder = [..._previewFieldOrders[category.name]!];
      }
    } else if (_fieldOrders.containsKey(category.name)) {
      fieldOrder = [..._fieldOrders[category.name]!];
    }
    return fieldOrder;
  }

  initCategoryFields(AtCategory category) {
    if (_previewFieldOrders.containsKey(category.name)) {
      return;
    }
    var fields = [...FieldNames().getFieldList(category)];
    List<BasicData>? customFields = Provider.of<UserPreview>(
            NavService.navKey.currentContext!,
            listen: false)
        .user()!
        .customFields[category.name];

    if (customFields != null) {
      for (var field in customFields) {
        if (field.accountName != null && field.accountName != '') {
          var i = fields.indexWhere((el) => el == field.accountName!);
          if (i == -1) fields.add(field.accountName!);
        }
      }
    }

    _previewFieldOrders[category.name] = fields;
  }
}
