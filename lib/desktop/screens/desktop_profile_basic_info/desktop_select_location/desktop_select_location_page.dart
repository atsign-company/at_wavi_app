import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_location_flutter/common_components/circle_marker_painter.dart';
import 'package:at_location_flutter/map_content/flutter_map/flutter_map.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DesktopSelectLocationPage extends StatefulWidget {
  final LatLng? point;
  final String? displayName;

  DesktopSelectLocationPage({
    this.displayName,
    this.point,
  });

  @override
  _DesktopSelectLocationPageState createState() => _DesktopSelectLocationPageState();
}

class _DesktopSelectLocationPageState extends State<DesktopSelectLocationPage> {
  /// Constants for marker and circle
  late double heightOfMarker = 50,
      widthOfMarker = 40,
      diameterOfCircle = 100,
      bottomOfCircle,
      leftOfCircle; // widthOfMarker and size of icon is same

  var mapController = MapController();
  late Marker? marker;
  late LatLng? center;
  late bool _absorbDoubleTapPointer;
  late double zoom;

  @override
  initState() {
    _absorbDoubleTapPointer = false;
    center = widget.point;
    zoom = 16;
    super.initState();
    if (center == null) {
      center = LatLng(
        21.028511,
        105.804817,
      );
    }
  }

  calculateMarkerDimensions() {
    /// bottomOfCircle = (((bottom of icon + (size of icon/2))*2 - height of circle)) / 2
    bottomOfCircle = ((((heightOfMarker / 2) + (widthOfMarker / 2)) * 2 - diameterOfCircle)) / 2;

    /// leftOfCircle = (size of icon - width of circle)/2
    leftOfCircle = (widthOfMarker - diameterOfCircle) / 2;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    calculateMarkerDimensions();
    return Container(
      width: MediaQuery.of(context).size.width / 2 + DesktopDimens.sideMenuWidth,
      decoration: BoxDecoration(
        color: appTheme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(DesktopDimens.paddingNormal),
              child: _buildMapWidget(),
            ),
          ),
          Container(width: 1, color: appTheme.separatorColor),
          Container(
            width: DesktopDimens.sideMenuWidth,
            decoration: BoxDecoration(
              color: appTheme.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: _buildControlWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildMapWidget() {
    final appTheme = AppTheme.of(context);
    if (center != null) {
      marker = Marker(
        width: widthOfMarker,
        height: heightOfMarker,
        point: center!,
        builder: (ctx) => Container(
          // color: Colors.red,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: heightOfMarker / 2, // height/2 => so, it starts from center
                child: Icon(
                  Icons.location_on,
                  color: appTheme.primaryColor,
                  size: widthOfMarker, // same as width of marker
                ),
              ),
              Positioned(
                // 25 + 20 (bottom + size/2) for center
                bottom: bottomOfCircle,
                // ((25 + (20))*2 - 200) => ((bottom of icon + (size of icon/2))*2 - heightof circle)
                left: leftOfCircle,
                // (40-200)/2 => (size of icon - width of circle)/2
                child: SizedBox(
                  width: diameterOfCircle,
                  height: diameterOfCircle,
                  child: CustomPaint(
                    painter: CircleMarkerPainter(
                        color: appTheme.primaryColor.withOpacity(0.4), paintingStyle: PaintingStyle.fill),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return FlutterMap(
      mapController: mapController,
      returnPositionTapped: (_latLng, _zoom) {
        setState(() {
          if (_absorbDoubleTapPointer) {
            center = _latLng ?? LatLng(0, 0);
          }
          zoom = _zoom ?? 16;
        });
      },
      absorbDoubleTapPointer: _absorbDoubleTapPointer,
      options: MapOptions(
        boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(0)),
        center: center,
        zoom: zoom,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=${MixedConstants.MAP_KEY}',
          subdomains: ['a', 'b', 'c'],
          minNativeZoom: 2,
          maxNativeZoom: 18,
          minZoom: 1,
          tileProvider: NonCachingNetworkTileProvider(),
        ),
        MarkerLayerOptions(markers: (marker == null) ? [] : [marker!])
      ],
    );
  }

  Widget _buildControlWidget() {
    final appTheme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      fillColor: WidgetStateProperty.all<Color>(Theme.of(context).primaryColor),
                      checkColor: Theme.of(context).scaffoldBackgroundColor,
                      value: _absorbDoubleTapPointer,
                      tristate: false,
                      onChanged: (value) async {
                        setState(() {
                          _absorbDoubleTapPointer = value!;
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 7),
                          Text(
                            'Enable double tap to move pointer',
                            style: appTheme.textTheme.bodyMedium,
                          ),
                          (_absorbDoubleTapPointer)
                              ? Flexible(
                                  child: Text(
                                    '(Double tap zoom is disabled)',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: appTheme.textTheme.bodyMedium,
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    )
                  ],
                ),
                // SizedBox(height: 10),
                Slider(
                  activeColor: appTheme.primaryColor,
                  inactiveColor: appTheme.primaryLighterColor,
                  value: diameterOfCircle,
                  min: 100,
                  max: 400,
                  divisions: 4,
                  label: 'Adjust radius',
                  onChanged: (double newValue) {
                    setState(() {
                      diameterOfCircle = newValue;
                    });
                  },
                ),
                SizedBox(height: 10),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 6),
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.displayName ?? '',
                          style: TextStyle(
                            color: appTheme.primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      text: 'NOTE: ',
                      children: [
                        TextSpan(
                          text:
                              'The view you select (Position of the marker, zoom level and radius of the circle), will be shown to other users.',
                          style: appTheme.textTheme.bodyMedium,
                        )
                      ],
                      style: appTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _bottomSheet(),
        ],
      ),
    );
  }

  Widget _bottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DesktopButton(
          title: 'Confirm',
          onPressed: onConfirmPressed,
        ),
        SizedBox(height: DesktopDimens.paddingNormal),
        DesktopWhiteButton(
          title: 'Cancel',
          onPressed: onCancelPressed,
        ),
        SizedBox(height: DesktopDimens.paddingNormal),
      ],
    );
  }

  void onCancelPressed() {
    Navigator.of(context).pop();
  }

  void onConfirmPressed() async {
    if (center == null) {
      return;
    }
    var _finalData = OsmLocationModel(
      '',
      diameterOfCircle,
      zoom,
      latitude: center?.latitude,
      longitude: center?.longitude,
      diameter: diameterOfCircle,
    );
    Navigator.of(context).pop(_finalData);
  }
}
