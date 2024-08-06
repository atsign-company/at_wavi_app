import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

class ContactInitial extends StatelessWidget {
  final double? size;
  final String? initials;

  const ContactInitial({
    Key? key,
    this.size = 40,
    @required this.initials,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var index = 3;
    if (initials!.length < 3) {
      index = initials!.length;
    } else {
      index = 3;
    }

    return Container(
      height: size!.toFont,
      width: size!.toFont,
      decoration: BoxDecoration(
        color: ContactInitialsColors.getColor(initials!),
        borderRadius: BorderRadius.circular((size!.toFont)),
      ),
      child: Center(
        child: Text(
          initials!.substring((index == 1) ? 0 : 1, index).toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
