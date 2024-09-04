import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PassCodeWidget extends StatefulWidget {
  final bool isSecured;
  final int maxLength;
  final String? textWarning;
  final TextEditingController? controller;
  final Function(String?)? onDone;

  const PassCodeWidget({
    Key? key,
    this.isSecured = false,
    this.maxLength = 6,
    this.controller,
    this.textWarning,
    this.onDone,
  }) : super(key: key);

  @override
  _PassCodeWidgetState createState() => _PassCodeWidgetState();
}

class _PassCodeWidgetState extends State<PassCodeWidget> {
  late FocusNode focusNode;

  late String _otp;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _otp = '';
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    if (!focusNode.hasPrimaryFocus) {
      focusNode.requestFocus();
    }
    return Container(
      child: Stack(
        children: [
          Opacity(
            opacity: 0.0,
            child: TextFormField(
              focusNode: focusNode,
              controller: widget.controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              // Only numbers can be entered
              maxLength: widget.maxLength,
              autofocus: true,
              onChanged: (text) {
                setState(() {
                  _otp = text;
                });
                if (text.length == 6) {
                  widget.onDone!(text);
                }
              },
              // textInputAction: TextInputAction.done,
              // onEditingComplete: () {
              //   FocusScope.of(context).requestFocus(new FocusNode());
              //   if (widget.onDone != null) {
              //     widget.onDone!(_otp);
              //   }
              // },
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!focusNode.hasPrimaryFocus) {
                focusNode.requestFocus();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.maxLength,
                (index) {
                  final letter = index < _otp.length
                      ? widget.isSecured
                          ? '*'
                          : _otp[index]
                      : '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _SingleLetterWidget(
                      letter: letter,
                      indicatorColor: appTheme.primaryColor,
                      textStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: appTheme.primaryTextColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleLetterWidget
    extends StatelessWidget {
  final String letter;
  final double width = 40.0;
  final double height = 50.0;
  final double indicatorHeight = 2.0;
  final Color indicatorColor;
  final TextStyle textStyle;

  const _SingleLetterWidget({
    Key? key,
    required this.letter,
    required this.indicatorColor,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: appTheme.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(4)
      ),
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            letter,
            style: textStyle,
          ),
          // SizedBox(
          //   height: 6,
          // ),
          // SizedBox(
          //   height: this.indicatorHeight,
          //   child: Container(
          //     color: this.indicatorColor,
          //   ),
          // ),
        ],
      ),
    );
  }
}
