import 'dart:typed_data';

import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/utils.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class DesktopBasicInfoWidget extends StatelessWidget {
  final BasicData data;
  final bool isCustomField;
  final bool isEditingMode;
  final bool showMenu;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onPubicPressed;
  final VoidCallback? onPrivatePressed;

  const DesktopBasicInfoWidget({
    Key? key,
    required this.data,
    required this.isCustomField,
    required this.isEditingMode,
    required this.showMenu,
    this.onEditPressed,
    this.onDeletePressed,
    this.onPubicPressed,
    this.onPrivatePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isPrivate && !isEditingMode) {
      return Container();
    }

    if (data.type == CustomContentType.Youtube.name ||
        data.type == CustomContentType.Link.name) {
      return _youtubeContent(context);
    } else if (data.type == CustomContentType.Image.name) {
      return _imageContent(context);
    } else if (data.type == CustomContentType.Html.name ||
        data.type == CustomContentType.Number.name ||
        data.type == CustomContentType.Text.name) {
      return _htmlContent(context);
    } else {
      return _textContent(context);
    }
  }

  Widget _textContent(BuildContext context) {
    bool isUrl;
    String url;
    if(Uri.parse(data.value).isAbsolute) {
      isUrl = true;
      url = data.value;
    }else {
      url = getUrl(data.displayingAccountName ?? "", data.value);
      isUrl = Uri.parse(url).isAbsolute;
    }
    bool isEmail = data.displayingAccountName == "Email";
    final appTheme = AppTheme.of(context);
    return Container(
      constraints: const BoxConstraints(
        minHeight: 52,
      ),
      child: Row(
        children: [
          const SizedBox(width: DesktopDimens.paddingNormal),
          SizedBox(
            width: 150,
            child: Text(
              getTitle(data.displayingAccountName ?? ''),
              style: appTheme.textTheme.bodyMedium?.copyWith(
                color: appTheme.secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: GestureDetector(
                onTap: () async {
                  if (isUrl) {
                    // open link in browser
                    await launchUrl(Uri.parse(url));
                    return;
                  }
                  if (isEmail) {
                    Uri emailUrl = Uri(
                      scheme: "mailto",
                      path: data.value,
                    );
                    await launchUrl(emailUrl);
                    return;
                  }
                },
                child: Text(
                  data.value ?? '',
                  style: appTheme.textTheme.bodyMedium?.copyWith(
                    color: isUrl || isEmail ? Colors.blue : appTheme.primaryTextColor,
                  ),
                ),
              ),
            ),
          ),
          _buildVisibleWidget(context),
          _buildMenuWidget(context),
        ],
      ),
    );
  }

  Widget _youtubeContent(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      constraints: const BoxConstraints(
        minHeight: 52,
      ),
      child: Row(
        children: [
          const SizedBox(width: DesktopDimens.paddingNormal),
          SizedBox(
            width: 150,
            child: Text(
              getTitle(data.displayingAccountName ?? ''),
              style: appTheme.textTheme.bodyMedium?.copyWith(
                color: appTheme.secondaryTextColor,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                try {
                  await launchUrl(data.value ?? '');
                } catch (e) {}
              },
              child: Container(
                child: Text(
                  data.value ?? '',
                  style: appTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          _buildVisibleWidget(context),
          _buildMenuWidget(context),
        ],
      ),
    );
  }

  Widget _imageContent(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      constraints: const BoxConstraints(
        minHeight: 70,
      ),
      child: Row(
        children: [
          const SizedBox(width: DesktopDimens.paddingNormal),
          SizedBox(
            width: 150,
            child: Text(
              getTitle(data.displayingAccountName ?? ''),
              style:
                  TextStyle(color: appTheme.secondaryTextColor, fontSize: 16),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: DesktopDimens.paddingSmall),
                child: Container(
                  alignment: Alignment.centerLeft,
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                    maxHeight: 200,
                  ),
                  child: (data.value is Uint8List)
                      ? Image.memory(
                          data.value,
                          fit: BoxFit.contain,
                        )
                      : Container(),
                ),
              ),
            ),
          ),
          _buildVisibleWidget(context),
          _buildMenuWidget(context),
        ],
      ),
    );
  }

  Widget _htmlContent(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      constraints: const BoxConstraints(
        minHeight: 70,
      ),
      child: Row(
        children: [
          const SizedBox(width: DesktopDimens.paddingNormal),
          SizedBox(
            width: 150,
            child: Text(
              getTitle(data.displayingAccountName ?? ''),
              style:
                  TextStyle(color: appTheme.secondaryTextColor, fontSize: 16),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: DesktopDimens.paddingSmall,
                bottom: DesktopDimens.paddingSmall,
                right: DesktopDimens.paddingSmall,
              ),
              decoration: const BoxDecoration(
                  // border: Border.all(color: appTheme.primaryTextColor, width: 1),
                  ),
              child: HtmlWidget(
                data.value,
                // hyperlinkColor: Colors.blue, //Todo
              ),
            ),
          ),
          _buildVisibleWidget(context),
          _buildMenuWidget(context),
        ],
      ),
    );
  }

  Widget _buildVisibleWidget(BuildContext context) {
    final appTheme = AppTheme.of(context);
    if (!showMenu) {
      return const SizedBox();
    }
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: SizedBox(
            child: Text(
              "Public",
              style: appTheme.textTheme.bodyMedium,
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: SizedBox(
            child: Text(
              "Private",
              style: appTheme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
      tooltip: '',
      child: SizedBox(
        width: 48,
        height: 52,
        child: data.isPrivate
            ? Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: appTheme.primaryTextColor,
              )
            : Icon(
                Icons.public_rounded,
                size: 18,
                color: appTheme.primaryTextColor,
              ),
      ),
      onSelected: (index) {
        if (index == 0 && data.isPrivate) {
          onPubicPressed?.call();
        } else if (index == 1 && !data.isPrivate) {
          onPrivatePressed?.call();
        }
      },
    );
  }

  Widget _buildMenuWidget(BuildContext context) {
    if (!showMenu) {
      return const SizedBox(width: 48);
    }
    if (!isCustomField) {
      return const SizedBox(width: 48);
    }
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
        width: 48,
        height: 52,
        child: Icon(
          Icons.more_vert_rounded,
          color: appTheme.secondaryTextColor,
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
