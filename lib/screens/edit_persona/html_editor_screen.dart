import 'dart:convert';

import 'package:at_location_flutter/utils/constants/colors.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/at_key_set_service.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';

class HtmlEditorScreen extends StatefulWidget {
  final String? initialText;
  HtmlEditorScreen({Key? key, this.initialText}) : super(key: key);

  @override
  _HtmlEditorScreenState createState() => _HtmlEditorScreenState();
}

class _HtmlEditorScreenState extends State<HtmlEditorScreen> {
  String? _value;
  HtmlEditorController _controller = HtmlEditorController();
  bool _showHtmlToast = true;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (Provider.of<UserProvider>(context, listen: false).user?.htmlToastView.value != null) {
      _showHtmlToast =
          Provider.of<UserProvider>(context, listen: false).user?.htmlToastView.value == 'false' ? false : true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _value);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _value = widget.initialText; // don't save content
              Navigator.pop(context, _value);
            },
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text('HTML'),
        ),
        bottomSheet: InkWell(
          onTap: () {
            Navigator.pop(context, _value);
          },
          child: Container(
              alignment: Alignment.center,
              height: 70.toHeight,
              width: SizeConfig().screenWidth,
              color: ColorConstants.black,
              child: Text(
                'Save',
                style: CustomTextStyles.customTextStyle(ColorConstants.white, size: 18),
              )),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              HtmlEditor(
                controller: _controller,
                htmlToolbarOptions: HtmlToolbarOptions(
                  buttonColor: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                  toolbarType: ToolbarType.nativeGrid,
                  dropdownBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  mediaUploadInterceptor: (file, InsertFileType type) async {
                    if (type == InsertFileType.image) {
                      await imageCompressor(file.path!);
                      return false;
                    }
                    return true;
                  },
                ),
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Your text here...",
                  initialText: widget.initialText,
                  autoAdjustHeight: false,
                  adjustHeightForKeyboard: false,
                ),
                otherOptions: OtherOptions(
                  height: 450,
                ),
                callbacks: Callbacks(
                    onBeforeCommand: (String? currentHtml) {},
                    onChangeContent: (String? changed) {
                      _value = changed;
                    },
                    onPaste: () {
                      if (_showHtmlToast) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 3),
                          backgroundColor: ColorConstants.DARK_GREY,
                          dismissDirection: DismissDirection.horizontal,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                // "Paste not allowed here. Use the 'Paste html' button in the previous page.",
                                "Use the 'Paste html' button in the previous page to paste html content.",
                                style: CustomTextStyles.customTextStyle(
                                  ColorConstants.white,
                                  size: 14,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _controller.undo();
                                      ScaffoldMessenger.of(context).clearSnackBars();
                                    },
                                    child: Text(
                                      "Undo Paste",
                                      style: CustomTextStyles.customBoldTextStyle(
                                        ColorConstants.red,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      AtKeySetService().update(
                                        BasicData(value: 'false'),
                                        FieldsEnum.HTMLTOASTVIEW.name,
                                      );
                                      ScaffoldMessenger.of(context).clearSnackBars();

                                      _showHtmlToast = false;
                                      Provider.of<UserProvider>(context, listen: false).user?.htmlToastView.value =
                                          'false';
                                    },
                                    child: Text(
                                      "Don't show again",
                                      style: CustomTextStyles.customTextStyle(
                                        ColorConstants.black,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ));
                      }
                    }),
              ),
              SizedBox(height: 100), // extra space for scrolling
            ],
          ),
        ),
      ),
    );
  }

  imageCompressor(String path) async {
    double _width = 400, _height = 700, _compression = 75;
    bool _loading = false, _fullWidth = false;
    String? _errorMsg;
    await showDialog<void>(
      context: NavService.navKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (_context, _setDialogState) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 20, 5, 10),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child:
                        Text('Image Compressor', style: TextStyles.boldText(Theme.of(context).primaryColor, size: 16)),
                  ),
                  SizedBox(height: 5.toHeight),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '(Aspect ratio will be maintained)',
                      style: TextStyles.lightText(Theme.of(context).primaryColor.withOpacity(0.5), size: 12),
                    ),
                  ),
                  SizedBox(height: 10.toHeight),
                  Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  SizedBox(height: 10.toHeight),
                  _errorMsg != null
                      ? Text('$_errorMsg', style: CustomTextStyles.customTextStyle(AllColors().RED))
                      : SizedBox(),
                  SizedBox(height: _errorMsg != null ? 10.toHeight : 0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.toWidth),
                    child: Row(
                      children: [
                        Text('100% width:',
                            style: CustomTextStyles.customTextStyle(Theme.of(context).primaryColor.withOpacity(0.5))),
                        Checkbox(
                            value: _fullWidth,
                            onChanged: (_val) {
                              _setDialogState(() {
                                _fullWidth = _val!;
                              });
                            }),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.toHeight),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.toWidth),
                    child: Text('Width: ' + (_fullWidth ? '100%' : '$_width px'),
                        style: CustomTextStyles.customTextStyle(Theme.of(context).primaryColor.withOpacity(0.5))),
                  ),
                  Slider(
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: ColorConstants.LIGHT_GREY,
                    value: _width,
                    min: 50,
                    max: 700,
                    divisions: 650,
                    onChanged: _fullWidth
                        ? null
                        : (double _newWidth) {
                            _setDialogState(() {
                              _width = _newWidth.floorToDouble();
                            });
                          },
                  ),
                  SizedBox(height: 10.toHeight),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.toWidth),
                    child: Text('Quality: $_compression%',
                        style: CustomTextStyles.customTextStyle(Theme.of(context).primaryColor.withOpacity(0.5))),
                  ),
                  Slider(
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: ColorConstants.LIGHT_GREY,
                    value: _compression,
                    min: 1,
                    max: 99,
                    divisions: 98,
                    onChanged: (double _newWidth) {
                      _setDialogState(() {
                        _compression = _newWidth.floorToDouble();
                      });
                    },
                  ),
                  SizedBox(height: 10.toHeight),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.toWidth),
                    child: Text(
                      'NOTE: We only accept images below 1MB',
                      style: CustomTextStyles.customTextStyle(Theme.of(context).primaryColor, size: 12),
                    ),
                  ),
                  SizedBox(height: 10.toHeight),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Theme.of(context).scaffoldBackgroundColor),
                          ),
                          onPressed: () {
                            _width = -1;
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyles.lightText(Theme.of(context).primaryColor, size: 16),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(_loading
                                    ? Theme.of(context).primaryColor.withOpacity(0.5)
                                    : Theme.of(context).primaryColor),
                              ),
                              onPressed: _loading
                                  ? null
                                  : () async {
                                      _setDialogState(() {
                                        _loading = true;
                                      });

                                      var _compressedFile = await FlutterImageCompress.compressWithFile(
                                        path,
                                        minWidth: _fullWidth ? 736 : _width.floor(), // 100% = 700
                                        minHeight: _height.floor(),
                                        quality: _compression.floor(),
                                      );

                                      if (_compressedFile!.lengthInBytes > 1000000) {
                                        /// 1MB
                                        if (mounted) {
                                          _setDialogState(() {
                                            _errorMsg = 'File greater than 512 KB';
                                            _loading = false;
                                          });
                                        }
                                      } else {
                                        _setDialogState(() {
                                          _errorMsg = null;
                                          _loading = false;
                                        });

                                        String _finalWidth = _fullWidth ? '100%' : _width.floor().toString();

                                        _controller.insertHtml(
                                            '<img src="data:image/jpeg;base64,${base64.encode(_compressedFile)}" width="$_finalWidth">');

                                        Navigator.of(context).pop();
                                      }
                                    },
                              child: Text(
                                'Done',
                                style: TextStyles.lightText(Theme.of(context).scaffoldBackgroundColor, size: 16),
                              ),
                            ),
                            _loading ? CupertinoActivityIndicator() : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );

    print('_width $_width, _height $_height, _compression $_compression');

    return;
  }
}
