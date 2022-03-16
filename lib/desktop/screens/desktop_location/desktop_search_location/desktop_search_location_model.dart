import 'dart:convert';

import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_wavi_app/model/here_result.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class DesktopSearchLocationModel extends ChangeNotifier {
  bool _isSearching = false;

  bool get isSearching => _isSearching;

  HereResultList? _resultList;

  List<HereResult> get resultList => _resultList?.results ?? [];

  bool _isNear = false;

  bool get isNear => _isNear;

  void initialSetup() async {
    final currentLocation = await getMyLocation();
    _isNear = currentLocation != null;
    notifyListeners();
  }

  void changeNearSearching(bool isNear) {
    _isNear = isNear;
    notifyListeners();
  }

  void getAddressLatLng(String address, LatLng? currentLocation) async {
    _isSearching = true;
    _resultList = null;
    notifyListeners();
    if (address.isEmpty) {
      _isSearching = false;
      notifyListeners();
    }
    var url =
        'https://places.ls.hereapi.com/places/v1/autosuggest?q=${address.replaceAll(RegExp(' '), '+')}&apiKey=${MixedConstants.API_KEY}&at=${currentLocation?.latitude ?? 0},${currentLocation?.longitude ?? 0}';
    try {
      var response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      var addresses = jsonDecode(utf8.decode(response.bodyBytes));
      print(response.body);
      final result = HereResultList.fromJson(addresses);
      _resultList = result;
      _isSearching = false;
      notifyListeners();
    } catch (e, s) {
      print(e);
      print(s);
      _isSearching = false;
      notifyListeners();
    }
  }
}
