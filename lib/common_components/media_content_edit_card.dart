import 'dart:typed_data';

import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';

class MediaContentEditCard extends StatefulWidget {
  final BasicData basicData;
  const MediaContentEditCard({Key? key, required this.basicData}) : super(key: key);
  @override
  _MediaContentEditCardState createState() => _MediaContentEditCardState();
}

class _MediaContentEditCardState extends State<MediaContentEditCard> {
  Uint8List? customImage;

  @override
  void initState() {
    var intList = widget.basicData.value!.cast<int>();
    customImage = Uint8List.fromList(intList);
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
            !widget.basicData.isPrivate ? const Icon(Icons.public) : const Icon(Icons.lock)
          ],
        ),
        const SizedBox(height: 20),
        customImage != null
            ? Image.memory(
                customImage as Uint8List,
                width: double.infinity,
                height: 200,
                fit: BoxFit.fill,
              )
            : const SizedBox(),
      ],
    );
  }
}
