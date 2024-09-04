import 'package:at_common_flutter/services/size_config.dart';
// import 'package:at_common_flutter/widgets/custom_input_field.dart';
import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_location_flutter/common_components/custom_toast.dart';
import 'package:at_wavi_app/common_components/custom_input_field.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:latlong2/latlong.dart';

class SelectLocation extends StatefulWidget {
  final Function(OsmLocationModel)? callbackFunction;
  const SelectLocation({Key? key, this.callbackFunction}) : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String inputText = '';
  bool isLoader = false;
  bool? nearMe;
  LatLng? currentLocation;
  @override
  void initState() {
    calculateLocation();
    super.initState();
  }

  /// nearMe == null => loading
  /// nearMe == false => dont search nearme
  /// nearMe == true => search nearme
  /// nearMe == false && currentLocation == null =>dont search nearme
  // ignore: always_declare_return_types
  calculateLocation() async {
    currentLocation = await getMyLocation();
    if (currentLocation != null) {
      nearMe = true;
    } else {
      nearMe = false;
    }
    setState(() {});
  }

  _searchLocation() async {
    setState(() {
      isLoader = true;
    });
    if ((nearMe == null) || (!nearMe!)) {
      // ignore: await_only_futures
      SearchLocationService().getAddressLatLng(inputText, null);
    } else {
      // ignore: await_only_futures
      SearchLocationService().getAddressLatLng(inputText, currentLocation!);
    }
    setState(() {
      isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig().screenHeight * 0.8,
      padding: EdgeInsets.fromLTRB(28.toWidth, 20.toHeight, 17.toWidth, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: CustomInputField(
                  padding: const EdgeInsets.only(right: 10),
                  // width: 343.toWidth,
                  // height: 60.toHeight,
                  bgColor: ColorConstants.MILD_GREY,
                  hintText: '',
                  height: 50,
                  expands: false,
                  maxLines: 1,
                  icon: Icons.search,
                  borderColor: Colors.transparent,
                  focusedBorderColor: Colors.transparent,
                  textColor: ColorConstants.black,
                  initialValue: inputText,
                  baseOffset: inputText.length,
                  value: (String s) {
                    inputText = s;
                  },
                  onSubmitted: (str) {
                    _searchLocation();
                  },
                  onIconTap: () {
                    _searchLocation();
                  },
                ),

                ///////
                // CustomInputField(
                //   inputFieldColor: ColorConstants.MILD_GREY,
                //   hintText: 'Search an area, street name…',
                //   height: 50.toHeight,
                //   initialValue: inputText,
                //   onSubmitted: (String str) async {
                //     setState(() {
                //       isLoader = true;
                //     });
                //     if ((nearMe == null) || (!nearMe!)) {
                //       // ignore: await_only_futures
                //       SearchLocationService().getAddressLatLng(str, null);
                //     } else {
                //       // ignore: await_only_futures
                //       SearchLocationService()
                //           .getAddressLatLng(str, currentLocation!);
                //     }

                //     setState(() {
                //       isLoader = false;
                //     });
                //   },
                //   value: (val) {
                //     inputText = val;
                //   },
                //   icon: Icons.search,
                //   onIconTap: () async {
                //     setState(() {
                //       isLoader = true;
                //     });
                //     if ((nearMe == null) || (!nearMe!)) {
                //       // ignore: await_only_futures
                //       SearchLocationService().getAddressLatLng(inputText, null);
                //     } else {
                //       // ignore: await_only_futures
                //       SearchLocationService()
                //           .getAddressLatLng(inputText, currentLocation!);
                //     }
                //     setState(() {
                //       isLoader = false;
                //     });
                //   },
                // ),
              ),
              SizedBox(width: 10.toWidth),
              Column(
                children: [
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: CustomTextStyles.customTextStyle(
                              ColorConstants.orange))),
                ],
              ),
            ],
          ),
          SizedBox(height: 5.toHeight),
          Row(
            children: <Widget>[
              Checkbox(
                value: nearMe,
                tristate: true,
                // checkColor: Theme.of(context).primaryColor,
                fillColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
                checkColor: Theme.of(context).scaffoldBackgroundColor,
                onChanged: (value) async {
                  if (nearMe == null) return;

                  if (!nearMe!) {
                    currentLocation = await getMyLocation();
                  }

                  if (currentLocation == null) {
                    CustomToast().show('Unable to access location', context);
                    setState(() {
                      nearMe = false;
                    });
                    return;
                  }

                  setState(() {
                    nearMe = !nearMe!;
                  });
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Near me',
                        style: CustomTextStyles.customTextStyle(
                            Theme.of(context).primaryColor.withOpacity(0.5))),
                    ((nearMe == null) ||
                            ((nearMe == false) && (currentLocation == null)))
                        ? Flexible(
                            child: Text('(Cannot access location permission)',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyles.customTextStyle(
                                    ColorConstants.RED,
                                    size: 12)),
                          )
                        : const SizedBox()
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 5.toHeight),
          const Divider(),
          SizedBox(height: 18.toHeight),
          InkWell(
            onTap: () async {
              if (currentLocation == null) {
                CustomToast().show('Unable to access location', context);
                return;
              }
              onLocationSelect(context, currentLocation);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Location',
                    style: CustomTextStyles.customTextStyle(
                        Theme.of(context).primaryColor.withOpacity(0.5),
                        size: 14)),
                SizedBox(height: 5.toHeight),
                Text('Using GPS',
                    style: CustomTextStyles.customTextStyle(
                        Theme.of(context).primaryColor.withOpacity(0.5),
                        size: 12)),
              ],
            ),
          ),
          SizedBox(height: 20.toHeight),
          const Divider(),
          SizedBox(height: 20.toHeight),
          isLoader
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox(),
          StreamBuilder(
            stream: SearchLocationService().atLocationStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<LocationModal>> snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const SizedBox()
                  : snapshot.hasData
                      // ignore: prefer_is_empty
                      ? snapshot.data!.length == 0
                          ? const Text('Location not found')
                          : Expanded(
                              child: ListView.separated(
                                itemCount: snapshot.data!.length,
                                separatorBuilder: (context, index) {
                                  return const Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Divider(),
                                    ],
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => onLocationSelect(
                                      context,
                                      LatLng(
                                          double.parse(
                                              snapshot.data![index].lat!),
                                          double.parse(
                                              snapshot.data![index].long!)),
                                      displayName:
                                          snapshot.data![index].displayName,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        const Icon(Icons.location_on,
                                            color: ColorConstants.orange),
                                        SizedBox(width: 15.toWidth),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(snapshot.data![index].city!,
                                                  style: CustomTextStyles
                                                      .customTextStyle(
                                                          Theme.of(context)
                                                              .primaryColor,
                                                          size: 14)),
                                              Text(
                                                  snapshot.data![index]
                                                      .displayName!,
                                                  style: CustomTextStyles
                                                      .customTextStyle(
                                                          Theme.of(context)
                                                              .primaryColor
                                                              .withOpacity(0.5),
                                                          size: 12)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                      : snapshot.hasError
                          ? const Text('Something Went wrong')
                          : const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  void onLocationSelect(BuildContext context, LatLng? point,
      {String? displayName}) {
    SetupRoutes.push(
        NavService.navKey.currentContext!, Routes.SELECTED_LOCATION,
        arguments: {
          'displayName': displayName ?? '[Current Location]',
          'point': point,
          'callbackFunction': widget.callbackFunction,
        });
  }
}
