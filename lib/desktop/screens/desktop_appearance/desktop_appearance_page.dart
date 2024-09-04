import 'package:at_wavi_app/common_components/provider_callback.dart';
import 'package:at_wavi_app/desktop/screens/desktop_appearance/color_setting/desktop_color_setting_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_appearance/theme_setting/desktop_theme_setting_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_user_profile/desktop_user_profile_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/services/theme/inherited_app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_tabbar.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_welcome_widget.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:at_wavi_app/utils/text_styles.dart';

import 'desktop_appearance_model.dart';

class DesktopAppearancePage extends StatefulWidget {
  const DesktopAppearancePage({Key? key}) : super(key: key);

  @override
  _DesktopAppearancePageState createState() => _DesktopAppearancePageState();
}

class _DesktopAppearancePageState extends State<DesktopAppearancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  late DesktopAppearanceModel _model;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _pageController = PageController(initialPage: 0);

    final themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    );
    _model = DesktopAppearanceModel(
      isDarkMode:
          themeProvider.currentAtsignThemeData?.scaffoldBackgroundColor ==
              ColorConstants.black,
      color: themeProvider.currentAtsignThemeData?.highlightColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: DesktopDimens.paddingLarge),
              Container(
                child: const Center(
                  child: DesktopWelcomeWidget(),
                ),
              ),
              const SizedBox(height: DesktopDimens.paddingLarge),
              _buildTabBar(),
              Expanded(child: _buildPageView()),
              Container(
                padding: const EdgeInsets.only(
                  right: DesktopDimens.paddingLarge,
                  bottom: DesktopDimens.paddingLarge,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildReorderButton(),
                    const SizedBox(width: DesktopDimens.paddingNormal),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 80),
      child: DesktopTabBar(
        tabTitles: const [
          'Themes',
          'Colors',
        ],
        controller: _tabController,
        onTap: (index) {
          if (_pageController.page != index) {
            _pageController.jumpToPage(index);
          }
        },
      ),
    );
  }

  Widget _buildReorderButton() {
    return DesktopWhiteButton(
      title: 'Preview',
      onPressed: () {
        AppTheme appTheme = AppTheme.from(
          brightness: _model.isDarkMode ? Brightness.dark : Brightness.light,
          primaryColor: _model.color,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InheritedAppTheme(
                theme: appTheme, child: const DesktopUserProfilePage()),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return DesktopButton(
      title: 'Save & Publish',
      onPressed: () async {
        await providerCallback<ThemeProvider>(
          context,
          task: (provider) async {
            await provider.setTheme(
                themeColor:
                    _model.isDarkMode ? ThemeColor.Dark : ThemeColor.Light);
          },
          onError: (provider) {
            ScaffoldMessenger.of(scaffoldKey.currentContext!)
                .showSnackBar(SnackBar(
              backgroundColor: ColorConstants.RED,
              content: Text(
                'Publishing theme failed. Try again!',
                style: CustomTextStyles.customTextStyle(
                  ColorConstants.white,
                ),
              ),
            ));
          },
          showDialog: false,
          text: 'Publishing theme',
          taskName: (provider) => provider.SET_THEME,
          onSuccess: (provider) async {
            Navigator.pop(context);
          },
        );
        //
        await providerCallback<ThemeProvider>(
          context,
          task: (provider) async {
            await provider.setTheme(highlightColor: _model.color);
          },
          onError: (provider) {
            ScaffoldMessenger.of(scaffoldKey.currentContext!)
                .showSnackBar(SnackBar(
              backgroundColor: ColorConstants.RED,
              content: Text(
                'Publishing theme color failed. Try again!',
                style: CustomTextStyles.customTextStyle(
                  ColorConstants.white,
                ),
              ),
            ));
          },
          showDialog: false,
          text: 'Publishing color',
          taskName: (provider) => provider.SET_THEME,
          onSuccess: (provider) async {},
        );
      },
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        DesktopThemeSettingPage(),
        DesktopColorSettingPage(),
      ],
    );
  }
}
