import 'dart:convert';

import 'package:at_common_flutter/at_common_flutter.dart';
import 'package:at_location_flutter/utils/constants/colors.dart';
import 'package:at_wavi_app/common_components/public_private_bottomsheet.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/screens/edit_persona/html_editor_screen.dart';
import 'package:at_wavi_app/services/common_functions.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/services/image_picker.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:html_editor_enhanced/utils/options.dart';
import 'package:at_wavi_app/common_components/custom_input_field.dart'
    as customInputField;

class AddCustomField extends StatefulWidget {
  // ValueChanged<BasicData> onSave;
  Function onSave;
  final bool isEdit;
  BasicData? basicData;
  final AtCategory? category;
  AddCustomField({
    required this.onSave,
    this.isEdit = false,
    required this.basicData,
    this.category,
  });

  @override
  _AddCustomFieldState createState() => _AddCustomFieldState();
}

class _AddCustomFieldState extends State<AddCustomField> {
  ThemeData? _themeData;
  HtmlEditorController controller = HtmlEditorController();

  BasicData basicData =
      BasicData(isPrivate: false, type: CustomContentType.Text.name);
  bool isImageSelected = false;
  var contentDropDown = [
    CustomContentType.Text,
    CustomContentType.Link,
    CustomContentType.Number,
    CustomContentType.Image,
    CustomContentType.Youtube,
    CustomContentType.Html
  ];
  CustomContentType _fieldType = CustomContentType.Text;
  final _formKey = GlobalKey<FormState>();

  Key _htmlEditorKey = UniqueKey(); // to re-render the html editor

  @override
  void initState() {
    if (widget.isEdit && widget.basicData != null) {
      var basicDataJson = widget.basicData!.toJson();
      basicData = BasicData.fromJson(json.decode(basicDataJson));

      if (widget.basicData!.type != CustomContentType.Image.name) {
        basicData.valueDescription = basicData.value;
        basicData.value = null;
      }

      if (widget.basicData!.type == CustomContentType.Image.name) {
        isImageSelected = true;
      }

      _fieldType = customContentNameToType(widget.basicData!.type);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (_themeProvider.currentAtsignThemeData != null) {
      _themeData = _themeProvider.currentAtsignThemeData;
    }

    if (_themeData == null) {
      return CircularProgressIndicator();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30.toHeight),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back)),
                      SizedBox(width: 5),
                      Text(
                        'Add Custom Content',
                        style: TextStyles.boldText(_themeData!.primaryColor,
                            size: 16),
                      ),
                    ],
                  ),
                  _fieldType == CustomContentType.Html
                      ? Tooltip(
                          message: 'Use this to paste html content',
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  _themeData!.primaryColor),
                            ),
                            onPressed: () {
                              _pasteHtml(basicData.valueDescription ?? '');
                            },
                            child: Text(
                              'Paste html',
                              style: TextStyles.lightText(
                                  _themeData!.scaffoldBackgroundColor,
                                  size: 16),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Title',
                          style: TextStyles.lightText(
                              _themeData!.primaryColor.withOpacity(0.5),
                              size: 16),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Title is required';
                          }
                          return null;
                        },
                        initialValue: basicData.displayingAccountName ?? '',
                        onChanged: (String value) {
                          basicData.accountName = value;
                        },
                        decoration: InputDecoration(
                            fillColor: _themeData!.scaffoldBackgroundColor,
                            filled: true,
                            errorStyle: TextStyle(fontSize: 15),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            )),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                      ),
                      Divider(thickness: 1, height: 1),
                      SizedBox(
                          height:
                              _fieldType == CustomContentType.Html ? 0 : 30),
                      _fieldType == CustomContentType.Html
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Body',
                                style: TextStyles.lightText(
                                    _themeData!.primaryColor.withOpacity(0.5),
                                    size: 16),
                              ),
                            ),
                      SizedBox(
                        height: _fieldType == CustomContentType.Html
                            ? 7.toHeight
                            : 0,
                      ),
                      _fieldType == CustomContentType.Html
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.toWidth,
                                  vertical: 12.toHeight),
                              child: InkWell(
                                onTap: () async {
                                  var value = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HtmlEditorScreen(
                                              initialText:
                                                  basicData.valueDescription,
                                            )),
                                  );
                                  setState(() {
                                    _htmlEditorKey =
                                        UniqueKey(); // to re-render the html editor
                                    basicData.valueDescription = value;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Go to HTML editor',
                                      style: TextStyles.lightText(
                                          _themeData!.primaryColor,
                                          size: 14),
                                    ),
                                    Icon(Icons.arrow_forward_sharp)
                                  ],
                                ),
                              ),
                            )
                          : TextFormField(
                              autovalidateMode:
                                  _fieldType == CustomContentType.Image
                                      ? null
                                      : basicData.valueDescription != ''
                                          ? AutovalidateMode.disabled
                                          : AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (_fieldType == CustomContentType.Image) {
                                  return null;
                                }
                                if (value == null || value == '') {
                                  return 'Body is required';
                                }
                                if (_fieldType == CustomContentType.Link &&
                                    !UserPreview().isFormDataValid(
                                        value, CustomContentType.Link)) {
                                  return 'Please add a link/url';
                                }
                                if (_fieldType == CustomContentType.Youtube &&
                                    !UserPreview().isFormDataValid(
                                        value, CustomContentType.Youtube)) {
                                  return 'Please add a valid youtube link/url';
                                }
                                if (_fieldType == CustomContentType.Number &&
                                    !UserPreview().isFormDataValid(
                                        value, CustomContentType.Number)) {
                                  return 'Please add a number';
                                }
                                return null;
                              },
                              initialValue: basicData.valueDescription ?? '',
                              onChanged: (String value) {
                                basicData.valueDescription = value.trim();
                                _formKey.currentState!.validate();
                              },
                              decoration: InputDecoration(
                                  fillColor:
                                      _themeData!.scaffoldBackgroundColor,
                                  filled: true,
                                  errorStyle: TextStyle(fontSize: 15),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  )),
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: null,
                            ),
                      _fieldType == CustomContentType.Html
                          ? Divider(thickness: 1, height: 1)
                          : SizedBox(),
                      _fieldType == CustomContentType.Html
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.toWidth,
                                  vertical: 12.toHeight),
                              child: customInputField.CustomInputField(
                                width: double.infinity,
                                hintText: 'Preview (non editable)',
                                hintTextColor:
                                    AllColors().Black.withOpacity(0.5),
                                bgColor: AllColors().INPUT_GREY_BACKGROUND,
                                textColor: AllColors().Black,
                                initialValue:
                                    ('Preview (non editable)' + '\n\n') +
                                        (basicData.valueDescription ?? ''),
                                baseOffset:
                                    (basicData.valueDescription ?? '').length,
                                height: 250,
                                maxLines: 2,
                                expands: true,
                                value: (str) {},
                                isReadOnly: true,
                              ),
                            )
                          : SizedBox(),
                      Divider(thickness: 1, height: 1),
                      _fieldType == CustomContentType.Html
                          ? SizedBox()
                          : (!isImageSelected
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add Media',
                                        style: TextStyles.lightText(
                                            _themeData!.primaryColor,
                                            size: 14),
                                      ),
                                      GestureDetector(
                                        onTap: _selectImage,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Add',
                                              style: TextStyles.lightText(
                                                  _themeData!.primaryColor),
                                            ),
                                            SizedBox(width: 7),
                                            Icon(
                                              Icons.add,
                                              // size: 20,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox()),
                      Divider(thickness: 1, height: 1),
                      SizedBox(height: 10),
                      isImageSelected
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Media',
                                    style: TextStyles.lightText(
                                        _themeData!.primaryColor,
                                        size: 14),
                                  ),
                                  SizedBox(height: 10),
                                  Stack(
                                    children: [
                                      Image.memory(basicData.value!),
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: InkWell(
                                          onTap: () {
                                            basicData.value = null;
                                            isImageSelected = false;
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: _themeData!.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Icon(Icons.highlight_remove,
                                                size: 30,
                                                color: _themeData!
                                                    .scaffoldBackgroundColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: _selectImage,
                                    child: Text('Change Image',
                                        style: TextStyle(
                                          color: ColorConstants.orange,
                                          fontSize: 18.toFont,
                                        )),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 10),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'View',
                              style: TextStyles.lightText(
                                  _themeData!.primaryColor,
                                  size: 14),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showPublicPrivateBottomSheet(
                                        onPublicClicked: () {
                                          setState(() {
                                            basicData.isPrivate = false;
                                          });
                                        },
                                        onPrivateClicked: () {
                                          setState(() {
                                            basicData.isPrivate = true;
                                          });
                                        },
                                        height: 160);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        basicData.isPrivate
                                            ? Icons.lock
                                            : Icons.public,
                                        size: 25.toFont,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        basicData.isPrivate
                                            ? 'Private'
                                            : 'Public',
                                        style: TextStyles.lightText(
                                            _themeData!.primaryColor,
                                            size: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 200,
                                      color:
                                          _themeData!.scaffoldBackgroundColor,
                                      child: DropdownButtonFormField<
                                          CustomContentType>(
                                        dropdownColor:
                                            _themeData!.scaffoldBackgroundColor,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        hint: Text('-Select-'),
                                        decoration: InputDecoration(
                                          fillColor: _themeData!
                                              .scaffoldBackgroundColor,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorConstants.greyText),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorConstants.greyText),
                                          ),
                                        ),
                                        value: _fieldType,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: _themeData!.primaryColor,
                                          size: 30.0,
                                        ),
                                        elevation: 16,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: _themeData!.primaryColor),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select content type';
                                          }
                                          return null;
                                        },
                                        onChanged: (newValue) {
                                          setState(() {
                                            _fieldType = newValue!;
                                            basicData.type = _fieldType.name;
                                            _formKey.currentState!.validate();
                                          });
                                        },
                                        items: contentDropDown.map<
                                                DropdownMenuItem<
                                                    CustomContentType>>(
                                            (CustomContentType value) {
                                          return DropdownMenuItem<
                                              CustomContentType>(
                                            value: value,
                                            child: Text(value.label),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(
              width: double.infinity,
              height: 60,
              buttonText: 'Save',
              fontColor: ColorConstants.white,
              borderRadius: 0,
              onPressed: _onSave,
            )
          ],
        ),
      ),
    );
  }

  _selectImage() async {
    basicData.value = await ImagePicker().pickImage();
    if (basicData.value != null) {
      isImageSelected = true;
      // when image is selected , we are converting custom content's type image.
      // and the text entered will go to value description
      basicData.type = CustomContentType.Image.name;
      _fieldType = CustomContentType.Image;
      setState(() {});
    }
  }

  _pasteHtml(String _initialText) async {
    String? _value;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (_context, _setDialogState) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(10, 20, 5, 10),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('HTML',
                            style: TextStyles.lightText(
                                Theme.of(context).primaryColor,
                                size: 16)),
                        InkWell(
                          onTap: () {
                            _setDialogState(() {
                              _initialText = '';
                            });
                          },
                          child: Text(
                            "Clear",
                            style: CustomTextStyles.customTextStyle(
                              ColorConstants.red,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.toWidth, vertical: 12.toHeight),
                    child: customInputField.CustomInputField(
                      width: double.infinity,
                      hintText: 'Paste html here',
                      hintTextColor: AllColors().Black.withOpacity(0.5),
                      bgColor: AllColors().INPUT_GREY_BACKGROUND,
                      textColor: AllColors().Black,
                      initialValue: _initialText,
                      baseOffset: _initialText.length,
                      height: 250,
                      maxLines: 2,
                      expands: true,
                      value: (str) => _value = str,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                _themeData!.scaffoldBackgroundColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyles.lightText(
                                _themeData!.primaryColor,
                                size: 16),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                _themeData!.primaryColor),
                          ),
                          onPressed: () {
                            setState(() {
                              _htmlEditorKey =
                                  UniqueKey(); // to re-render the html editor
                              basicData.valueDescription = _value;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Done',
                            style: TextStyles.lightText(
                                _themeData!.scaffoldBackgroundColor,
                                size: 16),
                          ),
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
  }

  _onSave() {
    if (_fieldType == CustomContentType.Image && !isImageSelected) {
      CommonFunctions().showSnackBar('Please add an image');
      return;
    }
    checkFormValidation();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    basicData.accountName = basicData.accountName!.trim();

    // when new field is being added, checking if title name is already taken or not
    if (!widget.isEdit) {
      if (UserPreview().iskeyNameTaken(basicData)) {
        CommonFunctions().showSnackBar('This title is already taken');
        return;
      }
    }

    // when custom field is being updated and title is getting changed
    if (widget.basicData != null &&
        widget.basicData!.accountName?.trim() !=
            basicData.accountName?.trim()) {
      FieldOrderService().updateSingleField(widget.category!,
          widget.basicData!.accountName!, basicData.accountName!);
      if (UserPreview().iskeyNameTaken(basicData)) {
        CommonFunctions().showSnackBar('This title is already taken');
        return;
      }
    }

    if (isImageSelected) {
      basicData.type = CustomContentType.Image.name;
    } else {
      basicData.value = basicData.valueDescription;
      basicData.valueDescription = null;
    }

    /// validation needed for html body
    if (basicData.value == null || basicData.value == '') {
      CommonFunctions().showSnackBar('Please fill in the required fields');
      return;
    }

    var index;
    // calculating index of current data
    if (widget.isEdit) {
      List<BasicData>? customFields =
          Provider.of<UserPreview>(context, listen: false)
              .user()!
              .customFields[widget.category!.name];
      index = customFields!.indexWhere(
          (element) => element.accountName == widget.basicData!.accountName);
      checkForAccountNameChange();
    }

    Navigator.of(context).pop();
    widget.onSave(basicData, widget.isEdit && index != null ? index : -1);
  }

  checkFormValidation() {
    if (!_formKey.currentState!.validate()) {
      CommonFunctions().showSnackBar('Please fill in the required fields');
    }
  }

  checkForAccountNameChange() {
    if (widget.basicData != null &&
        widget.basicData!.accountName!.trim() !=
            basicData.accountName!.trim() &&
        widget.category != null) {
      UserPreview().addFieldToDelete(widget.category!, widget.basicData!);
    }
  }
}
