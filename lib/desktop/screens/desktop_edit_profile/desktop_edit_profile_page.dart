import 'package:at_wavi_app/common_components/provider_callback.dart';
import 'package:at_wavi_app/desktop/screens/desktop_appearance/desktop_appearance_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_edit_profile/desktop_profile_picture/desktop_profile_picture_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_basic_info_page.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_media/desktop_profile_media_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_logo.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/snackbar_utils.dart';
import 'desktop_edit_profile_model.dart';
import 'desktop_side_menu.dart';
import 'widgets/desktop_side_menu_widget.dart';

class DesktopEditProfilePage extends StatefulWidget {
  const DesktopEditProfilePage({Key? key}) : super(key: key);

  @override
  _DesktopEditProfilePageState createState() => _DesktopEditProfilePageState();
}

class _DesktopEditProfilePageState extends State<DesktopEditProfilePage> {
  late DesktopEditProfileModel _model;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    _model = DesktopEditProfileModel();
    super.initState();
    _model.addListener(() {
      final index = DesktopSideMenu.values.indexOf(_model.selectedMenu);
      if (index >= 0) {
        _pageController.jumpToPage(index);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => _model,
      child: Scaffold(
        body: Row(
          children: [
            buildSideMenus(),
            Container(
              width: 1,
              height: double.infinity,
              color: appTheme.separatorColor,
            ),
            Expanded(
              child: buildContentPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSideMenus() {
    final appTheme = AppTheme.of(context);
    return Consumer<DesktopEditProfileModel>(
      builder: (context, provider, child) {
        return Container(
          width: DesktopDimens.sideMenuWidth,
          margin: const EdgeInsets.only(right: 1),
          decoration: BoxDecoration(
            color: appTheme.primaryLighterColor,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    const Center(
                      child: DesktopLogo(),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: DesktopIconButton(
                        iconData: Icons.close_rounded,
                        onPressed: _handleClosePressed,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: DesktopSideMenu.values.length,
                  itemBuilder: (context, index) {
                    final menu = DesktopSideMenu.values[index];
                    return DesktopSideMenuWidget(
                      menu: menu,
                      isSelected: menu == _model.selectedMenu,
                      onPressed: () {
                        _model.changeMenu(menu);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildContentPage() {
    return Container(
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: DesktopSideMenu.values.map((e) {
          switch (e) {
            case DesktopSideMenu.profile:
              return DesktopProfilePicturePage();
            case DesktopSideMenu.media:
              // return DesktopMediaPage();
              return const DesktopProfileMediaPage(
                isMyProfile: true,
                isEditable: true,
              );
            case DesktopSideMenu.basicDetails:
              return const DesktopProfileBasicInfoPage(
                atCategory: AtCategory.DETAILS,
                isMyProfile: true,
                isEditable: true,
              );
            case DesktopSideMenu.additionalDetails:
              return const DesktopProfileBasicInfoPage(
                atCategory: AtCategory.ADDITIONAL_DETAILS,
                isMyProfile: true,
                isEditable: true,
              );
            case DesktopSideMenu.location:
              return const DesktopProfileBasicInfoPage(
                atCategory: AtCategory.LOCATION,
                isMyProfile: true,
                isEditable: true,
              );
            case DesktopSideMenu.socialChannel:
              return const DesktopProfileBasicInfoPage(
                atCategory: AtCategory.SOCIAL,
                isMyProfile: true,
                isEditable: true,
              );
            case DesktopSideMenu.gameChannel:
              return const DesktopProfileBasicInfoPage(
                atCategory: AtCategory.GAMER,
                isMyProfile: true,
                isEditable: true,
              );
            // case DesktopSideMenu.featuredChannel:
            //   return DesktopProfileBasicInfoPage(atCategory: AtCategory.FEATURED);
            case DesktopSideMenu.appearance:
              return const DesktopAppearancePage();
            default:
              return Container(color: Colors.green);
          }
        }).toList(),
      ),
    );
  }

  void _handleClosePressed() async {
    var changes = _calculateChanges();
    if (changes) {
      var res = await _confirmationDialog();
      if (res == true) {
        await _saveButtonCall();
      } else {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  _saveButtonCall() async {
    /// Changes theme
    await providerCallback<UserProvider>(
      context,
      task: (provider) async {
        await provider.saveUserData(Provider.of<UserPreview>(context, listen: false).user()!);
      },
      onError: (provider) {},
      showDialog: false,
      text: 'Saving data',
      taskName: (provider) => provider.UPDATE_USER,
      onSuccess: (provider) async {
        await SnackBarUtils.show(
          context: context,
          message: 'Your changes have been saved!',
        );
        Navigator.of(context).pop();
      },
    );
  }

  // returns [true] if changes exist
  bool _calculateChanges() {
    if (!User.isEqual(Provider.of<UserProvider>(context, listen: false).user!,
        Provider.of<UserPreview>(context, listen: false).user()!)) {
      return true;
    }
    if (FieldOrderService().previewOrders.toString() != FieldOrderService().fieldOrders.toString()) {
      return true;
    }
    return false;
  }

  Future<bool?> _confirmationDialog() async {
    bool? value;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SizedBox(
          width: DesktopDimens.dialogWidth,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(DesktopDimens.paddingNormal),
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Do you want to save your changes?',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DesktopWhiteButton(
                              title: 'Cancel',
                              onPressed: () {
                                value = false;
                                Navigator.of(context).pop();
                              }),
                          const SizedBox(width: DesktopDimens.paddingNormal),
                          DesktopButton(
                              title: 'Save',
                              onPressed: () {
                                value = true;
                                Navigator.of(context).pop();
                              })
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
    return value;
  }
}
