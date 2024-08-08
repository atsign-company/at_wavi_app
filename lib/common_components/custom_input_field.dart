import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';

class CustomInputField extends StatelessWidget {
  final String hintText, initialValue;
  final double width, height;
  final IconData? icon, secondIcon;
  final Function? onTap, onIconTap, onSecondIconTap, onSubmitted;
  final Color? iconColor,
      textColor,
      bgColor,
      hintTextColor,
      borderColor,
      focusedBorderColor;
  final ValueChanged<String>? value;
  final bool isReadOnly;
  final int? maxLines;
  final bool expands;
  final int baseOffset;
  final EdgeInsets? padding;
  final TextInputType? textInputType;
  final bool? blankSpacesAllowed, autoCorrectAllowed;

  var textController = TextEditingController();

  CustomInputField({Key? key, 
    this.hintText = '',
    this.height = 50,
    this.width = 300,
    this.iconColor,
    this.textColor,
    this.bgColor,
    this.hintTextColor,
    this.borderColor,
    this.focusedBorderColor,
    this.icon,
    this.secondIcon,
    this.onTap,
    this.onIconTap,
    this.onSecondIconTap,
    this.value,
    this.initialValue = '',
    this.onSubmitted,
    this.isReadOnly = false,
    this.maxLines,
    this.expands = false,
    this.baseOffset = 0,
    this.padding,
    this.textInputType,
    this.blankSpacesAllowed,
    this.autoCorrectAllowed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    textController.text = initialValue;
    if ((baseOffset != 0)) {
      textController = TextEditingController.fromValue(
        TextEditingValue(
          text: initialValue,
          selection: TextSelection.collapsed(offset: baseOffset),
        ),
      );
    }
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: padding ?? const EdgeInsets.all(0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: bgColor ?? ColorConstants.DARK_GREY,
          borderRadius: BorderRadius.circular(5),
        ),
        // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                autocorrect:
                    autoCorrectAllowed ?? true, // textfield autocorrect off
                keyboardType: textInputType ??
                    TextInputType
                        .text, // Tweak, if the device's keyboard's autocorrect is on
                readOnly: isReadOnly,
                style: TextStyle(
                    fontSize: 15.toFont, color: textColor ?? Colors.white),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: hintText,
                  enabledBorder: _outlineInputBorder(),
                  focusedBorder: _outlineInputBorder(
                      color: focusedBorderColor ?? ColorConstants.LIGHT_GREY),
                  // InputBorder.none,
                  border: _outlineInputBorder(),
                  // InputBorder.none,
                  hintStyle: TextStyle(
                      color: hintTextColor ?? ColorConstants.LIGHT_GREY,
                      fontSize: 15.toFont),
                ),
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                  }
                },
                minLines: expands ? null : 1,
                maxLines: expands ? null : maxLines,
                expands: expands,
                onChanged: (val) {
                  if (value != null) {
                    value!((blankSpacesAllowed ?? true)
                        ? val
                        : val.replaceAll(' ', ''));
                  }
                },
                controller: textController,
                onSubmitted: (str) {
                  if (onSubmitted != null) {
                    onSubmitted!(str);
                  }
                },
              ),
            ),
            secondIcon != null
                ? InkWell(
                    onTap: () {
                      if (onSecondIconTap != null) {
                        onSecondIconTap!();
                      }
                    },
                    child: Icon(
                      secondIcon,
                      color: iconColor ?? ColorConstants.DARK_GREY,
                    ),
                  )
                : const SizedBox(),
            secondIcon != null
                ? const SizedBox(
                    width: 7,
                  )
                : const SizedBox(),
            icon != null
                ? InkWell(
                    onTap: () {
                      if (onIconTap != null) {
                        onIconTap!();
                      } else if (onTap != null) {
                        onTap!();
                      }
                    },
                    child: Icon(
                      icon,
                      color: iconColor ?? ColorConstants.DARK_GREY,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder({Color? color}) {
    return OutlineInputBorder(
        borderSide: BorderSide(
            color: color ?? borderColor ?? ColorConstants.MILD_GREY));
  }
}
