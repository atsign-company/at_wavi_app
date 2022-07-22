import 'dart:io';
import 'dart:typed_data';

import 'package:at_wavi_app/desktop/screens/desktop_common/crop_editor_helper.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/snackbar_utils.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class DesktopCropImagePage extends StatefulWidget {
  final File file;

  const DesktopCropImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _DesktopCropImagePageState createState() => _DesktopCropImagePageState();
}

class _DesktopCropImagePageState extends State<DesktopCropImagePage> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  bool _cropping = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.height - 100,
      padding: EdgeInsets.symmetric(horizontal: DesktopDimens.paddingNormal),
      decoration: BoxDecoration(
        color: appTheme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          SizedBox(height: DesktopDimens.paddingNormal),
          Expanded(
            child: ClipRRect(
              child: AspectRatio(
                aspectRatio: 1,
                child: ExtendedImage.file(
                  widget.file,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: editorKey,
                  cacheRawData: true,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                        maxScale: 8.0,
                        cropRectPadding: EdgeInsets.all(20.0),
                        hitTestSize: 20.0,
                        cropAspectRatio: 1.0);
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: DesktopDimens.paddingNormal),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: DesktopWhiteButton(
                    title: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _cropping
                      ? Center(
                          child: CircularProgressIndicator(
                              color: appTheme.primaryColor),
                        )
                      : DesktopButton(
                          title: 'Done',
                          onPressed: _onSaveData,
                        ),
                ),
              ],
            ),
          ),
          SizedBox(height: DesktopDimens.paddingNormal),
        ],
      ),
    );
  }

  void _onSaveData() async {
    final state = editorKey.currentState;
    if (state == null) return;
    if (_cropping) {
      return;
    }
    setState(() {
      _cropping = true;
    });
    final Uint8List? fileData =
        await cropImageDataWithDartLibrary(state: state);

    if ((fileData?.length ?? 0) > MixedConstants.maxDataSize) {
      setState(() {
        _cropping = false;
      });

      SnackBarUtils.show(
        context: context,
        message: 'The file is too large to upload',
        type: SnackBarType.error,
      );
    } else {
      setState(() {
        _cropping = true;
      });
      Navigator.pop(context, fileData);
    }
  }
}
