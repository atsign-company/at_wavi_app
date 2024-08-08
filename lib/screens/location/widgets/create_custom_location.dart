import 'dart:convert';
import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_location_flutter/utils/constants/constants.dart';
import 'package:at_wavi_app/common_components/create_marker.dart';
import 'package:at_wavi_app/common_components/custom_input_field.dart';
import 'package:at_wavi_app/common_components/public_private_bottomsheet.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/screens/location/widgets/select_location.dart';
import 'package:at_wavi_app/services/compare_basicdata.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCustomLocation extends StatefulWidget {
  final BasicData? basicData;
  final Function? onSave;
  const CreateCustomLocation({Key? key, this.basicData, this.onSave})
      : super(key: key);

  @override
  _CreateCustomLocationState createState() => _CreateCustomLocationState();
}

class _CreateCustomLocationState extends State<CreateCustomLocation> {
  late BasicData _data;
  // late bool _isPrivate;
  // String _locationString = '', _accountName = '';
  OsmLocationModel? _osmLocationModel;
  late Key _mapKey; // in order to update map when needed

  @override
  initState() {
    _mapKey = UniqueKey();
    // _isPrivate = false;
    if (widget.basicData != null) {
      _data = BasicData.fromJson(jsonDecode(widget.basicData!.toJson()));
      if (widget.basicData!.type.toLowerCase() ==
          CustomContentType.Text.name.toLowerCase()) {
        widget.basicData!.type = CustomContentType.Location.name;
      }
    } else {
      _data =
          BasicData(isPrivate: false, type: CustomContentType.Location.name);
    }
    _osmLocationModel =
        OsmLocationModel.fromJson(jsonDecode(_data.value ?? '{}'));
    // _accountName = _data.accountName ?? '';
    // _isPrivate = _data.isPrivate;

    super.initState();
  }

  updateIsPrivate(bool mode) {
    setState(() {
      // _isPrivate = _mode;
      _data.isPrivate = mode;
    });
  }

  // @override
  // void dispose() {
  //   LocationWidgetData().dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder(
    //     valueListenable: LocationWidgetData().osmLocationModelNotifier!,
    //     builder: (BuildContext context, OsmLocationModel? _osmLocationModel,
    //         Widget? child) {
    _data.value = _osmLocationModel!.toJson();
    return Scaffold(
      bottomSheet: InkWell(
        onTap: () {
          if ((_data.accountName == null) || (_data.accountName == '')) {
            return _showToast('Title is required', isError: true);
          }

          if (_data.accountName != null) {
            _data.accountName = _data.accountName!.trim();
          }

          if (_data.value != null) {
            _updateLocation(_osmLocationModel!);
            FieldOrderService()
                .addNewField(AtCategory.LOCATION, _data.accountName!);
          } else {
            _showToast('Location is required', isError: true);
          }
        },
        child: Container(
            alignment: Alignment.center,
            height: 70.toHeight,
            width: SizeConfig().screenWidth,
            color: (_data.value != null)
                ? ColorConstants.black
                : ColorConstants.dullColor(
                    color: ColorConstants.black, opacity: 0.5),
            child: Text(
              'Done',
              style: CustomTextStyles.customTextStyle(ColorConstants.white,
                  size: 18),
            )),
      ),
      appBar: AppBar(
          toolbarHeight: 40,
          title: Text(
            'Custom Location',
            style: CustomTextStyles.customBoldTextStyle(
                Theme.of(context).primaryColor,
                size: 16),
          ),
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
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
              child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child:
                      _data.isPrivate ? const Icon(Icons.lock) : const Icon(Icons.public)),
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
                        Theme.of(context).primaryColor.withOpacity(0.5),
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
                      Theme.of(context).primaryColor.withOpacity(0.5),
                  bgColor: Colors.transparent,
                  textColor: Theme.of(context).primaryColor,
                  initialValue: _data.accountName ?? '',
                  baseOffset: (_data.accountName ?? '').length,
                  height: 70,
                  expands: false,
                  maxLines: 1,
                  value: (str) => setState(() {
                    _data.accountName = str;
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
                        Theme.of(context).primaryColor.withOpacity(0.5),
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
                      Theme.of(context).primaryColor.withOpacity(0.5),
                  bgColor: Colors.transparent,
                  textColor: Theme.of(context).primaryColor,
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
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                            ),
                            child: SelectLocation(
                              callbackFunction: (finalData) {
                                print(
                                    '_finalData $finalData ${finalData.latLng}');
                                setState(() {
                                  _osmLocationModel = finalData;
                                });
                              },
                            ),
                          );
                        }).then((value) => _mapKey = UniqueKey());
                  },
                  value: (str) => setState(() {}),
                ),
              ),
              ((_osmLocationModel != null) &&
                      (_osmLocationModel!.latLng != null))
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
                                center: _osmLocationModel!.latLng!,
                                zoom: _osmLocationModel!.zoom!,
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
                                    point: _osmLocationModel!.latLng!,
                                    builder: (ctx) => Container(
                                        child: createMarker(
                                            diameterOfCircle:
                                                _osmLocationModel!.radius!)),
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
                                    SetupRoutes.push(
                                        context, Routes.PREVIEW_LOCATION,
                                        arguments: {
                                          'title': _data.accountName,
                                          'latLng': _osmLocationModel!.latLng!,
                                          'zoom': _osmLocationModel!.zoom!,
                                          'diameterOfCircle':
                                              _osmLocationModel!.radius!,
                                        });
                                  },
                                  icon: const Icon(Icons.fullscreen)),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
    // });
  }

  _updateLocation(OsmLocationModel osmData) async {
    if ((osmData.latitude == null) ||
        (osmData.latitude == 'null') ||
        (osmData.longitude == null) ||
        (osmData.longitude == 'null')) {
      _showToast('Location is required', isError: true);
      return;
    }

    // when field is being added, checking if title name is already taken or not
    if (widget.basicData == null) {
      if (Provider.of<UserPreview>(context, listen: false)
          .iskeyNameTaken(_data)) {
        _showToast('This title is already taken', isError: true);
        return;
      }
    } else if (widget.basicData!.accountName != _data.accountName) {
      if (Provider.of<UserPreview>(context, listen: false)
          .iskeyNameTaken(_data)) {
        _showToast('This title is already taken', isError: true);
        return;
      }
    }

    // LoadingDialog().show(text: 'Adding custom location');

    _data.type = CustomContentType.Location.name;
    if (!areBasicDataEqual(_data, widget.basicData ?? BasicData())) {
      // bool _previousKey = false;
      // if (widget.basicData != null) {
      //   _previousKey = widget.basicData!.accountName != _data.accountName;
      // }
      // var _res = await AtKeySetService().updateCustomFields(
      //     AtCategory.LOCATION.name, [_data],
      //     previousKey: _previousKey ? widget.basicData!.accountName : null);

      addCustomContent();

      if (widget.basicData != null) {
        if (widget.basicData!.accountName != _data.accountName) {
          Provider.of<UserPreview>(context, listen: false)
              .deletCustomField(AtCategory.LOCATION, widget.basicData!);
          // Provider.of<UserPreview>(context, listen: false)
          //     .sortCustomLocationFields();
        }
      }
    }
    widget.onSave?.call();
    // LoadingDialog().hide();
    Navigator.of(context).pop();
  }

  addCustomContent() {
    int? index;
    List<BasicData>? customFields =
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .customFields['LOCATION'];

    if (customFields == null) {
      customFields = [];
    } else if (widget.basicData != null) {
      index = customFields.indexWhere(
          (element) => element.accountName == widget.basicData!.accountName);
    }

    // setState(() {
    if (index != null) {
      // updates already existing key's value
      if ((widget.basicData != null) &&
          (widget.basicData!.accountName == _data.accountName)) {
        customFields[index] = _data;
      } else {
        customFields.insert(index, _data);
      }
    } else {
      customFields.add(_data);
    }
    Provider.of<UserPreview>(context, listen: false)
        .user()!
        .customFields['LOCATION'] = customFields;
    // });

    /////////////////////
    // FieldOrderService().updateSingleField(AtCategory.LOCATION,
    //     (widget.basicData?.accountName ?? ''), _data.accountName!);

    if (widget.basicData != null) {
      FieldOrderService().updateSingleField(AtCategory.LOCATION,
          (widget.basicData?.accountName ?? ''), _data.accountName!);
    } else {
      FieldOrderService().addNewField(
        AtCategory.LOCATION,
        _data.accountName!,
      );
    }
  }

  _showToast(String text, {bool isError = false, Color? bgColor}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor:
          isError ? ColorConstants.RED : bgColor ?? ColorConstants.black,
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 1),
    ));
  }
}
