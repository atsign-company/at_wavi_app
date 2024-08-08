import 'package:at_wavi_app/desktop/screens/desktop_tutorial/desktop_tutorial_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/shared_preferences_utils.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:flutter/material.dart';
import 'desktop_profile_channels/desktop_profile_channels_page.dart';
import 'desktop_profile_details/desktop_profile_details_page.dart';
import 'widgets/desktop_profile_tabbar.dart';

class DesktopProfileDataPage extends StatefulWidget {
  final VoidCallback? onSearchPressed;
  final VoidCallback? onSettingPressed;
  final bool isMyProfile;
  final bool isEditable;

  const DesktopProfileDataPage({
    Key? key,
    this.onSearchPressed,
    this.onSettingPressed,
    required this.isMyProfile,
    required this.isEditable,
  }) : super(key: key);

  @override
  _DesktopProfileDataPageState createState() => _DesktopProfileDataPageState();
}

class _DesktopProfileDataPageState extends State<DesktopProfileDataPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    super.initState();
    _showTutorial();
  }

  void _showTutorial() async {
    final isFirstTimeOpen = await SharedPreferencesUtils.isFirstTimeOpen();
    if (isFirstTimeOpen) {
      _showTutorialDialog();
    }
    await SharedPreferencesUtils.setFirstTimeOpen(isFirstTime: false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      color: appTheme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: DesktopDimens.paddingLarge),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesktopDimens.paddingLarge,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 1, child: Container()),
                DesktopProfileTabBar(
                  onTap: (index) {
                    _pageController.jumpToPage(index);
                  },
                  tab: _tabController,
                ),
                Expanded(
                  flex: 1,
                  child: widget.isMyProfile
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DesktopIconButton(
                              iconData: Icons.search,
                              iconColor: appTheme.primaryTextColor,
                              backgroundColor:
                                  appTheme.secondaryBackgroundColor,
                              onPressed: () {
                                widget.onSearchPressed?.call();
                              },
                            ),
                            const SizedBox(width: DesktopDimens.paddingSmall),
                            // if (widget.isMyProfile &&
                            //     widget.isEditable == false)
                            //   RotationTransition(
                            //     turns: _animation,
                            //     child: DesktopIconButton(
                            //       iconData: Icons.sync,
                            //       iconColor: appTheme.primaryTextColor,
                            //       backgroundColor:
                            //           appTheme.secondaryBackgroundColor,
                            //       onPressed: _syncData,
                            //     ),
                            //   ),
                            const SizedBox(width: DesktopDimens.paddingSmall),
                            DesktopIconButton(
                              iconData: Icons.more_vert,
                              iconColor: appTheme.primaryTextColor,
                              backgroundColor:
                                  appTheme.secondaryBackgroundColor,
                              onPressed: () {
                                widget.onSettingPressed?.call();
                              },
                            ),
                          ],
                        )
                      : Container(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: DesktopDimens.paddingNormal,
          ),
          Expanded(
            child: Stack(
              children: [
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) {},
                  controller: _pageController,
                  children: [
                    DesktopProfileDetailsPage(
                      isMyProfile: widget.isMyProfile,
                      isEditable: widget.isEditable,
                    ),
                    DesktopProfileChannelsPage(
                      isMyProfile: widget.isMyProfile,
                      isEditable: widget.isEditable,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTutorialDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const DesktopTutorialPage(),
    );
  }

  void _syncData() async {
    _controller.reset();
    _controller.forward();
    BackendService().showSyncSnackbar();
    setState(() {});
  }
}
