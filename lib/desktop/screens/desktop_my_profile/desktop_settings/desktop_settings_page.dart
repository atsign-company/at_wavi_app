import 'dart:typed_data';

import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_common_flutter/at_common_flutter.dart';
import 'package:at_contacts_flutter/widgets/custom_circle_avatar.dart';
import 'package:at_wavi_app/common_components/contact_initial.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/screens/options.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/change_privacy_service.dart';
import 'package:at_wavi_app/services/common_functions.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'desktop_switch_account/desktop_switch_account_page.dart';
import 'widgets/desktop_setting_switch_widget.dart';
import 'widgets/desktop_setting_widget.dart';

class DesktopSettingsPage extends StatefulWidget {
  const DesktopSettingsPage({Key? key}) : super(key: key);

  @override
  _DesktopSettingsPageState createState() => _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends State<DesktopSettingsPage> {
  bool enableShareStSign = false;
  final KeyChainManager _keyChainManager = KeyChainManager.getInstance();

  @override
  void initState() {
    getShareAtSign();
    super.initState();
  }

  void getShareAtSign() async {
    enableShareStSign = await _keyChainManager.isUsingSharedStorage() ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final isPrivateAccount = Provider.of<UserProvider>(context).user?.allPrivate ?? false;
    final isUpdating = Provider.of<SetPrivateState>(context).isLoading;

    return Container(
      width: DesktopDimens.sideMenuWidth,
      color: appTheme.backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: DesktopDimens.paddingLarge),
          DesktopSettingSwitchWidget(
            prefixIcon: Icons.lock_rounded,
            title: "Make all information private",
            isOn: isPrivateAccount,
            isUpdating: isUpdating,
            onChanged: (isOn) async {
              final user = Provider.of<UserProvider>(context, listen: false).user;
              if (user != null) {
                await ChangePrivacyService().setAllPrivate(isOn, user);
              }
            },
          ),
          DesktopSettingSwitchWidget(
            prefixIcon: Icons.share_outlined,
            title: "Sharing atSign",
            isOn: enableShareStSign,
            isUpdating: false,
            onChanged: (check) async {
              if (check) {
                _keyChainManager.enableUsingSharedStorage();
              } else {
                _keyChainManager.disableUsingSharedStorage();
              }

              setState(() {
                enableShareStSign = check;
              });
            },
          ),
          // DesktopSettingSwitchWidget(
          //   prefixIcon: Icons.remove_red_eye_rounded,
          //   title: "Exclude your @wavi from search results",
          // ),
          // DesktopSettingWidget(
          //   prefixIcon: Icons.south_west_rounded,
          //   title: "Import",
          // ),
          // DesktopSettingWidget(
          //   prefixIcon: Icons.north_east_rounded,
          //   title: "Export",
          // ),
          DesktopSettingWidget(
            prefixIcon: Icons.library_books_outlined,
            title: "Terms and Condition",
            onTapped: onTOSTapped,
          ),
          DesktopSettingWidget(
            prefixIcon: Icons.forum,
            title: "FAQs",
            onTapped: onFAQTapped,
          ),
          DesktopSettingWidget(
            prefixIcon: Icons.delete,
            title: "Delete atSign",
            onTapped: onDeleteAccountTapped,
          ),
          DesktopSettingWidget(
            prefixIcon: Icons.logout,
            title: "Switch atSign",
            onTapped: onSwitchAccountTapped,
          ),
        ],
      ),
    );
  }

  void onTOSTapped() {
    launch('${MixedConstants.WEBSITE_URL}/terms-conditions');
  }

  void onFAQTapped() {
    launch('${MixedConstants.WEBSITE_URL}/faqs');
  }

  void onSwitchAccountTapped() async {
    var atSignList = await KeychainUtil.getAtsignList();
    final result = await showModalBottomSheet(
      context: NavService.navKey.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (context) => DesktopSwitchAccountPage(
        atSignList: atSignList ?? [],
        onSuccess: () {
          Navigator.pop(context, 'atSign_changed');
          // SetupRoutes.pushAndRemoveAll(NavService.navKey.currentContext!,
          //     DesktopRoutes.DESKTOP_MY_PROFILE);
        },
      ),
    );
    if (result == 'atSign_changed') {
      Navigator.pop(context);
    }
  }

  void onDeleteAccountTapped() async {
    var atSignList = await KeychainUtil.getAtsignList();
    BackendService backendService = BackendService();
    final appTheme = AppTheme.of(context);

    final result = await showDialog(
      context: NavService.navKey.currentContext!,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(DesktopDimens.paddingNormal),
                  decoration: BoxDecoration(
                    color: appTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Delete atSign',
                          style: TextStyle(
                            color: appTheme.primaryTextColor,
                            fontSize: 20.toFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: atSignList?.length ?? 0,
                        itemBuilder: (context, index) {
                          Uint8List? image = CommonFunctions().getCachedContactImage(atSignList![index]);
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              await backendService.resetDevice(
                                [
                                  atSignList[index],
                                ],
                              );
                              await backendService.onboardNextAtsign(
                                isCheckDesktop: true,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  image != null
                                      ? CustomCircleAvatar(
                                          byteImage: image,
                                          nonAsset: true,
                                          size: 40,
                                        )
                                      : ContactInitial(
                                          initials: atSignList[index],
                                          size: 40,
                                        ),
                                  const SizedBox(width: 10),
                                  Text(
                                    atSignList[index],
                                    style: TextStyle(
                                      fontSize: 15.toFont,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result == 'atSign_delete') {
      Navigator.pop(context);
    }
  }
}
