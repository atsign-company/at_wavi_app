import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DesktopTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final bool hasUnderlineBorder;
  final double contentPadding;
  final bool readOnly;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  DesktopTextField({
    required this.controller,
    this.title = '',
    this.hint = '',
    this.style,
    this.hintStyle,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.backgroundColor,
    this.borderRadius = 0,
    this.hasUnderlineBorder = true,
    this.contentPadding = 0,
    this.readOnly = false,
    this.enabled = true,
    this.borderColor = Colors.transparent,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: appTheme.textTheme.bodyMedium?.copyWith(
              color: appTheme.secondaryTextColor,
            ),
          ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          enabled: enabled,
          style: style ??
              appTheme.textTheme.bodyMedium?.copyWith(
                color: appTheme.primaryTextColor,
              ),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            isDense: contentPadding == 0 ? false : true,
            contentPadding: EdgeInsets.fromLTRB(contentPadding, contentPadding, contentPadding, contentPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide.none,
            ),
            hintText: hint,
            hintStyle: hintStyle ??
                style?.copyWith(
                  color: appTheme.secondaryTextColor,
                ) ??
                appTheme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.secondaryTextColor,
                ),
            filled: backgroundColor != null,
            fillColor: backgroundColor,
            enabledBorder: hasUnderlineBorder
                ? UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    borderSide: BorderSide(color: appTheme.separatorColor),
                  )
                : null,
            focusedBorder: hasUnderlineBorder
                ? UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    borderSide: BorderSide(color: appTheme.primaryColor),
                  )
                : null,
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}
