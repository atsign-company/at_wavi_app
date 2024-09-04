import 'dart:typed_data';

import 'package:at_backupkey_flutter/widgets/backup_key_widget.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_wavi_app/common_components/loading_widget.dart';
import 'package:at_wavi_app/common_components/person_horizontal_tile.dart';
import 'package:at_wavi_app/common_components/qr_scanner.dart';
import 'package:at_wavi_app/common_components/switch_at_sign.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/change_privacy_service.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/colors.dart' as WaviColors;
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/images.dart';
import 'package:at_wavi_app/utils/text_constants.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:at_follows_flutter/services/size_config.dart';
import 'package:at_follows_flutter/utils/color_constants.dart'
    as follows_color_constants;

class Options extends StatefulWidget {
  final String? name;
  final Uint8List? image;

  const Options({Key? key, this.name, this.image}) : super(key: key);
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool _allPrivate = false;
  late User _user;
  ThemeData? _themeData;
  bool enableShareStSign = false;
  final KeyChainManager _keyChainManager = KeyChainManager.getInstance();

  @override
  void initState() {
    // for follows package
    follows_color_constants.ColorConstants.appColor =
        const Color.fromARGB(255, 0, 183, 184);
    follows_color_constants.ColorConstants.darkTheme = false;
    //
    getShareAtSign();
    updateAllPrivateKey();
    _getThemeData();
    super.initState();
  }

  void getShareAtSign() async {
    enableShareStSign = await _keyChainManager.isUsingSharedStorage() ?? false;
    setState(() {});
  }

  _getThemeData() async {
    _themeData =
        await Provider.of<ThemeProvider>(context, listen: false).getTheme();

    if (mounted) {
      setState(() {});
    }
  }

  updateAllPrivateKey() async {
    _user = Provider.of<UserProvider>(context, listen: false).user!;
    if (mounted) {
      setState(() {
        _allPrivate = _user.allPrivate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // for follows package

    if (_themeData == null) {
      return const CircularProgressIndicator();
    }

    return Container(
      color: _themeData!.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomPersonHorizontalTile(
              title: widget.name ??
                  BackendService().atClientInstance.getCurrentAtSign(),
              subTitle: BackendService().atClientInstance.getCurrentAtSign(),
              textColor: _themeData!.primaryColor,
              image: widget.image?.toList(),
            ),
            // SizedBox(height: 15.toHeight),
            // Divider(height: 1),
            // SizedBox(
            //   height: 38,
            //   width: SizeConfig().screenWidth,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       Padding(
            //         padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 0.0),
            //         child: Icon(Icons.share_outlined, size: 25),
            //       ),
            //       Expanded(
            //         child: Padding(
            //           padding: EdgeInsets.fromLTRB(8.0, 15.0, 0.0, 0.0),
            //           child: Text(
            //             'Sharing atSign',
            //             style: TextStyles.lightText(_themeData!.primaryColor),
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: EdgeInsets.fromLTRB(8.0, 15.0, 0.0, 0.0),
            //         child: Transform.scale(
            //           alignment: Alignment.center,
            //           scale: 0.7,
            //           child: CupertinoSwitch(
            //             activeColor: WaviColors.ColorConstants.black,
            //             value: enableShareStSign,
            //             onChanged: (value) async {
            //               if (value) {
            //                 _keyChainManager.enableUsingSharedStorage();
            //               } else {
            //                 _keyChainManager.disableUsingSharedStorage();
            //               }

            //               setState(() {
            //                 enableShareStSign = value;
            //               });
            //             },
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 15.toHeight),
            const Divider(height: 1),
            SizedBox(height: 15.toHeight),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const QRScanner()));
              },
              child: Row(
                children: <Widget>[
                  const Icon(Icons.qr_code_scanner, size: 25),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Scan QR Code',
                        style: TextStyles.lightText(_themeData!.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.toHeight),
            const Divider(height: 1),
            SizedBox(height: 15.toHeight),
            InkWell(
              onTap: () async {
                BackupKeyWidget(
                  atsign: AtClientManager.getInstance()
                      .atClient
                      .getCurrentAtSign()!,
                ).showBackupDialog(context);
              },
              child: Row(
                children: <Widget>[
                  const Icon(Icons.file_copy, size: 23),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Backup your keys',
                        style: TextStyles.lightText(_themeData!.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.toHeight),
            const Divider(height: 1),
            SizedBox(
              height: 38,
              width: SizeConfig().screenWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 0.0),
                    child: Icon(Icons.lock, size: 25),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 0.0, 0.0),
                      child: Text(
                        'Private Account',
                        style: TextStyles.lightText(_themeData!.primaryColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 15.0, 0.0, 0.0),
                    child: Provider.of<SetPrivateState>(context).isLoading
                        ? LoadingDialog().onlyText(
                            'Updating',
                            style: TextStyle(
                                color: WaviColors.ColorConstants.DARK_GREY,
                                fontSize: 16.toFont,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none),
                          )
                        : Transform.scale(
                            alignment: Alignment.center,
                            scale: 0.7,
                            child: CupertinoSwitch(
                              activeColor: WaviColors.ColorConstants.black,
                              value: _allPrivate,
                              onChanged: (value) async {
                                await ChangePrivacyService()
                                    .setAllPrivate(value, _user);
                                updateAllPrivateKey();
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.toHeight),
            const Divider(height: 1),
            SizedBox(height: 15.toHeight),
            InkWell(
              onTap: () {
                SetupRoutes.push(context, Routes.TERMS_CONDITIONS_SCREEN);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset(
                      Images.termsAndConditionConditions,
                      color: _themeData!.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Terms and Conditions',
                        style: TextStyles.lightText(_themeData!.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.toHeight),
            const Divider(height: 1),
            SizedBox(height: 14.toHeight),
            InkWell(
              onTap: () {
                SetupRoutes.push(context, Routes.FAQS);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset(
                      Images.faqs,
                      color: _themeData!.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'FAQs',
                        style: TextStyles.lightText(_themeData!.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.toHeight),
            const Divider(height: 1),
            SizedBox(height: 14.toHeight),
            InkWell(
              onTap: () {
                _showResetDialog();
              },
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 25,
                    height: 25,
                    child: Icon(Icons.delete),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Delete atSign',
                        style: TextStyles.lightText(_themeData!.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.toHeight),
            const Divider(height: 1),
            SizedBox(height: 14.toHeight),
            InkWell(
              onTap: () async {
                var atSignList = await KeychainUtil.getAtsignList();

                await showModalBottomSheet(
                  context: NavService.navKey.currentContext!,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AtSignBottomSheet(
                    atSignList: atSignList ?? [],
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset(
                      Images.logout,
                      color: _themeData!.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Switch atSign',
                        style: TextStyles.lightText(_themeData!.primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showResetDialog() async {
    var isSelectAtsign = false;
    var isSelectAll = false;
    var atsignsList = await KeychainUtil.getAtsignList();
    atsignsList ??= [];

    var atsignMap = {};
    for (var atsign in atsignsList) {
      atsignMap[atsign] = false;
    }
    await showDialog(
        barrierDismissible: true,
        context: NavService.navKey.currentContext!,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, stateSet) {
            return AlertDialog(
                title: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Strings.resetDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 0.8,
                    )
                  ],
                ),
                content: atsignsList!.isEmpty
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text(Strings.noAtsignToReset,
                            style: TextStyle(fontSize: 15)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              Strings.close,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      ])
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CheckboxListTile(
                              onChanged: (value) {
                                value ??= false;
                                isSelectAll = value;
                                atsignMap
                                    .updateAll((key, value1) => value1 = value);
                                stateSet(() {});
                              },
                              value: isSelectAll,
                              checkColor: Colors.white,
                              title: const Text(Strings.selectAll,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            for (var atsign in atsignsList)
                              CheckboxListTile(
                                onChanged: (value) {
                                  atsignMap[atsign] = value;
                                  stateSet(() {});
                                },
                                value: atsignMap[atsign],
                                checkColor: Colors.white,
                                title: Text(atsign),
                              ),
                            const Divider(thickness: 0.8),
                            if (isSelectAtsign)
                              const Text(Strings.resetErrorText,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(Strings.resetWarningText,
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              TextButton(
                                onPressed: () async {
                                  var tempAtsignMap = {};
                                  tempAtsignMap.addAll(atsignMap);
                                  tempAtsignMap.removeWhere(
                                      (key, value) => value == false);
                                  if (tempAtsignMap.keys.toList().isEmpty) {
                                    isSelectAtsign = true;
                                    stateSet(() {});
                                  } else {
                                    isSelectAtsign = false;
                                    await BackendService().resetDevice(
                                        tempAtsignMap.keys.toList());
                                    await BackendService().onboardNextAtsign();
                                  }
                                },
                                child: const Text(Strings.remove,
                                    style: TextStyle(
                                      color: ColorConstants.FONT_PRIMARY,
                                      fontSize: 15,
                                    )),
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(Strings.cancel,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black)))
                            ])
                          ],
                        ),
                      ));
          });
        });
  }
}

class SetPrivateState with ChangeNotifier {
  bool isLoading = false;

  setLoadingState(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
