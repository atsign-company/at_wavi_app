import 'dart:typed_data';

import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/storj_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';

class MediaContentEditCard extends StatefulWidget {
  final BasicData basicData;
  MediaContentEditCard({required this.basicData});
  @override
  _MediaContentEditCardState createState() => _MediaContentEditCardState();
}

class _MediaContentEditCardState extends State<MediaContentEditCard> {
  Uint8List? customImage;

  @override
  void initState() {
    if (widget.basicData.type == CustomContentType.StorjImage) {
      String fileName = "custom_${widget.basicData.accountName}.png";
      var imageFile = StorjService().getImageFromFile(fileName);
      customImage = imageFile?.readAsBytesSync();
    } else {
      var intList = widget.basicData.value!.cast<int>();
      customImage = Uint8List.fromList(intList);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.basicData.accountName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.lightText(
                        ColorConstants.greyText,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            !widget.basicData.isPrivate ? Icon(Icons.public) : Icon(Icons.lock)
          ],
        ),
        SizedBox(height: 20),
        customImage != null
            ? Image.memory(
                customImage as Uint8List,
                width: double.infinity,
                height: 200,
                fit: BoxFit.fill,
              )
            : SizedBox(),
      ],
    );
  }
}
