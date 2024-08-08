import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:flutter/material.dart';

class DesktopMediaItem extends StatelessWidget {
  final BasicData data;
  final bool showMenu;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const DesktopMediaItem({Key? key, 
    required this.data,
    required this.showMenu,
    this.onEditPressed,
    this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Image.memory(
            data.value,
            fit: BoxFit.cover,
          ),
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                    child: Text(
                      data.accountName ?? '',
                      style: appTheme.textTheme.titleSmall
                          ?.copyWith(color: Colors.white),
                    ),
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
          value: 0,
          child: SizedBox(
            child: Text(
              "Edit",
              style: appTheme.textTheme.bodyMedium,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: SizedBox(
            child: Text(
              "Delete",
              style: appTheme.textTheme.bodyMedium,
            ),
          ),
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
