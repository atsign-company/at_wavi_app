import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_wavi_app/common_components/create_marker.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DesktopLocationPreviewPage extends StatelessWidget {
  final LatLng latLng;
  final double zoom, diameterOfCircle;
  final String title;

  const DesktopLocationPreviewPage({
    Key? key,
    required this.title,
    required this.latLng,
    required this.zoom,
    required this.diameterOfCircle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          title,
          style: appTheme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        backgroundColor: Colors.black.withOpacity(0.4),
        elevation: 0,
      ),
      body: FlutterMap(
        options: MapOptions(
          boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(0)),
          center: latLng,
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
          MarkerLayerOptions(markers: [
            Marker(
              width: 40,
              height: 50,
              point: latLng,
              builder: (ctx) => Container(
                  child: createMarker(diameterOfCircle: diameterOfCircle)),
            )
          ])
        ],
      ),
    );
  }
}
