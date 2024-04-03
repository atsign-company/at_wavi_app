import 'package:at_wavi_app/common_components/content_edit_field_card.dart';
import 'package:at_wavi_app/common_components/media_content_edit_card.dart';
import 'package:at_wavi_app/common_components/public_private_bottomsheet.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/common_functions.dart';
import 'package:at_wavi_app/services/image_picker.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CotentEdit extends StatefulWidget {
  final ThemeData themeData;
  CotentEdit({required this.themeData, Key? key}) : super(key: key);
  @override
  _CotentEditState createState() => _CotentEditState();
}

class _CotentEditState extends State<CotentEdit> {
  var contentHeadings = [
    {
      'heading': 'Picture',
      'category': AtCategory.IMAGE,
      'route': '',
    },
    {
      'heading': 'Basic Details',
      'category': AtCategory.DETAILS,
      'route': Routes.EDIT_CATEGORY_FIELDS,
    },
    {
      'heading': 'Additional Details',
      'category': AtCategory.ADDITIONAL_DETAILS,
      'route': Routes.EDIT_CATEGORY_FIELDS,
    },
    {
      'heading': 'Location',
      'category': AtCategory.LOCATION,
      'route': Routes.LOCATION_WIDGET,
    },
    {
      'heading': 'Social Channels',
      'category': AtCategory.SOCIAL,
      'route': Routes.EDIT_CATEGORY_FIELDS,
    },
    {
      'heading': 'Game Channels',
      'category': AtCategory.GAMER,
      'route': Routes.EDIT_CATEGORY_FIELDS,
    },
  ];
  AtCategory? selectedcategory;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];

    _children = contentHeadings.map((contentHeading) {
      return editContentCardHeading(
        contentHeading['heading'] as String,
        contentHeading['category'] as AtCategory,
        contentHeading['route'] as String,
      );
    }).toList();

    _children.add(
      SizedBox(height: 60.toHeight), // to move bottom content up
    );

    return Container(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 50),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: _children,
        ),
      ),
    );
  }

  Widget editContentCardHeading(
      String title, AtCategory category, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (selectedcategory == category) {
                  selectedcategory = null;
                } else {
                  selectedcategory = category;
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title,
                    style: TextStyles.boldText(widget.themeData.primaryColor,
                        size: 18)),
                InkWell(
                  onTap: () {
                    if (route != '') {
                      if (route == Routes.LOCATION_WIDGET) {
                        SetupRoutes.push(
                            NavService.navKey.currentContext!, route);
                      } else if (route == Routes.EDIT_CATEGORY_FIELDS) {
                        SetupRoutes.push(
                            NavService.navKey.currentContext!, route,
                            arguments: {
                              'category': category,
                              'filedHeading': title,
                            });
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        category == AtCategory.IMAGE
                            ? ''
                            : CommonFunctions()
                                    .isFieldsPresentForCategory(category)
                                ? 'Edit'
                                : 'Add',
                        style:
                            TextStyles.lightText(widget.themeData.primaryColor),
                      ),
                      SizedBox(width: 7.toWidth),
                      category == AtCategory.IMAGE
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    changeVisibility(
                                        UserPreview().user()!.image);
                                  },
                                  child: Icon(
                                    UserPreview().user()!.image.isPrivate
                                        ? Icons.lock
                                        : Icons.public,
                                    color: widget.themeData.primaryColor,
                                    size: 20.toFont,
                                  ),
                                ),
                                SizedBox(width: 10),
                                toolTipMenu(UserPreview().user()!.image)
                              ],
                            )
                          : CommonFunctions()
                                  .isFieldsPresentForCategory(category)
                              ? Icon(
                                  (Icons.edit),
                                  size: 20.toFont,
                                  color: widget.themeData.primaryColor,
                                )
                              : Icon(
                                  Icons.add,
                                  size: 20.toFont,
                                  color: widget.themeData.primaryColor,
                                )
                    ],
                  ),
                )
              ],
            ),
          ),
          category == AtCategory.IMAGE ? SizedBox(height: 25) : SizedBox(),
          category == AtCategory.IMAGE
              ? UserPreview().user()!.image.value != null &&
                      UserPreview().user()!.image.value != ''
                  ? Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              Image.memory(UserPreview().user()!.image.value)
                                  .image,
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person,
                        size: 50,
                      ),
                    )
              : SizedBox(),
          Divider(height: 25),
          selectedcategory == category
              ? Column(
                  children: contentFields(),
                )
              : SizedBox()
        ],
      ),
    );
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

  onImageSelect() async {
    var pickedImage = await ImagePicker().pickImage();
    if (pickedImage != null) {
      setState(() {
        Provider.of<UserPreview>(context, listen: false).user()!.image.value =
            pickedImage;
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .image
            .accountName = FieldsEnum.IMAGE.name;
      });
    }
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
            onImageSelect();
          } else {
            Provider.of<UserPreview>(context, listen: false)
                .user()!
                .image
                .value = '';
          }
          setState(() {});
        },
        itemBuilder: (BuildContext context) {
          return tooltipOperations.map((String choice) {
            return PopupMenuItem(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyles.lightText(widget.themeData.primaryColor,
                      size: 14),
                ));
          }).toList();
        });
  }

  List<Widget> contentFields() {
    return [
      ...getAllFieldsCard(),
    ];
  }

  List<Widget> getAllFieldsCard() {
    var definedFieldsWidgets = <Widget>[];
    var userMap =
        User.toJson(Provider.of<UserPreview>(context, listen: false).user());
    List<BasicData>? customFields =
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .customFields[selectedcategory!.name];

    var fields = <String>[];
    fields = [...FieldNames().getFieldList(selectedcategory!, isPreview: true)];

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

      Widget widget = SizedBox();
      if (basicData.accountName == null) {
        continue;
      }

      if (!isCustomField) {
        widget = Column(
          children: [
            ContentEditFieldCard(
              title: basicData.displayingAccountName ?? '',
              subtitle: basicData.value,
              theme: this.widget.themeData,
              isPrivate: basicData.isPrivate,
            ),
            SizedBox(height: 25)
          ],
        );
      } else {
        widget = Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: checkForCustomContentType(basicData,
                    isLocation: ((selectedcategory!) == AtCategory.LOCATION))),
            SizedBox(height: 25)
          ],
        );
      }

      definedFieldsWidgets.add(widget);
    }

    return definedFieldsWidgets;
  }

  List<Widget> getDefinedFieldsCard() {
    if (selectedcategory == null ||
        Provider.of<UserPreview>(context, listen: false).user() == null) {
      return [SizedBox()];
    }

    var definedFieldsWidgets = <Widget>[];
    var userMap =
        User.toJson(Provider.of<UserPreview>(context, listen: false).user());
    List<String> fields = FieldNames().getFieldList(selectedcategory!);

    for (var field in userMap.entries) {
      if (field.key != null &&
          fields.contains(field.key) &&
          field.value != null &&
          field.value.value != null) {
        var widget = Column(
          children: [
            ContentEditFieldCard(
              title: field.key,
              subtitle: field.value.value,
              theme: this.widget.themeData,
            ),
            SizedBox(height: 25)
          ],
        );

        definedFieldsWidgets.add(widget);
      }
    }
    return definedFieldsWidgets;
  }

  List<Widget> getCustomFieldsCard() {
    if (selectedcategory == null ||
        Provider.of<UserPreview>(context, listen: false).user() == null) {
      return [SizedBox()];
    }
    var customFieldsWidgets = <Widget>[];

    /// getting custom fields for [selectedcategory]
    List<BasicData>? customFields =
        Provider.of<UserPreview>(context, listen: false)
            .user()!
            .customFields[selectedcategory!.name];

    if (customFields != null) {
      for (var basicData in customFields) {
        if (basicData.accountName != null && basicData.value != null) {
          var widget = Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: checkForCustomContentType(
                  basicData,
                  isLocation: ((selectedcategory!) == AtCategory.LOCATION),
                ),
              ),
              SizedBox(height: 25)
            ],
          );
          customFieldsWidgets.add(widget);
        }
      }
    }

    return customFieldsWidgets;
  }

  Widget checkForCustomContentType(BasicData basicData,
      {bool isLocation = false}) {
    Widget fieldCard = SizedBox();
    if (basicData.type == CustomContentType.Text.name ||
        basicData.type == CustomContentType.Number.name ||
        basicData.type == CustomContentType.Link.name ||
        basicData.type == CustomContentType.Youtube.name) {
      fieldCard = SizedBox(
        width: double.infinity,
        child: ContentEditFieldCard(
          title: isLocation ? '' : basicData.displayingAccountName ?? '',
          subtitle: isLocation ? basicData.accountName! : basicData.value,
          theme: widget.themeData,
          isPrivate: basicData.isPrivate,
        ),
      );
    } else if (basicData.type == CustomContentType.Image.name ||
        basicData.type == CustomContentType.StorjImage.name) {
      fieldCard = SizedBox(
        width: double.infinity,
        child: MediaContentEditCard(basicData: basicData),
      );
    }

    return fieldCard;
  }
}
