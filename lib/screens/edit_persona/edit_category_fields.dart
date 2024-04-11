import 'dart:typed_data';

import 'package:at_wavi_app/common_components/add_custom_content_button.dart';
import 'package:at_wavi_app/common_components/public_private_bottomsheet.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class EditCategoryFields extends StatefulWidget {
  final AtCategory category;
  final String filedHeading;

  EditCategoryFields({required this.category, required this.filedHeading});

  @override
  _EditCategoryFieldsState createState() => _EditCategoryFieldsState();
}

class _EditCategoryFieldsState extends State<EditCategoryFields> {
  final _formKey = GlobalKey<FormState>();
  ThemeData? _themeData;

  @override
  void initState() {
    _getThemeData();
    if (FieldOrderService().previewOrders[widget.category.name] == null) {
      FieldOrderService().initCategoryFields(widget.category);
    }

    super.initState();
  }

  _getThemeData() async {
    _themeData =
        await Provider.of<ThemeProvider>(context, listen: false).getTheme();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_themeData == null) {
      return CircularProgressIndicator();
    }

    return Container(
      color: _themeData!.scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Scaffold(
        backgroundColor: _themeData!.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: ColorConstants.RED,
                            content: Text(
                              'Please fill all custom details',
                              style: CustomTextStyles.customTextStyle(
                                ColorConstants.white,
                              ),
                            ),
                          ));
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: _themeData!.primaryColor,
                          ),
                          SizedBox(width: 5.toWidth),
                          Text(
                            widget.filedHeading,
                            style: TextStyles.boldText(_themeData!.primaryColor,
                                size: 16),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showPublicPrivateBottomSheet(
                            onPublicClicked: () {
                              changeFiledsVisibilityOfCategory(false);
                            },
                            onPrivateClicked: () {
                              changeFiledsVisibilityOfCategory(true);
                            },
                            height: 160);
                      },
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              SetupRoutes.push(
                                context,
                                Routes.REORDER_FIELDS,
                                arguments: {
                                  'category': widget.category,
                                  'onSave': () {
                                    setState(() {});
                                  }
                                },
                              );
                            },
                            child: Icon(Icons.reorder),
                          ),
                          SizedBox(width: 10),
                          Icon(
                              isAllFieldsPrivate() ? Icons.lock : Icons.public),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 35),
              Form(
                key: _formKey,
                child: Expanded(
                    child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getAllInputFields(),
                  ),
                )),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AddCustomContentButton(
                  text: 'Add Custom Content',
                  onTap: () {
                    SetupRoutes.push(context, Routes.ADD_CUSTOM_FIELD,
                        arguments: {
                          'onSave': (BasicData data, int index) {
                            List<BasicData>? customFields = UserPreview()
                                .user()!
                                .customFields[widget.category.name];

                            if (customFields == null) {
                              customFields = [];
                            }

                            setState(() {
                              customFields!.add(data);
                              UserPreview()
                                      .user()!
                                      .customFields[widget.category.name] =
                                  customFields;
                            });

                            FieldOrderService().addNewField(
                                widget.category, data.accountName!);
                          },
                          'isEdit': false,
                          'category': widget.category
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getAllInputFields() {
    return [
      ...getAllFieldsCard(),
    ];
  }

  List<Widget> getDefinedInputFields() {
    var definedFieldsWidgets = <Widget>[];
    var userMap =
        User.toJson(Provider.of<UserPreview>(context, listen: false).user());
    List<FieldsEnum> fields = [
      ...FieldNames().getFieldListEnum(widget.category)
    ];

    for (int i = 0; i < fields.length; i++) {
      BasicData basicData = userMap[fields[i].name];
      if (basicData.value == null && basicData.accountName == null) {
        basicData = BasicData(
          accountName: fields[i].name,
          value: '',
          type: CustomContentType.Text.name,
        );
      }

      var widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              basicData.accountName!,
              style: TextStyles.lightText(
                  _themeData!.primaryColor.withOpacity(0.5),
                  size: 16),
            ),
          ),
          inputField(basicData),
          Divider(thickness: 1, height: 1),
          SizedBox(height: 20)
        ],
      );

      definedFieldsWidgets.add(widget);
    }

    return definedFieldsWidgets;
  }

  List<Widget> getAllFieldsCard() {
    var definedFieldsWidgets = <Widget>[];
    var userMap =
        User.toJson(Provider.of<UserPreview>(context, listen: false).user());
    List<BasicData>? customFields =
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .customFields[widget.category.name];

    var fields = <String>[];
    fields = [...FieldNames().getFieldList(widget.category, isPreview: true)];

    for (int i = 0; i < fields.length; i++) {
      bool isCustomField = false;
      BasicData basicData = BasicData();

      if (userMap.containsKey(fields[i])) {
        basicData = userMap[fields[i]];
        if (basicData.accountName == null) basicData.accountName = fields[i];
        if (basicData.value == null) basicData.value = '';
      } else {
        var index =
            customFields!.indexWhere((el) => el.accountName == fields[i]);
        if (index != -1) {
          basicData = customFields[index];
          isCustomField = true;
        }
      }

      if (basicData.accountName == null) {
        continue;
      }

      Widget widget;
      if (!isCustomField) {
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                basicData.displayingAccountName ?? '',
                style: TextStyles.lightText(
                    _themeData!.primaryColor.withOpacity(0.5),
                    size: 16),
              ),
            ),
            inputField(basicData),
            Divider(thickness: 1, height: 1),
            SizedBox(height: 20)
          ],
        );
      } else {
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: checkForCustomContentType(basicData),
            ),
          ],
        );
      }

      definedFieldsWidgets.add(widget);
    }

    return definedFieldsWidgets;
  }

  List<Widget> getCustomInputFields() {
    var customFieldsWidgets = <Widget>[];
    List<BasicData>? customFields =
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .customFields[widget.category.name];

    if (customFields != null) {
      for (var basicData in customFields) {
        if (basicData.accountName != null && basicData.value != null) {
          var widget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: checkForCustomContentType(basicData),
              ),
            ],
          );
          customFieldsWidgets.add(widget);
        }
      }
    }
    return customFieldsWidgets;
  }

  Widget checkForCustomContentType(BasicData basicData) {
    if (basicData.type == CustomContentType.Text.name ||
        basicData.type == CustomContentType.Number.name ||
        basicData.type == CustomContentType.Link.name ||
        basicData.type == CustomContentType.Youtube.name ||
        basicData.type == CustomContentType.Html.name) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              basicData.accountName!,
              style: TextStyles.lightText(
                  _themeData!.primaryColor.withOpacity(0.5),
                  size: 16),
            ),
          ),
          inputField(basicData, isCustomField: true),
          Divider(thickness: 1, height: 1),
          SizedBox(height: 20)
        ],
      );

      // to show image content
    } else if (basicData.type == CustomContentType.Image.name) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  basicData.accountName!,
                  style: TextStyles.lightText(
                      _themeData!.primaryColor.withOpacity(0.5),
                      size: 16),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      changeVisibility(basicData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Icon(
                        basicData.isPrivate ? Icons.lock : Icons.public,
                      ),
                    ),
                  ),
                  toolTipMenu(basicData),
                ],
              )
            ],
          ),
          imageField(basicData),
          Divider(thickness: 1, height: 1),
          SizedBox(height: 20)
        ],
      );
    }
    return SizedBox();
  }

  bool matchRegex(String value, BasicData basicData) {
    print(basicData);
    if (value.isEmpty) {
      return true;
    }
    var regex = getRegex(basicData.displayingAccountName ?? "");
    bool res = regex.hasMatch(value);
    return res;
  }

  Widget inputField(BasicData basicData, {bool isCustomField = false}) {
    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.15,
        children: [],
        // TODO: if slidable action is not required remove this commneted part
        // ? <Widget>[
        //     IconSlideAction(
        //       caption: '',
        //       iconWidget: Padding(
        //         padding: const EdgeInsets.only(top: 10.0),
        //         child: Text(
        //           'Edit',
        //         ),
        //       ),
        //       onTap: () {
        //         SetupRoutes.push(context, Routes.ADD_CUSTOM_FIELD,
        //             arguments: {
        //               'onSave': (BasicData data, int index) {
        //                 List<BasicData>? customFields =
        //                     Provider.of<UserPreview>(context, listen: false)
        //                         .user()!
        //                         .customFields[widget.category.name];
        //                 if (index > -1) {
        //                   setState(() {
        //                     customFields![index] = data;
        //                   });
        //                 } else {
        //                   customFields!.add(data);
        //                 }
        //               },
        //               'basicData': basicData,
        //               'isEdit': true,
        //               'category': widget.category
        //             });
        //       },
        //     ),
        //     IconSlideAction(
        //       caption: '',
        //       color: ColorConstants.red,
        //       iconWidget: Padding(
        //         padding: const EdgeInsets.only(top: 10.0),
        //         child: Text(
        //           'Delete',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       ),
        //       onTap: () {
        //         if (!isCustomField) {
        //           updateDefinedFields(
        //               BasicData(accountName: basicData.accountName));
        //         }
        //         List<BasicData>? customFields =
        //             Provider.of<UserPreview>(context, listen: false)
        //                 .user()!
        //                 .customFields[widget.category.name];

        //         var index = customFields!.indexOf(basicData);
        //         customFields[index] = BasicData(
        //             accountName:
        //                 customFields[index].accountName! + AtText.IS_DELETED,
        //             isPrivate: customFields[index].isPrivate);
        //         setState(() {});
        //       },
        //     ),

        //   ]
        // : null,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextStyles.lightText(_themeData!.primaryColor),
                key: UniqueKey(),
                autovalidateMode: isCustomField
                    ? basicData.value != ''
                        ? AutovalidateMode.disabled
                        : AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                validator: (value) {
                  if (value == null || value == '' && isCustomField) {
                    return 'Body is required';
                  }
                  if (Uri.parse(value).isAbsolute) {
                    if (!matchRegex(value, basicData)) {
                      return "Invalid ${basicData.displayingAccountName} value";
                    }
                  }
                  return null;
                },
                initialValue: basicData.value,
                onChanged: (String value) {
                  basicData.value = value;
                  if (!isCustomField) {
                    updateDefinedFields(basicData);
                  }
                  _formKey.currentState!.validate();
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
                maxLines: null,
                textInputAction: TextInputAction.newline,
              ),
            ),
            GestureDetector(
              onTap: () {
                changeVisibility(basicData);
              },
              child: Icon(
                basicData.isPrivate ? Icons.lock : Icons.public,
              ),
            ),
            isCustomField
                ? Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: toolTipMenu(basicData),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget imageField(BasicData basicData) {
    var intList = basicData.value!.cast<int>();
    Uint8List customImage = Uint8List.fromList(intList);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          basicData.valueDescription != null
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(basicData.valueDescription!))
              : SizedBox(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 200,
            child: Image.memory(
              customImage,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  bool isAllFieldsPrivate() {
    var userMap =
        User.toJson(Provider.of<UserPreview>(context, listen: false).user());
    List<FieldsEnum> fields = [
      ...FieldNames().getFieldListEnum(widget.category)
    ];

    for (int i = 0; i < fields.length; i++) {
      if (!userMap[fields[i].name].isPrivate) {
        return false;
      }
    }

    List<BasicData>? customFields =
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .customFields[widget.category.name];

    if (customFields != null) {
      for (var basicData in customFields) {
        if (basicData.accountName != null &&
            basicData.value != null &&
            !basicData.isPrivate) {
          return false;
        }
      }
    }
    return true;
  }

  changeFiledsVisibilityOfCategory(bool isPrivate) {
    var userMap =
        User.toJson(Provider.of<UserPreview>(context, listen: false).user());
    List<FieldsEnum> fields = [
      ...FieldNames().getFieldListEnum(widget.category)
    ];

    List<BasicData>? customFields =
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .customFields[widget.category.name];

    for (int i = 0; i < fields.length; i++) {
      BasicData basicData = userMap[fields[i].name];
      basicData.isPrivate = isPrivate;
    }

    if (customFields != null) {
      for (var basicData in customFields) {
        basicData.isPrivate = isPrivate;
      }
    }

    setState(() {});
  }

  changeVisibility(BasicData basicData) {
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
  }

  onEditToolTip(BasicData basicData) {
    SetupRoutes.push(context, Routes.ADD_CUSTOM_FIELD, arguments: {
      'onSave': (BasicData updatedData, int index) {
        List<BasicData>? customFields =
            UserPreview().user()!.customFields[widget.category.name];
        if (index > -1) {
          setState(() {
            customFields![index] = updatedData;
          });
        } else {
          customFields!.add(updatedData);
        }
      },
      'basicData': basicData,
      'isEdit': true,
      'category': widget.category
    });
  }

  Widget toolTipMenu(BasicData basicData) {
    return PopupMenuButton(
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Icon(Icons.edit),
        ),
        onSelected: (value) {
          if (value == 'Edit') {
            onEditToolTip(basicData);
          } else {
            UserPreview().deletCustomField(widget.category, basicData);
            // FieldOrderService()
            //     .deleteField(widget.category, basicData.accountName!);
          }
          setState(() {});
        },
        itemBuilder: (BuildContext context) {
          return tooltipOperations.map((String choice) {
            return PopupMenuItem(
                value: choice,
                child: Text(
                  choice,
                  style:
                      TextStyles.lightText(_themeData!.primaryColor, size: 14),
                ));
          }).toList();
        });
  }

  /// [updateDefinedFields]can be used to either update or delete value
  /// when deleting send [BasicData] with just accountname
  /// when updating send complete [BasicData].
  updateDefinedFields(BasicData basicData) {
    if (basicData.accountName == FieldsEnum.IMAGE.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.image =
          basicData;
    } else if (basicData.accountName == FieldsEnum.LASTNAME.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.lastname =
          basicData;
    } else if (basicData.accountName == FieldsEnum.FIRSTNAME.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.firstname =
          basicData;
    } else if (basicData.accountName == FieldsEnum.PHONE.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.phone =
          basicData;
    } else if (basicData.accountName == FieldsEnum.EMAIL.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.email =
          basicData;
    } else if (basicData.accountName == FieldsEnum.ABOUT.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.about =
          basicData;
    } else if (basicData.accountName == FieldsEnum.LOCATION.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.location =
          basicData;
    } else if (basicData.accountName == FieldsEnum.LOCATIONNICKNAME.name) {
      Provider.of<UserPreview>(context, listen: false)
          .user()!
          .locationNickName = basicData;
    } else if (basicData.accountName == FieldsEnum.PRONOUN.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.pronoun =
          basicData;
    } else if (basicData.accountName == FieldsEnum.TWITTER.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.twitter =
          basicData;
    } else if (basicData.accountName == FieldsEnum.FACEBOOK.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.facebook =
          basicData;
    } else if (basicData.accountName == FieldsEnum.LINKEDIN.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.linkedin =
          basicData;
    } else if (basicData.accountName == FieldsEnum.INSTAGRAM.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.instagram =
          basicData;
    } else if (basicData.accountName == FieldsEnum.YOUTUBE.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.youtube =
          basicData;
    } else if (basicData.accountName == FieldsEnum.TUMBLR.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.tumbler =
          basicData;
    } else if (basicData.accountName == FieldsEnum.MEDIUM.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.medium =
          basicData;
    } else if (basicData.accountName == FieldsEnum.PS4.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.ps4 = basicData;
    } else if (basicData.accountName == FieldsEnum.XBOX.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.xbox = basicData;
    } else if (basicData.accountName == FieldsEnum.STEAM.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.steam =
          basicData;
    } else if (basicData.accountName == FieldsEnum.DISCORD.name) {
      Provider.of<UserPreview>(context, listen: false).user()!.discord =
          basicData;
    }
  }
}
