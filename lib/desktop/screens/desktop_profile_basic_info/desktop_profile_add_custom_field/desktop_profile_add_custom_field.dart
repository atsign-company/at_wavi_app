import 'dart:typed_data';

import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_label_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_show_hide_radio_button.dart';
import 'package:at_wavi_app/desktop/widgets/textfields/desktop_textfield.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/image_picker.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_profile_add_custom_field_model.dart';
import 'widgets/desktop_html_editor_page.dart';
import 'widgets/desktop_html_preview_page.dart';

class DesktopProfileAddCustomField extends StatefulWidget {
  final String title;
  final AtCategory atCategory;
  final BasicData? data;
  final List<CustomContentType> allowContentType;

  const DesktopProfileAddCustomField({
    Key? key,
    this.title = Strings.desktop_add_custom_content,
    required this.atCategory,
    this.data,
    this.allowContentType = const [
      CustomContentType.Text,
      CustomContentType.Link,
      CustomContentType.Number,
      CustomContentType.Image,
      CustomContentType.Youtube,
      CustomContentType.Html,
    ],
  }) : super(key: key);

  @override
  _DesktopProfileAddCustomFieldState createState() =>
      _DesktopProfileAddCustomFieldState();
}

class _DesktopProfileAddCustomFieldState
    extends State<DesktopProfileAddCustomField> {
  late DesktopAddBasicDetailModel _model;
  bool _isUpdate = false;
  bool _isPickingFile = false;

  @override
  void initState() {
    super.initState();
    _isUpdate = widget.data != null;
    if (widget.data != null) {}
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopAddBasicDetailModel(
          userPreview: userPreview,
          atCategory: widget.atCategory,
          originBasicData: widget.data,
          allowContentType: widget.allowContentType,
        );
        return _model;
      },
      child: Consumer<DesktopAddBasicDetailModel>(
        builder: (_, model, child) {
          return Container(
            width: DesktopDimens.dialogWidth,
            padding: const EdgeInsets.all(DesktopDimens.paddingNormal),
            decoration: BoxDecoration(
              color: appTheme.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: appTheme.primaryTextColor,
                  ),
                ),
                const SizedBox(height: DesktopDimens.paddingNormal),
                DesktopTextField(
                  title: Strings.desktop_title,
                  controller: model.titleTextController,
                ),
                _buildTypeSelectionWidget(model),
                _buildFieldInputWidget(model),
                Container(height: 1, color: appTheme.separatorColor),
                const SizedBox(height: DesktopDimens.paddingNormal),
                DesktopShowHideRadioButton(
                  controller: model.showHideController,
                ),
                const SizedBox(height: DesktopDimens.paddingNormal),
                Row(
                  children: [
                    Expanded(
                      child: DesktopWhiteButton(
                        title: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DesktopButton(
                        title: Strings.desktop_done,
                        onPressed: _onSaveData,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeSelectionWidget(DesktopAddBasicDetailModel model) {
    final appTheme = AppTheme.of(context);
    return Consumer<DesktopAddBasicDetailModel>(
      builder: (_, model, child) {
        return DropdownButtonFormField<CustomContentType>(
          dropdownColor: appTheme.backgroundColor,
          autovalidateMode: AutovalidateMode.disabled,
          hint: const Text(Strings.desktop_select_type),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appTheme.separatorColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appTheme.primaryColor),
            ),
          ),
          value: model.fieldType,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appTheme.primaryTextColor,
          ),
          validator: (value) {
            if (value == null) {
              return Strings.desktop_please_select_type;
            }
            return null;
          },
          onChanged: (newValue) {
            if (newValue != null) {
              _model.changeField(newValue);
            }
          },
          items: widget.allowContentType
              .map<DropdownMenuItem<CustomContentType>>(
                  (CustomContentType value) {
            return DropdownMenuItem<CustomContentType>(
              value: value,
              child: Text(value.label),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFieldInputWidget(DesktopAddBasicDetailModel model) {
    return Consumer<DesktopAddBasicDetailModel>(
      builder: (_, model, child) {
        if (model.fieldType == CustomContentType.Text) {
          return DesktopTextField(
            controller: model.valueContentTextController,
            hint: '',
          );
        } else if (model.fieldType == CustomContentType.Link) {
          return DesktopTextField(
            controller: model.valueContentTextController,
            hint: 'https:www//example.com',
          );
        } else if (_model.fieldType == CustomContentType.Number) {
          return DesktopTextField(
            controller: model.valueContentTextController,
            hint: '',
          );
        } else if (model.fieldType == CustomContentType.Image) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DesktopIconLabelButton(
                  iconData: Icons.add,
                  label: Strings.desktop_add_media,
                  onPressed: _onSelectMedia,
                  isPrefixIcon: false,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(
                  width: DesktopDimens.paddingSmall,
                ),
                if (model.selectedMedia != null)
                  _buildMediaWidget(model.selectedMedia),
              ],
            ),
          );
        } else if (model.fieldType == CustomContentType.Youtube) {
          return DesktopTextField(
            controller: model.valueContentTextController,
            hint: 'https://www.youtube.com',
          );
        } else if (model.fieldType == CustomContentType.Html) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: DesktopDimens.paddingSmall),
            child: DesktopHtmlEditorPage(
              textController: _model.valueContentTextController,
              onPreviewPressed: _openHtmlPreview,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildMediaWidget(Uint8List? uInt8list) {
    final appTheme = AppTheme.of(context);
    // if (extension == 'jpg' || extension == 'png') {
    if (uInt8list == null) {
      return Container();
    }
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 120.0,
      ),
      margin: const EdgeInsets.all(DesktopDimens.paddingSmall),
      decoration: BoxDecoration(
          border: Border.all(color: appTheme.secondaryTextColor, width: 1)),
      child: Image.memory(uInt8list),
    );
  }

  void _onSelectMedia() async {
    if (_isPickingFile) {
      return;
    } else {
      _isPickingFile = true;
    }
    final data = await ImagePicker().desktopPickImage(context);
    if (data != null) {
      await _model.didSelectMedia(data);
    }
    _isPickingFile = false;
  }

  void _onSaveData() {
    SizeConfig().init(context);
    if (_isUpdate) {
      _model.updateCustomField(context);
    } else {
      _model.addCustomField(context);
    }
  }

  void _openHtmlPreview() {
    final html = _model.valueContentTextController.text.trim();
    if (html.isEmpty) {
      return;
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopHtmlPreviewPage(html: html),
      ),
    );
  }
}
