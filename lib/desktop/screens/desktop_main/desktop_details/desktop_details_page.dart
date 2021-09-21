import 'package:at_wavi_app/desktop/screens/desktop_main/desktop_details/desktop_additional_detail/desktop_additional_detail_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_main/desktop_details/desktop_basic_detail/desktop_basic_detail_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_main/desktop_details/desktop_location/desktop_location_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_main/desktop_details/desktop_media/desktop_media_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:flutter/material.dart';

import '../../../../app.dart';

class DesktopDetailsPage extends StatefulWidget {
  DesktopDetailsPage({Key? key}) : super(key: key);

  _DesktopDetailsPageState _desktopDetailsPageState =
      _DesktopDetailsPageState();

  @override
  _DesktopDetailsPageState createState() => _desktopDetailsPageState;

  Future updateBasicDetailFields() async {
    await _desktopDetailsPageState.updateBasicDetailFields();
  }

  Future updateAdditionalDetailFields() async {
    await _desktopDetailsPageState.updateAdditionalDetailFields();
  }
}

class _DesktopDetailsPageState extends State<DesktopDetailsPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<DesktopDetailsPage> {
  late TabController _tabController;

  DesktopMediaPage desktopMediaPage = DesktopMediaPage();
  DesktopBasicDetailPage desktopBasicDetailPage = DesktopBasicDetailPage();
  DesktopAdditionalDetailPage desktopAdditionalDetailPage =
      DesktopAdditionalDetailPage();
  DesktopLocationPage desktopLocationPage = DesktopLocationPage();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  Future updateBasicDetailFields() async {
    await desktopBasicDetailPage.updateFields();
  }

  Future updateAdditionalDetailFields() async {
    await desktopAdditionalDetailPage.updateFields();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3,
                color: appTheme.primaryColor,
              ),
              insets: EdgeInsets.only(
                left: 0,
                right: 8,
                bottom: 4,
              ),
            ),
            //    indicatorColor: appTheme.primaryColor,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelStyle: TextStyle(
              fontSize: 13,
              color: appTheme.borderColor,
              fontFamily: 'Inter',
            ),
            labelStyle: TextStyle(
              fontSize: 13,
              color: appTheme.primaryTextColor,
              fontFamily: 'Inter',
            ),
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  Strings.desktop_media,
                ),
              ),
              Tab(
                child: Text(
                  Strings.desktop_basic_details,
                ),
              ),
              Tab(
                child: Text(
                  Strings.desktop_additional_details,
                ),
              ),
              Tab(
                child: Text(
                  Strings.desktop_location,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                desktopMediaPage,
                desktopBasicDetailPage,
                desktopAdditionalDetailPage,
                desktopLocationPage,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          currentScreen = '';
          break;
        case 1:
          currentScreen = AtCategory.DETAILS.name;
          break;
        case 2:
          currentScreen = AtCategory.ADDITIONAL_DETAILS.name;
          break;
        case 3:
          currentScreen = '';
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
