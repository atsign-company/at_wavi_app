import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_wavi_app/desktop/screens/desktop_common/desktop_dialog_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_select_location/desktop_select_location_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/model/here_result.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'desktop_search_location_model.dart';

class DesktopSearchLocationPage extends StatefulWidget {
  const DesktopSearchLocationPage({Key? key}) : super(key: key);

  @override
  _DesktopSearchLocationPageState createState() => _DesktopSearchLocationPageState();
}

class _DesktopSearchLocationPageState extends State<DesktopSearchLocationPage> {
  final keywordTextController = TextEditingController();
  late DesktopSearchLocationModel _model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _model = DesktopSearchLocationModel();
    _model.initialSetup();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider.value(
      value: _model,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.all(DesktopDimens.paddingNormal),
        decoration: BoxDecoration(
          color: appTheme.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: keywordTextController,
                    decoration: InputDecoration(hintText: 'Search'),
                    onChanged: (text) {
                      _searchLocation();
                    },
                  ),
                ),
                SizedBox(
                  width: DesktopDimens.paddingNormal,
                ),
                DesktopIconButton(
                  iconData: Icons.search,
                  onPressed: () {
                    _searchLocation();
                  },
                ),
              ],
            ),
            SizedBox(
              height: DesktopDimens.paddingNormal,
            ),
            Row(
              children: [
                Consumer<DesktopSearchLocationModel>(
                  builder: (context, cart, child) {
                    return Checkbox(
                      value: _model.isNear,
                      onChanged: (value) async {
                        if (value == true) {
                          final isOK = await _isEnableLocation();
                          if (isOK == false) {
                            return;
                          }
                        }

                        _model.changeNearSearching(value ?? false);
                      },
                      checkColor: Colors.white,
                      activeColor: appTheme.primaryColor,
                    );
                  },
                ),
                Text(
                  'Near me',
                  style: appTheme.textTheme.bodyMedium,
                ),
                Spacer(),
                DesktopButton(
                  title: 'Using GPS',
                  width: 120,
                  backgroundColor: appTheme.secondaryBackgroundColor,
                  onPressed: () async {
                    final isOK = await _isEnableLocation();
                    if (isOK == false) {
                      return;
                    }
                    openSelectLocation();
                  },
                )
              ],
            ),
            SizedBox(
              height: DesktopDimens.paddingNormal,
            ),
            Expanded(
              child: Consumer<DesktopSearchLocationModel>(
                builder: (_, model, child) {
                  return ListView.separated(
                    itemCount: _model.resultList.length,
                    itemBuilder: (context, index) {
                      final item = _model.resultList[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _onSelectLocation(item);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: DesktopDimens.paddingSmall,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(item.title ?? ''),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: appTheme.separatorColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: appTheme.separatorColor,
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                DesktopWhiteButton(
                  title: 'Cancel',
                  width: 180,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _isEnableLocation() async {
    LocationPermission permission;

    // Test if location services are enabled.
    if (!await Geolocator.isLocationServiceEnabled()) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print('Location services are disabled.');
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          backgroundColor: Colors.transparent,
          child: DesktopDialogPage(
            title: 'Location services are disabled. Please enable them in your settings to search by your location.',
            onOkPressed: () {
              Geolocator.openLocationSettings();
            },
          ),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print('Location permissions are denied');
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            backgroundColor: Colors.transparent,
            child: DesktopDialogPage(
              title: 'Location permissions are denied. Please enable them in your settings to search by your location.',
              onOkPressed: () {
                Geolocator.openLocationSettings();
              },
            ),
          ),
        );
        return false;
      }
    }
    return true;
  }

  void _searchLocation() async {
    final keyword = keywordTextController.text;
    final currentLocation = await getMyLocation();
    if (!_model.isNear) {
      _model.getAddressLatLng(keyword, null);
    } else {
      _model.getAddressLatLng(keyword, currentLocation);
    }
  }

  void _onSelectLocation(HereResult location) {
    double? lat = location.position?.first;
    double? lng = location.position?.last;
    if (lat != null && lng != null) {
      openSelectLocation(latLng: LatLng(lat, lng), title: location.title);
    }
  }

  void openSelectLocation({LatLng? latLng, String? title}) async {
    final currentLocation = await getMyLocation();
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopSelectLocationPage(
          displayName: title ?? '',
          point: latLng ?? currentLocation,
        ),
      ),
    );
    if (result is OsmLocationModel) {
      Navigator.pop(context, result);
    }
  }
}
