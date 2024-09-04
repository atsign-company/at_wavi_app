import 'package:at_location_flutter/map_content/flutter_map/flutter_map.dart';
import 'package:at_wavi_app/common_components/create_marker.dart';
import 'package:at_wavi_app/desktop/screens/desktop_location/desktop_search_location/desktop_search_location_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_select_location/desktop_select_location_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_add_location_model.dart';

class DesktopAddLocationPage extends StatefulWidget {
  final bool isEditing;
  final bool isCustomFiled;
  final BasicData? location;
  final BasicData? locationNickname;

  const DesktopAddLocationPage({
    Key? key,
    required this.isEditing,
    required this.isCustomFiled,
    this.location,
    this.locationNickname,
  }) : super(key: key);

  @override
  _DesktopAddLocationPageState createState() => _DesktopAddLocationPageState();
}

class _DesktopAddLocationPageState extends State<DesktopAddLocationPage> {
  late DesktopAddLocationModel _model;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopAddLocationModel(
          userPreview: userPreview,
          isEditing: widget.isEditing,
          isCustomField: widget.isCustomFiled,
          location: widget.location,
          locationNickname: widget.locationNickname,
        );
        return _model;
      },
      child: Consumer<DesktopAddLocationModel>(
        builder: (_, model, child) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              color: appTheme.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: openSelectLocation,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: appTheme.borderColor, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: model.osmLocationModel != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: FlutterMap(
                                      options: MapOptions(
                                        boundsOptions: const FitBoundsOptions(
                                            padding: EdgeInsets.all(0)),
                                        center: model.osmLocationModel?.latLng,
                                        zoom: model.osmLocationModel?.zoom ??
                                            14.0,
                                      ),
                                      layers: [
                                        TileLayerOptions(
                                          urlTemplate:
                                              'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=${MixedConstants.MAP_KEY}',
                                          subdomains: ['a', 'b', 'c'],
                                          minNativeZoom: 2,
                                          maxNativeZoom: 18,
                                          minZoom: 1,
                                          tileProvider:
                                              NonCachingNetworkTileProvider(),
                                        ),
                                        MarkerLayerOptions(markers: [
                                          if (model.osmLocationModel?.latLng !=
                                              null)
                                            Marker(
                                              width: 40,
                                              height: 50,
                                              point: model
                                                  .osmLocationModel!.latLng!,
                                              builder: (ctx) => Container(
                                                  child: createMarker(
                                                      diameterOfCircle: model
                                                              .osmLocationModel!
                                                              .diameter ??
                                                          0)),
                                            )
                                        ])
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: DesktopIconButton(
                            iconData: Icons.edit,
                            onPressed: openSearchLocation,
                            backgroundColor: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(DesktopDimens.paddingNormal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: appTheme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: DesktopDimens.paddingNormal),
                      GestureDetector(
                        onTap: openSearchLocation,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: appTheme.borderColor, width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                model.osmLocationModel != null
                                    ? 'Change'
                                    : 'Search',
                                style: appTheme.textTheme.labelLarge
                                    ?.copyWith(color: appTheme.primaryColor),
                              ),
                              const SizedBox(width: DesktopDimens.paddingNormal),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: DesktopDimens.paddingNormal),
                      Text(
                        'Tag',
                        style: appTheme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: DesktopDimens.paddingSmall),
                      SizedBox(
                        height: 48,
                        child: TextFormField(
                          controller: model.tagTextController,
                          style: appTheme.textTheme.bodyMedium?.copyWith(
                            color: appTheme.primaryTextColor,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: appTheme.borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: appTheme.primaryColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: DesktopDimens.paddingLarge),
                      Row(
                        children: [
                          Expanded(
                            child: DesktopWhiteButton(
                              title: 'Cancel',
                              width: 180,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DesktopButton(
                              title: 'Save',
                              width: 180,
                              onPressed: _onSaveData,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void openSelectLocation() async {
    final latLng = _model.osmLocationModel?.latLng;
    final title = _model.osmLocationModel?.location;
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopSelectLocationPage(
          displayName: title,
          point: latLng,
        ),
      ),
    );
    if (result is OsmLocationModel) {
      _model.changeLocation(result);
    }
  }

  void openSearchLocation() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopSearchLocationPage(),
      ),
    );
    if (result is OsmLocationModel) {
      _model.changeLocation(result);
    }
  }

  Future _onSaveData() async {
    await _model.saveData(context);
  }
}
