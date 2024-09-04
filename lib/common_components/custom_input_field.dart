import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';

class CustomInputField extends StatefulWidget {
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
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.text = widget.initialValue;
    if ((widget.baseOffset != 0)) {
      textController = TextEditingController.fromValue(
        TextEditingValue(
          text: widget.initialValue,
          selection: TextSelection.collapsed(offset: widget.baseOffset),
        ),
      );
    }
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(0),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.bgColor ?? ColorConstants.DARK_GREY,
          borderRadius: BorderRadius.circular(5),
        ),
        // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                autocorrect:
                    widget.autoCorrectAllowed ?? true, // textfield autocorrect off
                keyboardType: widget.textInputType ??
                    TextInputType
                        .text, // Tweak, if the device's keyboard's autocorrect is on
                readOnly: widget.isReadOnly,
                style: TextStyle(
                    fontSize: 15.toFont, color: widget.textColor ?? Colors.white),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  enabledBorder: _outlineInputBorder(),
                  focusedBorder: _outlineInputBorder(
                      color: widget.focusedBorderColor ?? ColorConstants.LIGHT_GREY),
                  // InputBorder.none,
                  border: _outlineInputBorder(),
                  // InputBorder.none,
                  hintStyle: TextStyle(
                      color: widget.hintTextColor ?? ColorConstants.LIGHT_GREY,
                      fontSize: 15.toFont),
                ),
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                },
                minLines: widget.expands ? null : 1,
                maxLines: widget.expands ? null : widget.maxLines,
                expands: widget.expands,
                onChanged: (val) {
                  if (widget.value != null) {
                    widget.value!((widget.blankSpacesAllowed ?? true)
                        ? val
                        : val.replaceAll(' ', ''));
                  }
                },
                controller: textController,
                onSubmitted: (str) {
                  if (widget.onSubmitted != null) {
                    widget.onSubmitted!(str);
                  }
                },
              ),
            ),
            widget.secondIcon != null
                ? InkWell(
                    onTap: () {
                      if (widget.onSecondIconTap != null) {
                        widget.onSecondIconTap!();
                      }
                    },
                    child: Icon(
                      widget.secondIcon,
                      color: widget.iconColor ?? ColorConstants.DARK_GREY,
                    ),
                  )
                : const SizedBox(),
            widget.secondIcon != null
                ? const SizedBox(
                    width: 7,
                  )
                : const SizedBox(),
            widget.icon != null
                ? InkWell(
                    onTap: () {
                      if (widget.onIconTap != null) {
                        widget.onIconTap!();
                      } else if (widget.onTap != null) {
                        widget.onTap!();
                      }
                    },
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor ?? ColorConstants.DARK_GREY,
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
            color: color ?? widget.borderColor ?? ColorConstants.MILD_GREY));
  }
}
