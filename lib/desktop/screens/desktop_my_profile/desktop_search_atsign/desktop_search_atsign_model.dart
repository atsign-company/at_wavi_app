import 'package:at_wavi_app/desktop/utils/load_status.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/search_service.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/cupertino.dart';

class DesktopSearchAtSignModel extends ChangeNotifier {
  final UserPreview userPreview;

  List<SearchInstance> _searchInstance = [];
  LoadStatus _searchStatus = LoadStatus.initial;

  List<SearchInstance> get searchInstance => _searchInstance;

  LoadStatus get searchStatus => _searchStatus;

  DesktopSearchAtSignModel({required this.userPreview});

  void searchAtSignAccount({required String keyword}) async {
    _searchStatus = LoadStatus.loading;
    notifyListeners();
    SearchInstance? _searchService =
        await SearchService().getAtsignDetails(keyword);
    var _newSearchInstance = _searchService;
    _searchInstance = _newSearchInstance == null ? [] : [_newSearchInstance];
    _searchStatus = LoadStatus.success;
    notifyListeners();
  }
}
