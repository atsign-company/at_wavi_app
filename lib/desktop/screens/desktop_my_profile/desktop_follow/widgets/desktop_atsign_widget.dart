import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_avatar_widget.dart';
import 'package:flutter/material.dart';

class DesktopAtSignWidget extends StatelessWidget {
  final bool isFollowing;
  final String atSign;
  final VoidCallback? onPressed;
  final VoidCallback? onFollowPressed;

  const DesktopAtSignWidget({
    Key? key,
    required this.atSign,
    required this.isFollowing,
    this.onPressed,
    this.onFollowPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DesktopAvatarWidget(atSign: atSign),
            const SizedBox(width: DesktopDimens.paddingSmall),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    atSign,
                    style: appTheme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onFollowPressed,
              behavior: HitTestBehavior.translucent,
              child: Container(
                child: Center(
                  child: Text(
                    isFollowing ? 'Unfollow' : 'Follow',
                    style: appTheme.textTheme.titleSmall,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
