import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/textfields/desktop_textfield.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/theme/app_theme.dart';

class DesktopShareProfilePage extends StatefulWidget {
  final String atSign;

  const DesktopShareProfilePage({
    Key? key,
    required this.atSign,
  }) : super(key: key);

  @override
  State<DesktopShareProfilePage> createState() =>
      _DesktopShareProfilePageState();
}

class _DesktopShareProfilePageState extends State<DesktopShareProfilePage> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          // appBar: AppBar(
          //   iconTheme: IconThemeData(color: appTheme.primaryColor),
          //   toolbarHeight: 55,
          //   title: Text(
          //     'Share Profile',
          //     style: appTheme.textTheme.button,
          //   ),
          //   centerTitle: false,
          //   elevation: 0,
          //   leading: DesktopIconButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     iconData: Icons.close,
          //   ),
          //   backgroundColor: Colors.transparent,
          // ),
          body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(DesktopDimens.paddingSmall),
            child: Row(
              children: [
                DesktopIconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconData: Icons.close,
                ),
                SizedBox(width: DesktopDimens.paddingSmall),
                Text(
                  'Share Profile',
                  style: appTheme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: DesktopDimens.dialogWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            "Scan the QR Code with Wavi App",
                            style: appTheme.textTheme.bodyLarge,
                          ),
                          SizedBox(height: DesktopDimens.paddingNormal),
                          QrImageView(
                            data: widget.atSign,
                            size: (MediaQuery.of(context).size.height - 60) /
                                    3 *
                                    2 -
                                120,
                            eyeStyle: QrEyeStyle(color: Colors.black),
                            backgroundColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            endIndent: 10.0,
                          ),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: Divider(
                            indent: 10.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DesktopTextField(
                            controller: _commentController,
                            hint: "Comment",
                          ),
                          SizedBox(height: DesktopDimens.paddingNormal),
                          DesktopButton(
                            onPressed: _handleShareViaApp,
                            title: 'Share Via App',
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _handleShareViaApp() async {
    String content = '';
    if (_commentController.text.isNotEmpty) {
      content = "${_commentController.text}\nhttps://wavi.ng/" +
          widget.atSign.toString();
    } else {
      content = "https://wavi.ng/" + widget.atSign.toString();
    }
    final result = await Share.shareWithResult(
      content,
    );
    switch (result.status) {
      case ShareResultStatus.success:
        _commentController.text = '';
        break;
      case ShareResultStatus.dismissed:
        break;
      case ShareResultStatus.unavailable:
        break;
    }
  }
}
