import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_basic_info_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_media/desktop_profile_media_page.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_tabbar.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:flutter/material.dart';

class DesktopProfileDetailsPage extends StatefulWidget {
  final bool isMyProfile;
  final bool isEditable;

  const DesktopProfileDetailsPage({
    Key? key,
    required this.isMyProfile,
    required this.isEditable,
  }) : super(key: key);

  @override
  _DesktopProfileDetailsPageState createState() =>
      _DesktopProfileDetailsPageState();
}

class _DesktopProfileDetailsPageState extends State<DesktopProfileDetailsPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DesktopProfileDetailsPage> {
  late TabController _tabController;

  final categories = [
    AtCategory.IMAGE,
    AtCategory.DETAILS,
    AtCategory.ADDITIONAL_DETAILS,
    AtCategory.LOCATION,
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: DesktopDimens.paddingNormal,
              horizontal: DesktopDimens.paddingExtraLarge,
            ),
            child: DesktopTabBar(
              controller: _tabController,
              tabTitles: categories.map((e) => e.newLabel).toList(),
              spacer: DesktopDimens.paddingLarge,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: categories.map((e) => getWidget(e)).toList(),
            ),
          ),
        ],
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
