import 'dart:io';
import 'dart:typed_data';

import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/storj_service.dart';
import 'package:flutter/material.dart';

class DesktopMediaItem extends StatefulWidget {
  final BasicData data;
  final bool showMenu;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  DesktopMediaItem({
    required this.data,
    required this.showMenu,
    this.onEditPressed,
    this.onDeletePressed,
  });

  @override
  State<DesktopMediaItem> createState() => _DesktopMediaItemState();
}

class _DesktopMediaItemState extends State<DesktopMediaItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String fileName = "custom_${widget.data.accountName}.png";

    final appTheme = AppTheme.of(context);
    return Stack(
      children: [
        Container(
          child: widget.data.value is Uint8List
              ? Image.memory(
                  widget.data.value,
                  fit: BoxFit.cover,
                )
              : FutureBuilder<File?>(
                  future: StorjService().getFile(fileName, widget.data.value),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      File file = snapshot.data!;
                      return Image.memory(
                        file.readAsBytesSync(),
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Icon(Icons.image);
                    }
                  },
                ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      widget.data.accountName ?? '',
                      style: appTheme.textTheme.subtitle2
                          ?.copyWith(color: Colors.white),
                    ),
                    padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                  ),
                ),
                if (widget.showMenu) _buildMenuWidget(context),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMenuWidget(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: SizedBox(
            child: Text(
              "Edit",
              style: appTheme.textTheme.bodyText2,
            ),
          ),
          value: 0,
        ),
        PopupMenuItem(
          child: SizedBox(
            child: Text(
              "Delete",
              style: appTheme.textTheme.bodyText2,
            ),
          ),
          value: 1,
        ),
      ],
      tooltip: null,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Icon(
          Icons.more_vert_rounded,
          color: appTheme.primaryColor,
        ),
      ),
      onSelected: (index) {
        if (index == 0) {
          widget.onEditPressed?.call();
        } else if (index == 1) {
          widget.onDeletePressed?.call();
        }
      },
    );
  }
}
