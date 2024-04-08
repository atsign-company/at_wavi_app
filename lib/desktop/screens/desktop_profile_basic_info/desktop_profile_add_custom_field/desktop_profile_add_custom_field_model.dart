import 'dart:typed_data';

import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_show_hide_radio_button.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/common_functions.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/cupertino.dart';

class DesktopAddBasicDetailModel extends ChangeNotifier {
  final UserPreview userPreview;
  final AtCategory atCategory;

  late CustomContentType _fieldType;

  CustomContentType get fieldType => _fieldType;

  Uint8List? _selectedMedia;

  Uint8List? get selectedMedia => _selectedMedia;

  bool isOnlyAddMedia = false;

  final titleTextController = TextEditingController(text: '');
  final valueContentTextController = TextEditingController(text: '');
  final showHideController = ShowHideController(isShow: true);

  final BasicData? originBasicData;
  final List<CustomContentType> allowContentType;

  DesktopAddBasicDetailModel({
    required this.userPreview,
    required this.atCategory,
    required this.allowContentType,
    this.originBasicData,
  }) {
    titleTextController.text = originBasicData?.accountName?.trim() ?? '';
    if (originBasicData?.type != null) {
      _fieldType = customContentNameToType(originBasicData?.type);
    } else {
      _fieldType = allowContentType.first;
    }
    if (originBasicData?.value is String) {
      valueContentTextController.text = originBasicData?.value;
    } else if (originBasicData?.value is Uint8List) {
      _selectedMedia = originBasicData?.value;
    }
    notifyListeners();
  }

  void changeField(CustomContentType fieldType) {
    _fieldType = fieldType;
    notifyListeners();
  }

  Future didSelectMedia(Uint8List selectedMedia) async {
    _selectedMedia = selectedMedia;
    notifyListeners();
  }

  Future addCustomField(BuildContext context) async {
    final _basicData = BasicData();
    if (_fieldType == CustomContentType.Image && selectedMedia == null) {
      CommonFunctions().showSnackBar(Strings.desktop_please_add_image);
      return;
    }
    _basicData.accountName = titleTextController.text.trim();
    _basicData.isPrivate = showHideController.isShow == false;
    if (_fieldType != CustomContentType.Image && _fieldType != CustomContentType.StorjImage) {
      _basicData.value = valueContentTextController.text;
    } else {
      _basicData.value = selectedMedia;
    }
    _basicData.type = fieldType.name;

    List<BasicData>? customFields =
        userPreview.user()!.customFields[atCategory.name];
    customFields!.add(_basicData);

    userPreview.user()?.customFields[atCategory.name] = customFields;

    FieldOrderService().addNewField(atCategory, _basicData.accountName!);
    userPreview.notifyListeners();
    Navigator.of(context).pop();
  }

  Future updateCustomField(BuildContext context) async {
    final _basicData = BasicData();
    if (_fieldType == CustomContentType.Image && _selectedMedia == null) {
      CommonFunctions().showSnackBar(Strings.desktop_please_add_image);
      return;
    }
    _basicData.accountName = titleTextController.text.trim();
    _basicData.isPrivate = showHideController.isShow == false;
    if (_fieldType != CustomContentType.Image) {
      _basicData.value = valueContentTextController.text;
    } else {
      _basicData.value = selectedMedia;
    }
    _basicData.type = fieldType.name;

    List<BasicData>? customFields =
        userPreview.user()!.customFields[atCategory.name];

    int index = customFields?.indexWhere(
            (element) => element.accountName == originBasicData?.accountName) ??
        -1;
    if (index >= 0) {
      customFields![index] = _basicData;
    }

    // if account name changes then add field to delete
    if (originBasicData?.accountName != null &&
        originBasicData?.accountName!.trim() !=
            _basicData.accountName!.trim()) {
      UserPreview().addFieldToDelete(atCategory, originBasicData!);
    }

    userPreview.user()?.customFields[atCategory.name] = customFields!;
    FieldOrderService().updateSingleField(
      atCategory,
      originBasicData?.accountName ?? '',
      _basicData.accountName ?? '',
    );
    userPreview.notifyListeners();
    Navigator.of(context).pop();
  }
}
