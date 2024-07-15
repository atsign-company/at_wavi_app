import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:flutter/material.dart';

class DesktopMediaItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Stack(
      children: [
        Container(
          child: Image.memory(
            data.value,
            fit: BoxFit.cover,
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
                      data.accountName ?? '',
                      style: appTheme.textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                  ),
                ),
                if (showMenu) _buildMenuWidget(context),
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
              style: appTheme.textTheme.bodyMedium,
            ),
          ),
          value: 0,
        ),
        PopupMenuItem(
          child: SizedBox(
            child: Text(
              "Delete",
              style: appTheme.textTheme.bodyMedium,
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
          onEditPressed?.call();
        } else if (index == 1) {
          onDeletePressed?.call();
        }
      },
    );
  }
}
