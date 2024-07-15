import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_wavi_app/desktop/screens/desktop_login/desktop_login_model.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesktopLoginPage extends StatefulWidget {
  const DesktopLoginPage({Key? key}) : super(key: key);

  @override
  _DesktopLoginPageState createState() => _DesktopLoginPageState();
}

class _DesktopLoginPageState extends State<DesktopLoginPage> {
  late TextEditingController atSignTextEditingController;
  late DesktopLoginModel _model;

  @override
  void initState() {
    atSignTextEditingController = TextEditingController(
      text: '',
    );
    super.initState();
    _model = DesktopLoginModel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final appTheme = AppTheme.of(context);
      _model.checkToOnboard(onBoardingColor: appTheme.primaryColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider<DesktopLoginModel>(
      create: (BuildContext c) => _model,
      child: Scaffold(
        backgroundColor: appTheme.backgroundColor,
        body: _buildBodyWidget(),
      ),
    );
  }

  Widget _buildBodyWidget() {
    final appTheme = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: DesktopDimens.paddingExtraLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: DesktopDimens.paddingLarge),
            child: Image.asset(
              appTheme.isDark ? Images.logoLight : Images.logoDark,
              width: 90,
              height: 34,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Strings.desktop_all_links_in_one,
                  style: appTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlayfairDisplay',
                  ),
                ),
                SizedBox(height: DesktopDimens.paddingSmall),
                Text(
                  Strings.desktop_create_persona,
                  style: appTheme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.secondaryTextColor,
                  ),
                ),
                SizedBox(height: DesktopDimens.paddingLarge),
                DesktopButton(
                  width: double.infinity,
                  backgroundColor: appTheme.primaryColor,
                  title: Strings.desktop_create,
                  borderRadius: 10,
                  height: 54,
                  onPressed: _showOnBoardScreen,
                ),
                SizedBox(height: DesktopDimens.paddingNormal),
                Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showResetAtSignDialog(context);
                    },
                    child: Text(
                      'Reset',
                      style: appTheme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(height: DesktopDimens.paddingNormal),
              ],
            ),
          ),
          // SizedBox(),
          _buildFooterWidget(),
        ],
      ),
    );
  }

  _buildFooterWidget() {
    final appTheme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.desktop_company_copyrights,
          style: appTheme.textTheme.bodySmall?.copyWith(
            color: appTheme.secondaryTextColor,
          ),
        ),
        SizedBox(height: DesktopDimens.paddingNormal),
      ],
    );
  }

  void _showOnBoardScreen() async {
    if (_model.isAuthorizing == true) {
      return;
    }
    final appTheme = AppTheme.of(context);
    _model.openOnboard(onBoardingColor: appTheme.primaryColor);
  }

  _showResetAtSignDialog(BuildContext context) async {
    bool isSelectAtSign = false;
    bool isSelectAll = false;
    var atSignsList = await KeychainUtil.getAtsignList();
    if (atSignsList == null) {
      atSignsList = [];
    }
    Map atSignMap = {};
    for (String atSign in atSignsList) {
      atSignMap[atSign] = false;
    }
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, stateSet) {
            return AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('This will remove the selected atSign and its details from this app only.',
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 0.8,
                    )
                  ],
                ),
                content: (atSignsList ?? []).isEmpty
                    ? Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('No atSigns are paired to reset.', style: TextStyle(fontSize: 15)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 15,
                                // color: AtTheme.themecolor,
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
                                isSelectAll = value ?? false;
                                atSignMap.updateAll((key, value1) => value1 = value);
                                // atsignMap[atsign] = value;
                                stateSet(() {});
                              },
                              value: isSelectAll,
                              checkColor: Colors.white,
                              title: Text('Select All',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            for (var atsign in (atSignsList ?? []))
                              CheckboxListTile(
                                onChanged: (value) {
                                  atSignMap[atsign] = value;
                                  stateSet(() {});
                                },
                                value: atSignMap[atsign],
                                checkColor: Colors.white,
                                title: Text('$atsign'),
                              ),
                            Divider(thickness: 0.8),
                            if (isSelectAtSign)
                              Text('Please select at least one atSign to reset',
                                  style: TextStyle(color: Colors.red, fontSize: 14)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Warning: This action cannot be undone', style: TextStyle(fontSize: 14)),
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              TextButton(
                                onPressed: () async {
                                  var tempAtSignMap = {};
                                  tempAtSignMap.addAll(atSignMap);
                                  tempAtSignMap.removeWhere((key, value) => value == false);
                                  if (tempAtSignMap.keys.toList().isEmpty) {
                                    isSelectAtSign = true;
                                    stateSet(() {});
                                  } else {
                                    isSelectAtSign = false;
                                    await _resetDevice(tempAtSignMap.keys.toList());
                                    // await _onboardNextAtsign();
                                  }
                                },
                                child: Text('Remove',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    )),
                              ),
                              Spacer(),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel', style: TextStyle(fontSize: 15, color: Colors.black)))
                            ])
                          ],
                        ),
                      ));
          });
        });
  }

  _resetDevice(List checkedAtSigns) async {
    Navigator.of(context).pop();
    await BackendService().resetAtsigns(checkedAtSigns).then((value) async {
      print('reset done');
    }).catchError((e) {
      print('error in reset: $e');
    });
  }
}
