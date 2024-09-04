import 'package:at_common_flutter/services/size_config.dart';
import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_location_flutter/common_components/circle_marker_painter.dart';
import 'package:at_location_flutter/map_content/flutter_map/flutter_map.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:latlong2/latlong.dart';

class SelectedLocation extends StatefulWidget {
  final LatLng point;
  final String displayName;
  final Function(OsmLocationModel)? callbackFunction;

  const SelectedLocation(this.displayName, this.point, {Key? key, this.callbackFunction}) : super(key: key);
  @override
  _SelectedLocationState createState() => _SelectedLocationState();
}

class _SelectedLocationState extends State<SelectedLocation> {
  /// Constants for marker and circle
  late double heightOfMarker = 50,
      widthOfMarker = 40,
      diameterOfCircle = 100,
      bottomOfCircle,
      leftOfCircle; // widthOfMarker and size of icon is same

  var mapController = MapController();
  late Marker marker;
  late LatLng center;
  late bool _absorbDoubleTapPointer;
  late double zoom;

  @override
  initState() {
    _absorbDoubleTapPointer = false;
    center = widget.point;
    zoom = 16;
    super.initState();
  }

  calculateMarkerDimensions() {
    /// bottomOfCircle = (((bottom of icon + (size of icon/2))*2 - height of circle)) / 2
    bottomOfCircle = ((((heightOfMarker / 2) + (widthOfMarker / 2)) * 2 -
            diameterOfCircle)) /
        2;

    /// leftOfCircle = (size of icon - width of circle)/2
    leftOfCircle = (widthOfMarker - diameterOfCircle) / 2;
  }

  @override
  Widget build(BuildContext context) {
    calculateMarkerDimensions();
    marker = Marker(
      width: widthOfMarker,
      height: heightOfMarker,
      point: center,
      builder: (ctx) => Container(
        // color: Colors.red,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom:
                  heightOfMarker / 2, // height/2 => so, it starts from center
              child: Icon(
                Icons.location_on,
                color: ColorConstants.orange,
                size: widthOfMarker, // same as width of marker
              ),
            ),
            Positioned(
              // 25 + 20 (bottom + size/2) for center
              bottom:
                  bottomOfCircle, // ((25 + (20))*2 - 200) => ((bottom of icon + (size of icon/2))*2 - heightof circle)
              left:
                  leftOfCircle, // (40-200)/2 => (size of icon - width of circle)/2
              child: SizedBox(
                width: diameterOfCircle,
                height: diameterOfCircle,
                child: CustomPaint(
                  painter: CircleMarkerPainter(
                      color: const Color(0xFFF47B5D).withOpacity(0.2),
                      paintingStyle: PaintingStyle.fill),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      bottomSheet: _bottomSheet(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: mapController,
              returnPositionTapped: (latLng, zoom) {
                setState(() {
                  if (_absorbDoubleTapPointer) {
                    center = latLng ?? const LatLng(0, 0);
                  }
                  zoom = zoom ?? 16;
                });
              },
              absorbDoubleTapPointer: _absorbDoubleTapPointer,
              options: MapOptions(
                boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(0)),
                center: center,
                zoom: zoom,
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
                MarkerLayerOptions(markers: [marker])
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                    10.toWidth, 20.toHeight, 10.toHeight, 0),
                height: 280,
                width: SizeConfig().screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Checkbox(
                                fillColor: WidgetStateProperty.all<Color>(
                                    Theme.of(context).primaryColor),
                                checkColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                value: _absorbDoubleTapPointer,
                                tristate: false,
                                onChanged: (value) async {
                                  setState(() {
                                    _absorbDoubleTapPointer = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Enable double tap to move pointer',
                                        style: CustomTextStyles.customTextStyle(
                                            Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5))),
                                    (_absorbDoubleTapPointer)
                                        ? Flexible(
                                            child: Text(
                                                '(Double tap zoom is disabled)',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: CustomTextStyles
                                                    .customTextStyle(
                                                        ColorConstants.RED,
                                                        size: 12)),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              )
                            ],
                          ),
                          // SizedBox(height: 10.toHeight),
                          Slider(
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: ColorConstants.LIGHT_GREY,
                            value: diameterOfCircle,
                            min: 100,
                            max: 300,
                            divisions: 2,
                            label: 'Adjust radius',
                            onChanged: (double newValue) {
                              setState(() {
                                diameterOfCircle = newValue;
                              });
                            },
                          ),
                          SizedBox(height: 10.toHeight),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(widget.displayName,
                                      style: CustomTextStyles.customTextStyle(
                                          Theme.of(context).primaryColor)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.toHeight),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: 'NOTE: ',
                                style: CustomTextStyles.customTextStyle(
                                    Theme.of(context).primaryColor,
                                    size: 12),
                                children: [
                                  TextSpan(
                                    text:
                                        'The view you select (Position of the marker, zoom level and radius of the circle), will be shown to other people.',
                                    style: CustomTextStyles.customTextStyle(
                                        Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                        size: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return Row(
      children: [
        _bottomSheetButton('Cancel',
            isDark: Theme.of(context).scaffoldBackgroundColor ==
                ColorConstants.black),
        _bottomSheetButton('Confirm',
            isDark: Theme.of(context).scaffoldBackgroundColor !=
                ColorConstants.black),
      ],
    );
  }

  Widget _bottomSheetButton(String text, {bool isDark = false}) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (text == 'Cancel') {
            // if (zoom - 1 != 0) {
            //   zoom = zoom - 1;
            // }

            // mapController.move(center, zoom);
            Navigator.of(context).pop();
          }

          if (text == 'Confirm') {
            //// Diameter will go to radius as 2, 5, 10 for 100, 200, 300
            double radius;
            switch (diameterOfCircle.toInt()) {
              case 100:
                radius = 2;
                break;
              case 200:
                radius = 5;
                break;
              case 300:
                radius = 10;
                break;
              default:
                radius = 2;
            }
            var finalData = OsmLocationModel(null, radius, zoom,
                //  diameterOfCircle,
                latitude: center.latitude,
                longitude: center.longitude,
                diameter: 100); // default value, for backward compatibility

            if (widget.callbackFunction != null) {
              widget.callbackFunction!(finalData);
            }

            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        child: Container(
          height: 80.toHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: isDark ? ColorConstants.black : ColorConstants.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 3.0,
                ),
              ]),
          child: Text(
            text,
            style: isDark
                ? CustomTextStyles.customTextStyle(ColorConstants.white,
                    size: 18)
                : CustomTextStyles.customTextStyle(ColorConstants.black,
                    size: 18),
          ),
        ),
      ),
    );
  }
}
