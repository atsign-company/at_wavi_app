import 'package:flutter/material.dart';
import 'package:at_common_flutter/services/size_config.dart';

class CustomButton extends StatelessWidget {
  final double width, height;
  final double? radius;
  final EdgeInsets? padding;
  final Widget child;
  final Function onTap;
  final Color bgColor;
  final Border? border;
  final Color? highlightColor;

  const CustomButton({Key? key, 
    required this.child,
    this.height = 50,
    required this.onTap,
    this.padding,
    this.width = 50,
    required this.bgColor,
    this.radius,
    this.border,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await onTap();
      },
      child: Container(
        alignment: Alignment.center,
        width: width.toWidth,
        height: height.toHeight,
        padding: padding ?? const EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: bgColor,
            border: border ?? const Border(),
            borderRadius: BorderRadius.circular(radius ?? 30)),
        child: child,
      ),
    );
  }
}
