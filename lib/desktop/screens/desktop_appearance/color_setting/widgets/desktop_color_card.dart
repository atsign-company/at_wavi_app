import 'package:flutter/material.dart';

class DesktopColorCard extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback? onPressed;

  const DesktopColorCard({
    Key? key,
    required this.color,
    required this.isSelected,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: Visibility(
        visible: isSelected,
        child: Center(
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Icon(Icons.check_rounded, color: color),
          ),
        ),
      ),
    );
  }
}
