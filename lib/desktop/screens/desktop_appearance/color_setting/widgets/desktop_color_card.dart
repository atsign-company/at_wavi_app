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
      child: Visibility(
        visible: isSelected,
        child: Center(
          child: Container(
            height: 30,
            width: 30,
            child: Icon(Icons.check_rounded, color: color),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(color),
      ),
    );
  }
}
