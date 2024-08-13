import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_basic_info_page.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_tabbar.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:flutter/material.dart';

class DesktopProfileChannelsPage extends StatefulWidget {
  final bool isMyProfile;
  final bool isEditable;

  const DesktopProfileChannelsPage({
    Key? key,
    required this.isMyProfile,
    required this.isEditable,
  }) : super(key: key);

  @override
  _DesktopProfileChannelsPageState createState() =>
      _DesktopProfileChannelsPageState();
}

class _DesktopProfileChannelsPageState extends State<DesktopProfileChannelsPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DesktopProfileChannelsPage> {
  late TabController _tabController;

  final categories = [
    AtCategory.SOCIAL,
    AtCategory.GAMER,
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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

  Widget getWidget(AtCategory field) {
    switch (field) {
      case AtCategory.SOCIAL:
        return DesktopProfileBasicInfoPage(
          atCategory: AtCategory.SOCIAL,
          hideMenu: true,
          showWelcome: false,
          isMyProfile: widget.isMyProfile,
          isEditable: widget.isEditable,
        );
      case AtCategory.GAMER:
        return DesktopProfileBasicInfoPage(
          atCategory: AtCategory.GAMER,
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
