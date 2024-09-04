import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';

class ContentEditFieldCard extends StatefulWidget {
  final String title, subtitle;
  final bool isPrivate;
  final ThemeData theme;
  const ContentEditFieldCard(
      {Key? key, required this.theme,
      required this.title,
      required this.subtitle,
      this.isPrivate = true}) : super(key: key);
  // ContentEditFieldCard({
  //   required this.title,
  //   required this.subtitle,
  // });
  @override
  _ContentEditFieldCardState createState() => _ContentEditFieldCardState();
}

class _ContentEditFieldCardState extends State<ContentEditFieldCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.lightText(
                    ColorConstants.greyText,
                    size: 16,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style:
                      TextStyles.lightText(widget.theme.primaryColor, size: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        // widget.isPublic
        //     ? Icon(
        //         Icons.public,
        //         color: widget.theme.primaryColor,
        //       )
        //     : Icon(Icons.lock, color: widget.theme.primaryColor)
        widget.isPrivate
            ? Icon(
                Icons.lock,
                color: widget.theme.primaryColor,
              )
            : Icon(
                Icons.public,
                color: widget.theme.primaryColor,
              )
      ],
    );
  }
}
