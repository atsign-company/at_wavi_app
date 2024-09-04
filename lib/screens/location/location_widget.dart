import 'dart:convert';

import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_location_flutter/utils/constants/constants.dart';
import 'package:at_wavi_app/common_components/add_custom_content_button.dart';
import 'package:at_wavi_app/common_components/create_marker.dart';
import 'package:at_wavi_app/common_components/custom_input_field.dart';
import 'package:at_wavi_app/common_components/public_private_bottomsheet.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/screens/location/widgets/select_location.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/at_key_constants.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key}) : super(key: key);

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  ThemeData? _themeData;

  BasicData? _data;
  late bool _isPrivate;
  // removed locationString as it is not used
  String _locationNickname = '';
  late Key _mapKey; // in order to update map when needed
  List<String> fieldOrder = [];

  @override
  initState() {
    _getThemeData();
    if (FieldOrderService().previewOrders[AtCategory.LOCATION.name] == null) {
      FieldOrderService().initCategoryFields(AtCategory.LOCATION);
    }

    getFieldOrder();

    _mapKey = UniqueKey();
    _isPrivate = false;

    _data = Provider.of<UserPreview>(context, listen: false).user()!.location;
    _locationNickname = Provider.of<UserPreview>(context, listen: false)
            .user()!
            .locationNickName
            .value ??
        '';
    _isPrivate = Provider.of<UserPreview>(context, listen: false)
        .user()!
        .location
        .isPrivate;

    LocationWidgetData().init(
        jsonData: Provider.of<UserPreview>(context, listen: false)
            .user()!
            .location
            .value);
    super.initState();
  }

  getFieldOrder() {
    if (FieldOrderService().previewOrders[AtCategory.LOCATION.name] == null) {
      FieldOrderService().initCategoryFields(AtCategory.LOCATION);
    }
    fieldOrder = [
      ...FieldNames().getFieldList(AtCategory.LOCATION, isPreview: true)
    ];
  }

  _getThemeData() async {
    _themeData =
        await Provider.of<ThemeProvider>(context, listen: false).getTheme();

    if (mounted) {
      setState(() {});
    }
  }

  updateIsPrivate(bool mode) {
    List<BasicData>? customFields =
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .customFields[AtCategory.LOCATION.name];

    if (customFields != null) {
      for (var basicData in customFields) {
        basicData.isPrivate = mode;
      }
    }

    //// for predefined fields
    if (Provider.of<UserPreview>(context, listen: false)
            .user()!
            .location
            .value !=
        null) {
      Provider.of<UserPreview>(context, listen: false)
          .user()!
          .location
          .isPrivate = mode;
    }

    if (Provider.of<UserPreview>(context, listen: false)
            .user()!
            .location
            .value !=
        null) {
      Provider.of<UserPreview>(context, listen: false)
          .user()!
          .locationNickName
          .isPrivate = mode;
    }

    setState(() {
      _isPrivate = mode;
    });
  }

  @override
  void dispose() {
    LocationWidgetData().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_themeData == null) {
      return const CircularProgressIndicator();
    }

    // commented 
    // _locationString =
    //     (_data != null && (_data!.value != null) && (_data!.value != ''))
    //         ? jsonDecode(_data!.value)['location']
    //         : '';

    return PopScope(
  canPop: true,
  onPopInvoked: (didPop) async {
    if (!didPop) {
      if (_locationNickname.isNotEmpty &&
          ((LocationWidgetData().osmLocationModelNotifier == null) ||
              (LocationWidgetData().osmLocationModelNotifier!.value == null) ||
              (LocationWidgetData().osmLocationModelNotifier!.value!.latLng == null))) {
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .locationNickName
            .value = '';
      }

      if (_locationNickname.isEmpty) {
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .location
            .value = '';
      }

      Navigator.of(context).pop();
    }
  },
      child: ValueListenableBuilder(
          valueListenable: LocationWidgetData().osmLocationModelNotifier!,
          builder: (BuildContext context, OsmLocationModel? osmLocationModel,
              Widget? child) {
            // store location
            Provider.of<UserPreview>(context, listen: false).user()!.location =
                BasicData(
              value:
                  osmLocationModel?.toJson(),
              accountName: FieldsEnum.LOCATION.name,
              isPrivate: _isPrivate,
            );

            return Scaffold(
              // bottomSheet: InkWell(
              //   onTap: () {
              //     if (_osmLocationModel != null) {
              //       _updateLocation(_osmLocationModel);
              //     } else {
              //       if (_locationNickname.isEmpty) {
              //         return _showToast('Enter Location tag', isError: true);
              //       }
              //       _showToast('Enter Location', isError: true);
              //     }
              //   },
              //   child: Container(
              //       alignment: Alignment.center,
              //       height: 70.toHeight,
              //       width: SizeConfig().screenWidth,
              //       color: (_osmLocationModel != null)
              //           ? ColorConstants.black
              //           : ColorConstants.dullColor(
              //               color: ColorConstants.black, opacity: 0.5),
              //       child: Text(
              //         'Done',
              //         style: CustomTextStyles.customTextStyle(
              //             ColorConstants.white,
              //             size: 18),
              //       )),
              // ),
              appBar: AppBar(
                  toolbarHeight: 40,
                  title: Text(
                    'Location',
                    style: CustomTextStyles.customBoldTextStyle(
                        Theme.of(context).primaryColor,
                        size: 16),
                  ),
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  centerTitle: false,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  actions: [
                    InkWell(
                      onTap: () {
                        showPublicPrivateBottomSheet(
                            onPublicClicked: () {
                              updateIsPrivate(false);
                            },
                            onPrivateClicked: () {
                              updateIsPrivate(true);
                            },
                            height: 200.toHeight);
                      },
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              SetupRoutes.push(
                                context,
                                Routes.REORDER_FIELDS,
                                arguments: {
                                  'category': AtCategory.LOCATION,
                                  'onSave': () {
                                    getFieldOrder();
                                    setState(() {});
                                  }
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.reorder),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: _isPrivate
                                  ? const Icon(Icons.lock)
                                  : const Icon(Icons.public)),
                        ],
                      ),
                    )
                  ]),
              body: SizedBox(
                height: SizeConfig().screenHeight - 80.toHeight - 55,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.toHeight,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                        child: Text('Title',
                            style: TextStyles.lightText(
                                _themeData!.primaryColor.withOpacity(0.5),
                                size: 16)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.toWidth, vertical: 0.toHeight),
                        child: CustomInputField(
                          borderColor: Colors.transparent,
                          focusedBorderColor: Colors.transparent,
                          width: double.infinity,
                          // hintText: 'Enter the tag',
                          hintTextColor:
                              _themeData!.primaryColor.withOpacity(0.5),
                          bgColor: Colors.transparent,
                          textColor: _themeData!.primaryColor,
                          initialValue: _locationNickname,
                          baseOffset: _locationNickname.length,
                          height: 70,
                          expands: false,
                          maxLines: 1,
                          value: (str) => setState(() {
                            _locationNickname = str;
                            // store location nickname
                            Provider.of<UserPreview>(context, listen: false)
                                .user()!
                                .locationNickName = BasicData(
                              value: _locationNickname,
                              accountName: FieldsEnum.LOCATIONNICKNAME.name,
                              isPrivate: _isPrivate,
                            );
                          }),
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                        child: Text('Location',
                            style: TextStyles.lightText(
                                _themeData!.primaryColor.withOpacity(0.5),
                                size: 16)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.toWidth, vertical: 12.toHeight),
                        child: CustomInputField(
                          isReadOnly: true,
                          borderColor: Colors.transparent,
                          focusedBorderColor: Colors.transparent,
                          width: double.infinity,
                          hintText: 'Search',
                          hintTextColor:
                              _themeData!.primaryColor.withOpacity(0.5),
                          bgColor: Colors.transparent,
                          textColor: _themeData!.primaryColor,
                          // initialValue: _locationString,
                          // baseOffset: _locationString.length,
                          height: 70,
                          expands: false,
                          maxLines: 1,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const StadiumBorder(),
                                builder: (BuildContext context) {
                                  return Container(
                                    height: SizeConfig().screenHeight * 0.9,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 0),
                                    decoration: BoxDecoration(
                                      color:
                                          _themeData!.scaffoldBackgroundColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0),
                                      ),
                                    ),
                                    child: SelectLocation(
                                      callbackFunction: (finalData) {
                                        print(
                                            '_finalData $finalData ${finalData.latLng}');
                                        LocationWidgetData().update(finalData);
                                      },
                                    ),
                                  );
                                }).then((value) => _mapKey = UniqueKey());
                          },
                          value: (str) => setState(() {
                            _data!.value = str;
                          }),
                        ),
                      ),
                      ((osmLocationModel != null) &&
                              (osmLocationModel.latLng != null))
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  AbsorbPointer(
                                    absorbing: true,
                                    child: FlutterMap(
                                      key: _mapKey,
                                      options: MapOptions(
                                        boundsOptions: const FitBoundsOptions(
                                            padding: EdgeInsets.all(0)),
                                        center: osmLocationModel.latLng!,
                                        zoom: osmLocationModel.zoom!,
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
                                          Marker(
                                            width: 40,
                                            height: 50,
                                            point: osmLocationModel.latLng!,
                                            builder: (ctx) => Container(
                                                child: createMarker(
                                                    diameterOfCircle:
                                                        osmLocationModel
                                                            .radius!)),
                                          )
                                        ])
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: ColorConstants.LIGHT_GREY,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            SetupRoutes.push(context,
                                                Routes.PREVIEW_LOCATION,
                                                arguments: {
                                                  'title': _locationNickname,
                                                  'latLng':
                                                      osmLocationModel.latLng!,
                                                  'zoom':
                                                      osmLocationModel.zoom!,
                                                  'diameterOfCircle':
                                                      osmLocationModel.radius!,
                                                });
                                          },
                                          icon: const Icon(Icons.fullscreen)),
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 70,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: ColorConstants.LIGHT_GREY,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            _confirmationDialog();
                                          },
                                          icon: const Icon(Icons.delete)),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                      ((Provider.of<UserPreview>(context, listen: false)
                                      .user()!
                                      .customFields['LOCATION'] !=
                                  null) &&
                              (Provider.of<UserPreview>(context, listen: false)
                                      .user()!
                                      .customFields['LOCATION']!.isNotEmpty))
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.toWidth,
                                  vertical: 12.toHeight),
                              child: Text('More Locations',
                                  style: TextStyles.lightText(
                                      _themeData!.primaryColor.withOpacity(0.5),
                                      size: 16)),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.toWidth, vertical: 12.toHeight),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fieldOrder.length,
                          itemBuilder: (context, int) {
                            var customFields =
                                Provider.of<UserPreview>(context, listen: false)
                                    .user()!
                                    .customFields[AtCategory.LOCATION.name];

                            customFields ??= [];

                            var index = customFields.indexWhere((element) =>
                                element.accountName == fieldOrder[int]);

                            if (index == -1) {
                              return const SizedBox();
                            }

                            if (customFields[index]
                                .accountName!
                                .contains(AtText.IS_DELETED)) {
                              return const SizedBox();
                            }

                            return InkWell(
                              onTap: () async {
                                await SetupRoutes.push(
                                    context, Routes.CREATE_CUSTOM_LOCATION,
                                    arguments: {
                                      'basicData': Provider.of<UserPreview>(
                                              context,
                                              listen: false)
                                          .user()!
                                          .customFields['LOCATION']?[index],
                                      'onSave': () {
                                        getFieldOrder();
                                        setState(() {});
                                      }
                                    });
                                setState(() {});
                              },
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.15,
                                  children: [
                                    SlidableAction(
                                      label: '',
                                      backgroundColor:
                                          _themeData!.scaffoldBackgroundColor,
                                      icon: Icons.delete,
                                      onPressed: (context) {
                                        _deleteKey(Provider.of<UserPreview>(
                                                context,
                                                listen: false)
                                            .user()!
                                            .customFields['LOCATION']![index]);
                                      },
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                          // '${(_int + 1).toString()}. ' +
                                          '-  ${Provider.of<UserPreview>(context)
                                                      .user()!
                                                      .customFields['LOCATION']
                                                          ?[index]
                                                      .accountName ??
                                                  ''}',
                                          style: TextStyles.lightText(
                                              _themeData!.primaryColor,
                                              size: 16)),
                                    ),
                                    Provider.of<UserPreview>(context)
                                                .user()!
                                                .customFields['LOCATION']
                                                    ?[index]
                                                .isPrivate ??
                                            false
                                        ? const Icon(Icons.lock)
                                        : const Icon(Icons.public)
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, int) {
                            var customFields =
                                Provider.of<UserPreview>(context, listen: false)
                                    .user()!
                                    .customFields[AtCategory.LOCATION.name];
                            customFields ??= [];

                            var index = customFields.indexWhere((element) =>
                                element.accountName == fieldOrder[int]);

                            if (index == -1) {
                              return const SizedBox();
                            }

                            if (customFields[index]
                                .accountName!
                                .contains(AtText.IS_DELETED)) {
                              return const SizedBox();
                            }

                            return const Divider();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                        child: AddCustomContentButton(
                          text: 'Add more location',
                          onTap: () async {
                            await SetupRoutes.push(
                                context, Routes.CREATE_CUSTOM_LOCATION,
                                arguments: {
                                  'onSave': () {
                                    getFieldOrder();
                                    setState(() {});
                                  },
                                });
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  _deleteKey(BasicData basicData) async {
    Provider.of<UserPreview>(context, listen: false)
        .deletCustomField(AtCategory.LOCATION, basicData);
    setState(() {});

    // LoadingDialog().show(text: 'Deleting $key');
    // await AtKeySetService()
    //     .deleteKey(key, AtCategory.LOCATION.name, isCustomKey: true);
    // LoadingDialog().hide();
  }

  Future<bool?> _confirmationDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SizedBox(
          width: SizeConfig().screenWidth * 0.8,
          child: AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Do you want to remove ${Provider.of<UserPreview>(context, listen: false).user()!.locationNickName.value ?? 'Location'}?',
                      style: CustomTextStyles.customTextStyle(
                          _themeData!.primaryColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  _themeData!.scaffoldBackgroundColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                              style: TextStyles.lightText(
                                  _themeData!.primaryColor,
                                  size: 16),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  _themeData!.primaryColor),
                            ),
                            onPressed: () {
                              Provider.of<UserPreview>(context, listen: false)
                                  .user()!
                                  .locationNickName
                                  .value = '';

                              Provider.of<UserPreview>(context, listen: false)
                                  .user()!
                                  .location
                                  .value = '';

                              _locationNickname = '';
                              LocationWidgetData().removeData();
                              setState(() {});

                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Yes',
                              style: TextStyles.lightText(
                                  _themeData!.scaffoldBackgroundColor,
                                  size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return null;
  }
}

class LocationWidgetData {
  LocationWidgetData._();

  static final LocationWidgetData _instance = LocationWidgetData._();

  factory LocationWidgetData() => _instance;

  ValueNotifier<OsmLocationModel?>? osmLocationModelNotifier;

  init({OsmLocationModel? initialData, dynamic jsonData}) {
    osmLocationModelNotifier = ValueNotifier(initialData);
    if (jsonData != null && jsonData != 'null' && jsonData != '') {
      var decodedData = jsonDecode(jsonData);
      osmLocationModelNotifier =
          ValueNotifier(OsmLocationModel.fromJson(decodedData));
    }
  }

  dispose() {
    osmLocationModelNotifier = null;
  }

  update(OsmLocationModel data) {
    osmLocationModelNotifier!.value = data;
  }

  removeData() {
    osmLocationModelNotifier!.value = null;
  }
}
