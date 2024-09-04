import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:flutter/material.dart';

class DesktopHtmlEditorPage extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback? onPreviewPressed;

  const DesktopHtmlEditorPage({
    Key? key,
    required this.textController,
    this.onPreviewPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Stack(
      children: [
        TextFormField(
          minLines: 6,
          maxLines: 6,
          keyboardType: TextInputType.multiline,
          controller: textController,
          style: TextStyle(
            color: appTheme.primaryTextColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.borderColor, width: 1),
            ),
            hintText: 'Paste your HTML here!',
            hintStyle: TextStyle(
              color: appTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ),
        Positioned(
          right: 1,
          top: 1,
          child: DesktopIconButton(
            iconData: Icons.preview,
            onPressed: onPreviewPressed,
          ),
        )
      ],
    );
  }
}
