import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Widget? leading, trailing, centerWidget;
  final int centerWidgetFlex;
  const Header({Key? key, this.leading, this.trailing, this.centerWidget, this.centerWidgetFlex = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          (leading != null)
              ? Expanded(child: Align(alignment: Alignment.topLeft, child: leading!))
              : const Expanded(child: SizedBox()),
          (centerWidget != null)
              ? Expanded(flex: centerWidgetFlex, child: Align(alignment: Alignment.center, child: centerWidget!))
              : const Expanded(child: SizedBox()),
          (trailing != null)
              ? Expanded(child: Align(alignment: Alignment.topRight, child: trailing!))
              : const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
