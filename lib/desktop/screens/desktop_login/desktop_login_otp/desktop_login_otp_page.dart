import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:flutter/material.dart';

import '../../../widgets/textfields/desktop_otp_textfield.dart';

class DesktopLoginOTPPage extends StatefulWidget {
  final String atSign;

  const DesktopLoginOTPPage({
    Key? key,
    required this.atSign,
  }) : super(key: key);

  @override
  _DesktopLoginOTPPageState createState() => _DesktopLoginOTPPageState();
}

class _DesktopLoginOTPPageState extends State<DesktopLoginOTPPage> {
  late TextEditingController passCodeTextEditingController;

  @override
  void initState() {
    passCodeTextEditingController = TextEditingController(
      text: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      width: 680,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: appTheme.backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 48, bottom: 32),
                child: Center(
                  child: Text(
                    '${Strings.desktop_passcode_title} @${widget.atSign}',
                    style: TextStyle(
                      color: appTheme.primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.clear,
                    size: 28,
                    color: appTheme.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: DesktopOTPTextField(
              length: 6,
              style: TextStyle(
                color: appTheme.primaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
              backgroundColor: appTheme.secondaryBackgroundColor,
              borderColor: appTheme.secondaryBackgroundColor,
              focusBorderColor: appTheme.primaryTextColor,
              onCompleted: (otp) {
                Navigator.pop(context, 'success');
              },
            ),
          ),
          const SizedBox(height: 40),
          Text(
            Strings.desktop_or,
            style: TextStyle(
              color: appTheme.secondaryTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            Strings.desktop_passcode_description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appTheme.primaryTextColor,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 56,
          ),
        ],
      ),
    );
  }
}
