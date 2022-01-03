import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_basic_info_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_media/desktop_profile_media_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/dialog_utils.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_tabbar.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_basic_detail/desktop_basic_detail_page.dart';
import 'desktop_profile_details_model.dart';
import 'desktop_media/desktop_media_page.dart';

class DesktopProfileDetailsPage extends StatefulWidget {
  final bool isMyProfile;
  final bool isEditable;

  DesktopProfileDetailsPage({
    Key? key,
    required this.isMyProfile,
    required this.isEditable,
  }) : super(key: key);

  _DesktopProfileDetailsPageState _desktopDetailsPageState =
      _DesktopProfileDetailsPageState();

  @override
  _DesktopProfileDetailsPageState createState() => _desktopDetailsPageState;

  Future showReOrderTabsPopUp() async {
    await _desktopDetailsPageState.showReOrderTabsPopUp();
  }

// Future addMedia() async {
//   await _desktopDetailsPageState.addMedia();
// }
//
// Future addFieldToBasicDetail() async {
//   await _desktopDetailsPageState.addFieldToBasicDetail();
// }
//
// Future addFieldToAdditionalDetail() async {
//   await _desktopDetailsPageState.addFieldToAdditionalDetail();
// }
//
// Future addLocation() async {
//   await _desktopDetailsPageState.addLocation();
// }
}

class _DesktopProfileDetailsPageState extends State<DesktopProfileDetailsPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DesktopProfileDetailsPage> {
  late TabController _tabController;
  late DesktopProfileDetailsModel _model;

  // late DesktopMediaPage desktopMediaPage;
  // late DesktopBasicDetailPage desktopBasicDetailPage;
  // late DesktopBasicDetailPage desktopAdditionalDetailPage;
  // late DesktopBasicDetailPage desktopLocationPage;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    // desktopMediaPage = DesktopMediaPage();
    // desktopBasicDetailPage = DesktopBasicDetailPage(
    //   atCategory: AtCategory.DETAILS,
    // );
    // desktopAdditionalDetailPage = DesktopBasicDetailPage(
    //   atCategory: AtCategory.ADDITIONAL_DETAILS,
    // );
    // desktopLocationPage = DesktopBasicDetailPage(
    //   atCategory: AtCategory.LOCATION,
    // );
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  Future showReOrderTabsPopUp() async {
    if (this.mounted) {
      await showReOderTabsPopUp(
        context,
        (fields) {
          /// Update Fields after reorder
          _model.updateField(fields);
        },
      );
    }
  }

  // Future addMedia() async {
  //   await desktopMediaPage.addMedia();
  // }
  //
  // Future addFieldToBasicDetail() async {
  //   await desktopBasicDetailPage.addField();
  // }
  //
  // Future addFieldToAdditionalDetail() async {
  //   await desktopAdditionalDetailPage.addField();
  // }
  //
  // Future addLocation() async {
  //   await desktopLocationPage.addField();
  // }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopProfileDetailsModel(userPreview: userPreview);
        return _model;
      },
      child: Container(
        child: Consumer<DesktopProfileDetailsModel>(
          builder: (_, model, child) {
            return model.fields.isEmpty
                ? Container()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: DesktopDimens.paddingNormal,
                          horizontal: DesktopDimens.paddingExtraLarge,
                        ),
                        child: DesktopTabBar(
                          controller: _tabController,
                          tabTitles: model.fields,
                          spacer: DesktopDimens.paddingLarge,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            AtCategory.IMAGE,
                            AtCategory.DETAILS,
                            AtCategory.ADDITIONAL_DETAILS,
                            AtCategory.LOCATION,
                          ].map((e) => getWidget(e)).toList(),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget getWidget(AtCategory atCategory) {
    switch (atCategory) {
      case AtCategory.IMAGE:
        return DesktopProfileMediaPage(
          hideMenu: true,
          showWelcome: false,
          isMyProfile: widget.isMyProfile,
          isEditable: widget.isEditable,
        );
      case AtCategory.DETAILS:
        return DesktopProfileBasicInfoPage(
          atCategory: AtCategory.DETAILS,
          hideMenu: true,
          showWelcome: false,
          isMyProfile: widget.isMyProfile,
          isEditable: widget.isEditable,
        );
      case AtCategory.ADDITIONAL_DETAILS:
        return DesktopProfileBasicInfoPage(
          atCategory: AtCategory.ADDITIONAL_DETAILS,
          hideMenu: true,
          showWelcome: false,
          isMyProfile: widget.isMyProfile,
          isEditable: widget.isEditable,
        );
      case AtCategory.LOCATION:
        return DesktopProfileBasicInfoPage(
          atCategory: AtCategory.LOCATION,
          hideMenu: true,
          showWelcome: false,
          isMyProfile: widget.isMyProfile,
          isEditable: widget.isEditable,
        );
      default:
        return Container();
    }
  }
}
