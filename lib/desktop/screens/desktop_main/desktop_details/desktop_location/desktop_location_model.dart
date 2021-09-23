import 'package:at_wavi_app/desktop/utils/shared_preferences_utils.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/cupertino.dart';

class DesktopLocationModel extends ChangeNotifier {
  final UserPreview userPreview;

  List<String> _fields = [];

  List<String> get fields => _fields;

  static const _defaultLocations = [];

  DesktopLocationModel({required this.userPreview}) {
    initFields();
  }

  Future initFields() async {
    var savedFields = await getListStringFromSharedPreferences(
      key: MixedConstants.LOCATION_KEY,
    );
    if (savedFields == null || savedFields.isEmpty) {
      savedFields = [..._defaultLocations];
    }
    await updateField(
      savedFields,
      isInit: true,
    );
  }

  Future updateField(
      List<String> fields, {
        bool isInit = false,
      }) async {
    _fields.clear();
    _fields = fields;

    if (!isInit) {
      await saveListStringToSharedPreferences(
        key: MixedConstants.LOCATION_KEY,
        value: _fields,
      );
    }
    notifyListeners();
  }
}
