import 'package:at_wavi_app/common_components/provider_callback.dart';
import 'package:at_wavi_app/desktop/screens/desktop_location/desktop_location_preview_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_user_profile/desktop_user_profile_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/snackbar_utils.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_label_button.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_preview_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_welcome_widget.dart';
import 'package:at_wavi_app/model/basic_data_model.dart';
import 'package:at_wavi_app/model/osm_location_model.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_add_location/desktop_add_location_page.dart';
import 'desktop_profile_add_custom_field/desktop_profile_add_custom_field.dart';
import 'desktop_edit_basic_detail/desktop_edit_basic_detail_page.dart';
import 'desktop_reorder_basic_info/desktop_reorder_basic_info_page.dart';
import 'widgets/desktop_basic_info_widget.dart';
import 'widgets/desktop_empty_category_widget.dart';
import 'widgets/desktop_location_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DesktopProfileBasicInfoPage extends StatefulWidget {
  final AtCategory atCategory;
  final bool hideMenu;
  final bool showWelcome;
  final bool isMyProfile;
  final bool isEditable;

  const DesktopProfileBasicInfoPage({
    Key? key,
    required this.atCategory,
    this.hideMenu = false,
    this.showWelcome = true,
    required this.isMyProfile,
    required this.isEditable,
  }) : super(key: key);

  @override
  _DesktopProfileBasicInfoPageState createState() =>
      _DesktopProfileBasicInfoPageState();
}

class _DesktopProfileBasicInfoPageState
    extends State<DesktopProfileBasicInfoPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppTheme appTheme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: appTheme.backgroundColor,
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    //Get data
    User? user;
    if (widget.isMyProfile && widget.isEditable == false) {
      user = Provider.of<UserProvider>(context).user;
    } else {
      user = Provider.of<UserPreview>(context).user();
    }
    List<BasicDataModel> basicDataList = [];
    BasicData? locationData;
    BasicData? locationNicknameData;
    var userMap = User.toJson(user);
    List<BasicData>? customFields =
        user?.customFields[widget.atCategory.name] ?? [];

    var fields = <String>[];
    if (widget.isMyProfile && widget.isEditable == false) {
      fields = [
        ...FieldNames().getFieldList(widget.atCategory, isPreview: false)
      ];
    } else {
      fields = [
        ...FieldNames().getFieldList(widget.atCategory, isPreview: true)
      ];
    }

    for (int i = 0; i < fields.length; i++) {
      bool isCustomField = false;
      BasicData basicData = BasicData();

      if (userMap.containsKey(fields[i])) {
        basicData = userMap[fields[i]];
        basicData.accountName ??= fields[i];
        basicData.value ??= '';
      } else {
        var index =
            customFields.indexWhere((el) => el.accountName == fields[i]);
        if (index != -1) {
          basicData = customFields[index];
          isCustomField = true;
        }
      }

      if (basicData.accountName == null) {
        continue;
      }
      basicDataList.add(BasicDataModel(
        data: basicData,
        isCustomField: isCustomField,
      ));
    }
    //
    if (widget.atCategory == AtCategory.LOCATION) {
      locationNicknameData = user?.locationNickName;
      locationData = user?.location;
      basicDataList.removeWhere((element) {
        return element.data.accountName == locationNicknameData?.accountName ||
            element.data.accountName == locationData?.accountName;
      });
    }

    //Check empty data
    bool isEmptyData = true;
    if (widget.atCategory == AtCategory.LOCATION) {
      isEmptyData = (locationData?.value.toString() ?? '').isEmpty;
    }
    for (var element in basicDataList) {
      final value = element.data.value;
      if (value is String) {
        if (value.isNotEmpty && !element.data.isPrivate) {
          isEmptyData = false;
        }
      } else if (value != null && !element.data.isPrivate) {
        isEmptyData = false;
      }
    }

    if (isEmptyData) {
      return _buildEmptyWidget();
    } else {
      return _buildContentWidget(
        basicDataList: basicDataList,
        locationData: locationData,
        locationNicknameData: locationNicknameData,
      );
    }

    // //View
    // return Consumer<DesktopBasicDetailModel>(
    //   builder: (_, model, child) {
    //     if (model.isEmptyData) {
    //       return _buildEmptyWidget();
    //     } else {
    //       return _buildContentWidget(
    //         model.basicData,
    //       );
    //     }
    //   },
    // );
  }

  Widget _buildEmptyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (widget.showWelcome)
          Container(
            padding: const EdgeInsets.only(top: DesktopDimens.paddingLarge),
            child: DesktopWelcomeWidget(
              titlePage: widget.atCategory.titlePage,
            ),
          ),
        Expanded(
          child: Container(
            child: Center(
              child: DesktopEmptyCategoryWidget(
                atCategory: widget.atCategory,
                onAddDetailsPressed: widget.atCategory == AtCategory.LOCATION
                    ? _showAddLocation
                    : _showAddDetailPopup,
                showAddButton: widget.isEditable,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentWidget({
    required List<BasicDataModel> basicDataList,
    BasicData? locationData,
    BasicData? locationNicknameData,
  }) {
    final appTheme = AppTheme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: DesktopDimens.paddingExtraLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hideMenu == false)
            const SizedBox(height: DesktopDimens.paddingLarge),
          if (widget.hideMenu == false)
            Container(
              child: Row(
                children: [
                  Text(
                    widget.atCategory.label,
                    style: TextStyle(
                      color: appTheme.primaryTextColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (widget.atCategory != AtCategory.LOCATION)
                    DesktopIconLabelButton(
                      iconData: Icons.add_circle_outline_sharp,
                      label: 'Custom Content',
                      onPressed: _showAddCustomContent,
                    ),
                  if (widget.atCategory == AtCategory.LOCATION)
                    DesktopIconLabelButton(
                      iconData: Icons.add_circle_outline_sharp,
                      label: 'Add location',
                      onPressed: () {
                        _showAddLocation(isCustomFiled: true);
                      },
                    ),
                  if (widget.atCategory != AtCategory.LOCATION)
                    DesktopIconButton(
                      iconData: Icons.edit_rounded,
                      onPressed: _showAddDetailPopup,
                    ),
                  const SizedBox(width: 10),
                  DesktopPreviewButton(
                    onPressed: _showUserPreview,
                  ),
                ],
              ),
            ),
          if (widget.hideMenu == false)
            const SizedBox(height: DesktopDimens.paddingLarge),
          Expanded(
            child: SingleChildScrollView(
              child: _buildFieldsWidget(
                basicDataList: basicDataList,
                locationData: locationData,
                locationNicknameData: locationNicknameData,
              ),
            ),
          ),
          const SizedBox(height: DesktopDimens.paddingNormal),
          if (widget.isEditable)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.atCategory != AtCategory.LOCATION)
                  DesktopWhiteButton(
                    title: 'Reorder',
                    onPressed: _showReorderDetailPopup,
                  ),
                const SizedBox(width: 12),
                DesktopButton(
                  title: 'Save',
                  onPressed: _handleSaveAndNext,
                ),
              ],
            ),
          if (widget.isEditable) const SizedBox(height: DesktopDimens.paddingLarge),
        ],
      ),
    );
  }

  Widget _buildFieldsWidget({
    required List<BasicDataModel> basicDataList,
    BasicData? locationData,
    BasicData? locationNicknameData,
  }) {
    if (widget.atCategory == AtCategory.LOCATION) {
      return _buildLocationFieldWidget(
        basicDataList: basicDataList,
        locationData: locationData,
        locationNicknameData: locationNicknameData,
      );
    }

    final displayItem = basicDataList.where((element) {
      if (widget.isEditable) {
        return true;
      }
      if (element.data.value is String &&
          element.data.value.toString().trim().isEmpty) {
        return false;
      }
      if (element.data.isPrivate) {
        return false;
      }
      return element.data.value != null;
    }).toList();

    final appTheme = AppTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ListView.separated(
        controller: _scrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = displayItem[index];
          return Container(
            decoration: BoxDecoration(
              color: appTheme.secondaryBackgroundColor,
            ),
            child: DesktopBasicInfoWidget(
              data: item.data,
              isCustomField: item.isCustomField,
              isEditingMode: widget.isEditable,
              onDeletePressed: () {
                deleteData(item.data, widget.atCategory);
              },
              onEditPressed: () {
                _showEditCustomContent(item.data);
              },
              onPubicPressed: () {
                setPublicData(item.data, widget.atCategory);
              },
              onPrivatePressed: () {
                setPrivateData(item.data, widget.atCategory);
              },
              showMenu: widget.isEditable,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: DesktopDimens.paddingNormal),
            color: appTheme.secondaryBackgroundColor,
            child: Container(
              color: appTheme.separatorColor,
              height: DesktopDimens.dividerHeight,
            ),
          );
        },
        itemCount: displayItem.length,
      ),
    );
  }

  Widget _buildLocationFieldWidget({
    required List<BasicDataModel> basicDataList,
    BasicData? locationData,
    BasicData? locationNicknameData,
  }) {
    final appTheme = AppTheme.of(context);
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        BorderRadius? borderRadius;
        if (basicDataList.length == 1) {
          borderRadius = const BorderRadius.all(Radius.circular(10));
        } else {
          if (index == 1) {
            borderRadius = const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            );
          } else if (index == basicDataList.length) {
            borderRadius = const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            );
          }
        }
        if (index == 0) {
          return Container(
            decoration: BoxDecoration(
              color: appTheme.secondaryBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: DesktopLocationItemWidget(
              title: locationNicknameData?.value ?? '',
              location: locationData?.value as String?,
              isCustomField: false,
              onEditPressed: () {
                _showAddLocation(
                  isCustomFiled: false,
                  isEditing: true,
                  location: locationData,
                  locationNickname: locationNicknameData,
                );
              },
              showMenu: widget.isEditable,
              onPreviewPressed: (location) {
                _showLocationPreview(
                    locationNicknameData?.value ?? '', location);
              },
            ),
          );
        }

        final item = basicDataList[index - 1];
        return Container(
          decoration: BoxDecoration(
            color: appTheme.secondaryBackgroundColor,
            borderRadius: borderRadius,
          ),
          child: DesktopLocationItemWidget(
            title: item.data.accountName,
            location: item.data.value,
            isCustomField: true,
            onDeletePressed: () {
              deleteData(item.data, widget.atCategory);
            },
            onEditPressed: () {
              _showAddLocation(
                isCustomFiled: true,
                isEditing: true,
                location: item.data,
              );
            },
            showMenu: widget.isEditable,
            onPreviewPressed: (location) {
              _showLocationPreview(item.data.accountName, location);
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        if (index == 0) {
          return Container(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              'More Locations',
              style: TextStyle(
                  color: appTheme.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          color: appTheme.secondaryBackgroundColor,
          child: Container(
            color: appTheme.separatorColor,
            height: DesktopDimens.dividerHeight,
          ),
        );
      },
      itemCount: basicDataList.length + 1,
    );
  }

  void _showAddDetailPopup() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopEditBasicDetailPage(
          atCategory: widget.atCategory,
        ),
      ),
    );
  }

  void _showUserPreview() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DesktopUserProfilePage(),
      ),
    );
  }

  void _showAddCustomContent() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopProfileAddCustomField(
          atCategory: widget.atCategory,
        ),
      ),
    );
  }

  void _showEditCustomContent(BasicData data) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopProfileAddCustomField(
          atCategory: widget.atCategory,
          data: data,
        ),
      ),
    );
  }

  void _showAddLocation({
    bool isCustomFiled = false,
    bool isEditing = false,
    BasicData? location,
    BasicData? locationNickname,
  }) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopAddLocationPage(
          isEditing: isEditing,
          isCustomFiled: isCustomFiled,
          location: location,
          locationNickname: locationNickname,
        ),
      ),
    );
  }

  void _showReorderDetailPopup() async {
    await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopReorderBasicDetailPage(
          atCategory: widget.atCategory,
        ),
      ),
    );
  }

  void _showLocationPreview(String? title, OsmLocationModel location) {
    final latLng = location.latLng;
    final radius = location.radius ?? 10;
    final zoom = location.zoom ?? 14;
    if (latLng != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DesktopLocationPreviewPage(
            latLng: latLng,
            diameterOfCircle: radius,
            zoom: zoom,
            title: title ?? '',
          ),
        ),
      );
    } else if ((title ?? '').isNotEmpty) {
      try {
        launchUrl(Uri.parse('https://www.google.com/maps/place/$title'));
      } catch (e) {}
    }
  }

  void _handleSaveAndNext() async {
    await providerCallback<UserProvider>(
      context,
      task: (provider) async {
        await provider.saveUserData(
            Provider.of<UserPreview>(context, listen: false).user()!);
      },
      onError: (provider) {},
      showDialog: false,
      text: 'Saving user data',
      taskName: (provider) => provider.UPDATE_USER,
      onSuccess: (provider) async {
        // Provider.of<DesktopEditProfileModel>(context, listen: false)
        //     .jumpNextPage();
        SnackBarUtils.show(
          context: context,
          message: 'Your changes have been saved!',
        );
      },
    );
  }

  void deleteData(BasicData basicData, AtCategory atCategory) {
    UserPreview().deletCustomField(atCategory, basicData);
    setState(() {});
  }

  void setPublicData(BasicData basicData, AtCategory atCategory) {
    basicData.isPrivate = false;
    setState(() {});
  }

  void setPrivateData(BasicData basicData, AtCategory atCategory) {
    basicData.isPrivate = true;
    setState(() {});
  }
}
