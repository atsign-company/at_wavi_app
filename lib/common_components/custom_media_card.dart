import 'dart:convert';
import 'dart:typed_data';

import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomMediaCard extends StatefulWidget {
  final BasicData basicData;
  final ThemeData themeData;
  const CustomMediaCard({Key? key, required this.basicData, required this.themeData}) : super(key: key);

  @override
  _CustomMediaCardState createState() => _CustomMediaCardState();
}

class _CustomMediaCardState extends State<CustomMediaCard> {
  late bool _isImage = false, _isVideo = false;
  Uint8List? customImage;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    if (widget.basicData.type == CustomContentType.Image.name) {
      _isImage = true;
      if (widget.basicData.value is String) {
        widget.basicData.value = json.decode(widget.basicData.value);
      }
      var intList = widget.basicData.value!.cast<int>();
      customImage = Uint8List.fromList(intList);
    } else if (widget.basicData.type == CustomContentType.Youtube.name) {
      // getting youtube video ID
      String? videoId;
      videoId = YoutubePlayer.convertUrlToId(widget.basicData.value);
      _isVideo = true;

      /// initializing [_controller]
      _controller = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${widget.basicData.accountName![0].toUpperCase()}${widget.basicData.accountName!.substring(1)}',
              style: TextStyles.lightText(
                  widget.themeData.primaryColor.withOpacity(0.5),
                  size: 16),
            ),
            const SizedBox(height: 6),
            ((widget.basicData.valueDescription != null) &&
                    (widget.basicData.valueDescription != 'null'))
                ? Text(
                    widget.basicData.valueDescription!,
                    style: TextStyles.lightText(widget.themeData.primaryColor,
                        size: 18),
                  )
                : const SizedBox(),
            (widget.basicData.valueDescription != null) &&
                    (widget.basicData.valueDescription != 'null')
                ? const SizedBox(height: 6)
                : const SizedBox(),
            _isImage && customImage != null
                ? Image.memory(
                    customImage as Uint8List,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  )
                : const SizedBox(),
            _isVideo
                ? YoutubePlayer(
                    controller: _controller,
                    bottomActions: [
                      CurrentPosition(),
                      ProgressBar(isExpanded: true),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
