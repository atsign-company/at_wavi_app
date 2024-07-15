import 'dart:convert';

import 'package:at_location_flutter/map_content/flutter_map/flutter_map.dart';
import 'package:at_wavi_app/common_components/create_marker.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:flutter/material.dart';

class DesktopLocationItemWidget extends StatelessWidget {
  final String? title;
  final String? location;
  final bool isCustomField;
  final bool showMenu;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final ValueChanged<OsmLocationModel>? onPreviewPressed;

  DesktopLocationItemWidget({
    Key? key,
    this.title,
    this.location,
    required this.showMenu,
    required this.isCustomField,
    this.onEditPressed,
    this.onDeletePressed,
    this.onPreviewPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    OsmLocationModel? osmLocationModel;
    try {
      osmLocationModel = OsmLocationModel.fromJson(jsonDecode(location ?? "{}"));
    } catch (e) {
      print(e);
    }
    final isValidData = osmLocationModel != null && osmLocationModel.latLng != null;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (osmLocationModel != null) {
          onPreviewPressed?.call(osmLocationModel);
        }
      },
      child: Container(
        height: isValidData ? 200 : 60,
        padding: EdgeInsets.symmetric(vertical: DesktopDimens.paddingNormal),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: DesktopDimens.paddingNormal),
            Container(
              width: 100,
              child: Text(
                title ?? '',
                style: TextStyle(color: appTheme.secondaryTextColor, fontSize: 16),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: isValidData
                  ? Stack(
                      children: [
                        AbsorbPointer(
                          absorbing: true,
                          child: FlutterMap(
                            options: MapOptions(
                              boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(0)),
                              center: osmLocationModel!.latLng,
                              zoom: osmLocationModel.zoom ?? 14.0,
                            ),
                            layers: [
                              TileLayerOptions(
                                urlTemplate:
                                    'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=${MixedConstants.MAP_KEY}',
                                subdomains: ['a', 'b', 'c'],
                                minNativeZoom: 2,
                                maxNativeZoom: 18,
                                minZoom: 1,
                                tileProvider: NonCachingNetworkTileProvider(),
                              ),
                              MarkerLayerOptions(markers: [
                                if (osmLocationModel.latLng != null)
                                  Marker(
                                    width: 40,
                                    height: 50,
                                    point: osmLocationModel.latLng!,
                                    builder: (ctx) => Container(
                                        child: createMarker(diameterOfCircle: osmLocationModel!.diameter ?? 0)),
                                  )
                              ])
                            ],
                          ),
                        ),
                        Positioned(
                          child: IconButton(
                            color: appTheme.primaryColor,
                            icon: Icon(Icons.fullscreen),
                            onPressed: () {
                              if (osmLocationModel != null) {
                                onPreviewPressed?.call(osmLocationModel);
                              }
                            },
                          ),
                          top: 0,
                          right: 0,
                        ),
                      ],
                    )
                  : Container(
                      child: Text(
                        '${title ?? ''}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildMenuWidget(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuWidget(BuildContext context) {
    final appTheme = AppTheme.of(context);
    if (!showMenu) {
      return SizedBox(width: DesktopDimens.paddingNormal);
    }
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: SizedBox(
            child: Text(
              "Edit",
              style: appTheme.textTheme.bodyMedium,
            ),
          ),
          value: 0,
        ),
        if (isCustomField)
          PopupMenuItem(
            child: SizedBox(
              child: Text(
                "Delete",
                style: appTheme.textTheme.bodyMedium,
              ),
            ),
            value: 1,
          ),
      ],
      tooltip: null,
      child: SizedBox(
        width: 48,
        height: 52,
        child: Icon(
          Icons.more_vert_rounded,
          color: appTheme.secondaryTextColor,
        ),
      ),
      onSelected: (index) {
        if (index == 0) {
          onEditPressed?.call();
        } else if (index == 1) {
          onDeletePressed?.call();
        }
      },
    );
  }
}
