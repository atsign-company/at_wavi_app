import 'dart:typed_data';
import 'package:at_wavi_app/utils/colors.dart';

import 'package:flutter/material.dart';

class DesktopAvatarWidget extends StatelessWidget {
  final String? atSign;
  final Uint8List? imageData;
  final double size;

  const DesktopAvatarWidget({
    Key? key,
    this.atSign,
    this.imageData,
    this.size = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageData != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.memory(
          imageData!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    var index = 3;
    if ((atSign ?? '').length < 3) {
      index = (atSign ?? '').length;
    } else {
      index = 3;
    }
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: ContactInitialsColors.getColor(atSign ?? ''),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(
        child: Text(
          (atSign ?? '').substring((index == 1) ? 0 : 1, index).toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
