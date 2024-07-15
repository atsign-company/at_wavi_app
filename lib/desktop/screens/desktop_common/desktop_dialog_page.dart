import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:flutter/material.dart';

class DesktopDialogPage extends StatefulWidget {
  final String title;
  final String okText;
  final String cancelText;
  final bool showOk;
  final bool showCancel;
  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;

  const DesktopDialogPage({
    Key? key,
    required this.title,
    this.okText = "Ok",
    this.cancelText = "Cancel",
    this.showOk = true,
    this.showCancel = true,
    this.onOkPressed,
    this.onCancelPressed,
  }) : super(key: key);

  @override
  _DesktopDialogPageState createState() => _DesktopDialogPageState();
}

class _DesktopDialogPageState extends State<DesktopDialogPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.symmetric(horizontal: DesktopDimens.paddingNormal),
      decoration: BoxDecoration(
        color: appTheme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: DesktopDimens.paddingNormal),
          Text(
            widget.title,
            style: appTheme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: DesktopDimens.paddingLarge),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: DesktopWhiteButton(
                    title: widget.cancelText,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onCancelPressed?.call();
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  child: DesktopButton(
                    title: widget.okText,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onOkPressed?.call();
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: DesktopDimens.paddingNormal),
        ],
      ),
    );
  }
}
