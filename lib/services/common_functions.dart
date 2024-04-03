import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_contact/at_contact.dart';
import 'package:at_contacts_flutter/at_contacts_flutter.dart';
import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:at_wavi_app/common_components/create_marker.dart';
import 'package:at_wavi_app/common_components/custom_card.dart';
import 'package:at_wavi_app/common_components/custom_media_card.dart';
import 'package:at_wavi_app/common_components/empty_widget.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/services/twitter_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/at_key_constants.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonFunctions {
  CommonFunctions._internal();
  static CommonFunctions _instance = CommonFunctions._internal();
  factory CommonFunctions() => _instance;

  List<Widget> getCustomCardForFields(ThemeData _themeData, AtCategory category,
      {bool isPreview = false}) {
    return [...getAllfieldsCard(_themeData, category, isPreview: isPreview)];
  }

  bool isOsmDataPresent(Map _locationData) {
    if ((_locationData['latitude'] != null) &&
        (_locationData['longitude'] != null)) {
      return true;
    }

    return false;
  }

  List<Widget> getCustomLocationCards(ThemeData _themeData,
      {bool isPreview = false}) {
    List<String> fieldOrder =
        FieldNames().getFieldList(AtCategory.LOCATION, isPreview: isPreview);
    var customLocationWidgets = <Widget>[];

    User _currentUser = User.fromJson(
      json.decode(
        json.encode(
          User.toJson(isPreview
              ? Provider.of<UserPreview>(NavService.navKey.currentContext!,
                      listen: false)
                  .user()
              : Provider.of<UserProvider>(NavService.navKey.currentContext!,
                      listen: false)
                  .user!),
        ),
      ),
    );
    List<BasicData>? customFields =
        _currentUser.customFields[AtCategory.LOCATION.name];
    if (customFields == null) {
      customFields = [];
    }

    for (int i = 0; i < fieldOrder.length; i++) {
      var index =
          customFields.indexWhere((el) => el.accountName == fieldOrder[i]);
      if (index != -1 &&
          !customFields[index].accountName!.contains(AtText.IS_DELETED)) {
        var _osmModel = OsmLocationModel.fromJson(
            json.decode(_currentUser.customFields['LOCATION']?[index].value));

        if (_osmModel.latLng != null) {
          customLocationWidgets.add(
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: buildMap(
                _osmModel,
                _currentUser.customFields['LOCATION']?[index].accountName ?? '',
                _themeData,
              ),
            ),
          );
        }
      }
    }

    return customLocationWidgets;
  }

  List<Widget> getAllLocationCards(ThemeData _themeData,
      {bool isPreview = false}) {
    var locationWidgets = <Widget>[];

    User _currentUser = User.fromJson(json.decode(json.encode(User.toJson(
        isPreview
            ? Provider.of<UserPreview>(NavService.navKey.currentContext!,
                    listen: false)
                .user()
            : Provider.of<UserProvider>(NavService.navKey.currentContext!,
                    listen: false)
                .user!))));

    if ((_currentUser.location.value != null) &&
        (isOsmDataPresent(json.decode(_currentUser.location.value)))) {
      var _osmModel =
          OsmLocationModel.fromJson(json.decode(_currentUser.location.value));

      if (_osmModel.latLng != null) {
        locationWidgets.add(
          buildMap(
            _osmModel,
            _currentUser.locationNickName.value ?? '',
            _themeData,
          ),
        );
      }
    }

    locationWidgets
        .addAll(getCustomLocationCards(_themeData, isPreview: isPreview));

    return locationWidgets;
  }

  List<Widget> getDefinedFieldsCard(ThemeData _themeData, AtCategory category,
      {bool isPreview = false}) {
    var definedFieldsWidgets = <Widget>[];
    var userMap = User.toJson(isPreview
        ? Provider.of<UserPreview>(NavService.navKey.currentContext!,
                listen: false)
            .user()
        : Provider.of<UserProvider>(NavService.navKey.currentContext!,
                listen: false)
            .user!);
    List<String> fields = FieldNames().getFieldList(category);

    for (var field in userMap.entries) {
      if (field.key != null &&
          fields.contains(field.key) &&
          field.value != null &&
          field.value.value != null) {
        var widget = Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: CustomCard(
                  title: field.key,
                  subtitle: field.value.value,
                  themeData: _themeData,
                )),
            Divider(
                height: 1, color: _themeData.highlightColor.withOpacity(0.5))
          ],
        );

        definedFieldsWidgets.add(widget);
      }
    }
    return definedFieldsWidgets;
  }

  List<Widget> getCustomFieldsCard(ThemeData _themeData, AtCategory category,
      {bool isPreview = false}) {
    var customFieldsWidgets = <Widget>[];

    /// getting custom fields for [category]
    List<BasicData>? customFields = [];
    if (isPreview) {
      customFields = Provider.of<UserPreview>(NavService.navKey.currentContext!,
              listen: false)
          .user()!
          .customFields[category.name];
    } else {
      customFields = Provider.of<UserProvider>(
              NavService.navKey.currentContext!,
              listen: false)
          .user!
          .customFields[category.name];
    }

    if (customFields != null) {
      for (var basicData in customFields) {
        if (basicData.accountName != null && basicData.value != null) {
          var widget = Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: checkForCustomContentType(basicData, _themeData),
              ),
              Divider(
                  height: 1, color: _themeData.highlightColor.withOpacity(0.5))
            ],
          );
          customFieldsWidgets.add(
            widget,
          );
        }
      }
    }

    return customFieldsWidgets;
  }

  List<Widget> getAllfieldsCard(ThemeData _themeData, AtCategory category,
      {bool isPreview = false}) {
    var allFieldsWidget = <Widget>[];
    var userMap = User.toJson(isPreview
        ? Provider.of<UserPreview>(NavService.navKey.currentContext!,
                listen: false)
            .user()
        : Provider.of<UserProvider>(NavService.navKey.currentContext!,
                listen: false)
            .user!);

    List<BasicData>? customFields = [];
    if (isPreview) {
      customFields = Provider.of<UserPreview>(NavService.navKey.currentContext!,
              listen: false)
          .user()!
          .customFields[category.name];
    } else {
      customFields = Provider.of<UserProvider>(
              NavService.navKey.currentContext!,
              listen: false)
          .user!
          .customFields[category.name];
    }

    if (customFields == null) {
      customFields = [];
    }

    List<String> fields = [
      ...FieldNames().getFieldList(category, isPreview: isPreview)
    ];

    for (int i = 0; i < fields.length; i++) {
      // not displaying name in home tab fields
      if (fields[i] == FieldsEnum.FIRSTNAME.name ||
          fields[i] == FieldsEnum.LASTNAME.name) {
        continue;
      }
      bool isCustomField = false;
      BasicData basicData = BasicData();

      if (userMap.containsKey(fields[i])) {
        basicData = userMap[fields[i]];
        if (basicData.accountName == null) basicData.accountName = fields[i];
      } else {
        var index =
            customFields.indexWhere((el) => el.accountName == fields[i]);
        if (index != -1) {
          basicData = customFields[index];
          isCustomField = true;
        }
      }

      if (basicData.value == null || basicData.value == '') continue;

      Widget widget;
      if (!isCustomField) {
        bool isUrl;
        String url;
        if (Uri.parse(basicData.value).isAbsolute) {
          isUrl = true;
          url = basicData.value;
        } else {
          url = getUrl(basicData.displayingAccountName ?? "", basicData.value);
          isUrl = Uri.parse(url).isAbsolute;
        }
        widget = Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: CustomCard(
                  title: getTitle(basicData.accountName!),
                  subtitle: basicData.value,
                  themeData: _themeData,
                  url: url,
                  isUrl: isUrl,
                  isEmail: basicData.displayingAccountName == "Email",
                )),
            Divider(
                height: 1, color: _themeData.highlightColor.withOpacity(0.5))
          ],
        );
      } else {
        widget = Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: checkForCustomContentType(basicData, _themeData),
            ),
            Divider(
                height: 1, color: _themeData.highlightColor.withOpacity(0.5))
          ],
        );
      }

      allFieldsWidget.add(widget);
    }

    return allFieldsWidget;
  }

  Widget checkForCustomContentType(BasicData basicData, ThemeData _themeData) {
    Widget fieldCard = SizedBox();
    if (basicData.type == CustomContentType.Text.name ||
        basicData.type == CustomContentType.Number.name ||
        basicData.type == CustomContentType.Html.name) {
      fieldCard = CustomCard(
        title: basicData.accountName!,
        subtitle: basicData.value,
        themeData: _themeData,
      );
    } else if (basicData.type == CustomContentType.Image.name ||
        basicData.type == CustomContentType.Youtube.name ||
        basicData.type == CustomContentType.StorjImage.name) {
      fieldCard = CustomMediaCard(
        basicData: basicData,
        themeData: _themeData,
      );
    } else if (basicData.type == CustomContentType.Link.name) {
      fieldCard = CustomCard(
        title: basicData.accountName!,
        subtitle: basicData.value,
        themeData: _themeData,
        isUrl: true,
      );
    }
    return fieldCard;
  }

  List<Widget> getFeaturedTwitterCards(String username, ThemeData _themeData) {
    var twitterCards = <Widget>[];
    if (TwitetrService().searchedUserTweets[username] != null &&
        TwitetrService().searchedUserTweets[username]!.isNotEmpty) {
      int sliceIndex = TwitetrService().searchedUserTweets[username]!.length > 5
          ? 5
          : TwitetrService().searchedUserTweets[username]!.length;

      TwitetrService()
          .searchedUserTweets[username]!
          .sublist(0, sliceIndex)
          .forEach((tweet) {
        var twitterCard = Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: CustomCard(
                subtitle: tweet.text,
                themeData: _themeData,
              ),
            ),
            Divider(
              height: 1,
              color: _themeData.highlightColor.withOpacity(0.5),
            )
          ],
        );

        twitterCards.add(twitterCard);
      });
    } else {
      twitterCards.add(EmptyWidget(
        _themeData,
        limitedContent: true,
      ));
    }

    return twitterCards;
  }

  bool isFieldsPresentForCategory(AtCategory category,
      {bool isPreview = false}) {
    if (isPreview &&
        Provider.of<UserPreview>(NavService.navKey.currentContext!,
                    listen: false)
                .user() ==
            null) {
      return false;
    }
    if (!isPreview &&
        Provider.of<UserProvider>(NavService.navKey.currentContext!,
                    listen: false)
                .user ==
            null) {
      return false;
    }
    var userMap = User.toJson(isPreview
        ? Provider.of<UserPreview>(NavService.navKey.currentContext!,
                listen: false)
            .user()!
        : Provider.of<UserProvider>(NavService.navKey.currentContext!,
                listen: false)
            .user!);
    var isPresent = false;
    List<String> fields =
        FieldNames().getFieldList(category, isPreview: isPreview);

    for (var field in userMap.entries) {
      if (field.key != null &&
          fields.contains(field.key) &&
          field.value != null &&
          field.value.value != null &&
          field.value.value != '') {
        if (field.key == FieldsEnum.FIRSTNAME.name ||
            field.key == FieldsEnum.LASTNAME.name) {
          continue;
        }
        return true;
      }
    }

    if (!isPresent) {
      List<BasicData>? customFields = [];

      if (isPreview) {
        customFields = Provider.of<UserPreview>(
                NavService.navKey.currentContext!,
                listen: false)
            .user()!
            .customFields[category.name];
      } else {
        customFields = Provider.of<UserProvider>(
                NavService.navKey.currentContext!,
                listen: false)
            .user!
            .customFields[category.name];
      }

      if (customFields != null) {
        for (var basicData in customFields) {
          if (basicData.accountName != null &&
              basicData.value != null &&
              basicData.value != '') {
            return true;
          }
        }
      }
    }

    return isPresent;
  }

  bool isTwitterFeatured({bool isPreview = false}) {
    if (isPreview) {
      if (Provider.of<UserPreview>(NavService.navKey.currentContext!,
                      listen: false)
                  .user() !=
              null &&
          Provider.of<UserPreview>(NavService.navKey.currentContext!,
                      listen: false)
                  .user()!
                  .twitter
                  .value !=
              null) {
        return true;
      } else {
        return false;
      }
    }

    if (Provider.of<UserProvider>(NavService.navKey.currentContext!,
                    listen: false)
                .user !=
            null &&
        Provider.of<UserProvider>(NavService.navKey.currentContext!,
                    listen: false)
                .user!
                .twitter
                .value !=
            null) {
      return true;
    } else {
      return false;
    }
  }

  bool isInstagramFeatured({bool isPreview = false}) {
    if (isPreview) {
      if (Provider.of<UserPreview>(NavService.navKey.currentContext!,
                      listen: false)
                  .user() !=
              null &&
          Provider.of<UserPreview>(NavService.navKey.currentContext!,
                      listen: false)
                  .user()!
                  .instagram
                  .value !=
              null) {
        return true;
      } else {
        return false;
      }
    }

    if (Provider.of<UserProvider>(NavService.navKey.currentContext!,
                    listen: false)
                .user !=
            null &&
        Provider.of<UserProvider>(NavService.navKey.currentContext!,
                    listen: false)
                .user!
                .instagram
                .value !=
            null) {
      return true;
    } else {
      return false;
    }
  }

  getCachedContactImage(String atsign) {
    Uint8List image;
    AtContact contact = checkForCachedContactDetail(atsign);

    if (contact.tags != null && contact.tags!['image'] != null) {
      List<int> intList = contact.tags!['image'].cast<int>();
      image = Uint8List.fromList(intList);
      return image;
    }
  }

  Future<bool> checkAtsign(String? receiver) async {
    try {
      if (receiver == null) {
        return false;
      } else if (!receiver.contains('@')) {
        receiver = '@' + receiver;
      }
      var checkPresence = await AtClientManager.getInstance()
          .secondaryAddressFinder!
          .findSecondary(receiver);
      return checkPresence != null;
    } catch (e) {
      print("Error ======> ${e}");
      return false;
    }
  }

  showSnackBar(String msg) {
    ScaffoldMessenger.of(NavService.navKey.currentContext!)
        .showSnackBar(SnackBar(
      backgroundColor: ColorConstants.RED,
      content: Text(
        msg,
        style: CustomTextStyles.customTextStyle(
          ColorConstants.white,
        ),
      ),
    ));
  }

  buildMap(OsmLocationModel _osmLocationModel, String _locationNickname,
      ThemeData themeData) {
    if (_osmLocationModel.latLng == null) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _locationNickname,
          style: TextStyles.lightText(themeData.primaryColor.withOpacity(0.5),
              size: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 20),
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
                  // key: UniqueKey(),
                  options: MapOptions(
                    boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(0)),
                    center: _osmLocationModel.latLng!,
                    zoom: _osmLocationModel.zoom ?? 16,
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
                        point: _osmLocationModel.latLng!,
                        builder: (ctx) => Container(
                            child: createMarker(
                                diameterOfCircle:
                                    _osmLocationModel.radius ?? 100)),
                      )
                    ])
                  ],
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  height: 100,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ColorConstants.LIGHT_GREY,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            SetupRoutes.push(NavService.navKey.currentContext!,
                                Routes.PREVIEW_LOCATION,
                                arguments: {
                                  'title': _locationNickname,
                                  'latLng': _osmLocationModel.latLng!,
                                  'zoom': _osmLocationModel.zoom ?? 16,
                                  'diameterOfCircle':
                                      _osmLocationModel.radius ?? 100,
                                });
                          },
                          icon: Icon(Icons.fullscreen)),
                      IconButton(
                          onPressed: () async {
                            try {
                              await openMaps(_osmLocationModel.latLng!.latitude,
                                  _osmLocationModel.latLng!.longitude);
                            } catch (e) {
                              print(e);
                            }
                          },
                          icon: Icon(Icons.location_on_sharp)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> openMaps(double lat, double lang) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lang';
      await launch(url);
    } else if (Platform.isIOS) {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lang';
      url = 'comgooglemaps://?saddr=&daddr=$lat,$lang&directionsmode=driving';
      if (await canLaunch(url)) {
        await launch(url);
      } else if (await canLaunch(urlAppleMaps)) {
        await launch(urlAppleMaps);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      throw 'Could not launch : $url';
    }
  }
}

getTitle(String value) {
  var _valueOf = valueOf(value);
  if (_valueOf is FieldsEnum) {
    return _valueOf.hintText;
  } else {
    return value;
  }
}
