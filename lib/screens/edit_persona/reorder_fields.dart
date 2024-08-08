import 'package:at_common_flutter/widgets/custom_button.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/at_key_constants.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/field_names.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:at_wavi_app/services/size_config.dart';

class ReorderFields extends StatefulWidget {
  final AtCategory category;
  final Function onSave;

  const ReorderFields({Key? key, required this.category, required this.onSave}) : super(key: key);

  @override
  _ReorderFieldsState createState() => _ReorderFieldsState();
}

class _ReorderFieldsState extends State<ReorderFields> {
  var fields = <String>[];
  ThemeData? _themeData;
  late Map<dynamic, dynamic> userMap;
  List<BasicData>? customFields;

  @override
  void initState() {
    _getThemeData();
    if (FieldOrderService().previewOrders[widget.category.name] != null) {
      fields = [...FieldOrderService().previewOrders[widget.category.name]!];
    }
    // removing pre defined fields for location category.
    if (widget.category == AtCategory.LOCATION) {
      for (var el in FieldNames().locationFields) {
        fields.removeWhere((element) => element == el);
      }
    }
    _getUserData();
    super.initState();
  }

  _getUserData() {
    userMap =
        User.toJson(Provider.of<UserPreview>(context, listen: false).user());
    customFields = Provider.of<UserPreview>(context, listen: false)
        .user()!
        .customFields[widget.category.name];
  }

  _getThemeData() async {
    _themeData =
        await Provider.of<ThemeProvider>(context, listen: false).getTheme();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_themeData == null) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      bottomNavigationBar: CustomButton(
        width: double.infinity,
        height: 60,
        buttonText: 'Save',
        fontColor: ColorConstants.white,
        borderRadius: 0,
        onPressed: _saveFieldOrder,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          'Reorder',
                          style: TextStyles.boldText(_themeData!.primaryColor,
                              size: 16),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyles.lightText(_themeData!.primaryColor,
                          size: 14),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: SizeConfig().screenHeight - 180,
              child: ReorderableListView(
                children: [
                  ...getRowTitle(),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final String item = fields.removeAt(oldIndex);
                    fields.insert(newIndex, item);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getRowTitle() {
    var reorderList = <ListTile>[];
    List<String> predefinedLocationFields =
        FieldNames().getPredefinedFieldList(AtCategory.LOCATION);

    for (int index = 0; index < fields.length; index++) {
      if (widget.category == AtCategory.LOCATION) {
        // skipping location predefined fields
        if (predefinedLocationFields.contains(fields[index])) {
          continue;
        }
      }

      BasicData basicData = BasicData();
      if (userMap.containsKey(fields[index])) {
        basicData = userMap[fields[index]];
      } else {
        var i =
            customFields!.indexWhere((el) => el.accountName == fields[index]);
        if (i != -1) basicData = customFields![i];
      }

      basicData.value ??= '';
      if (basicData.accountName != null &&
          basicData.value != null &&
          !basicData.accountName!.contains(AtText.IS_DELETED)) {
        reorderList.add(ListTile(
          contentPadding: const EdgeInsets.all(0),
          key: Key('$index'),
          title: reorderTitle(fields[index], basicData),
        ));
      }
    }
    return reorderList;
  }

  Widget reorderTitle(String field, BasicData basicData) {
    var tile = const SizedBox();

    if (basicData.accountName != null &&
        basicData.value != null &&
        !basicData.accountName!.contains(AtText.IS_DELETED)) {
      return fieldCard(basicData);
    }
    return tile;
  }

  Widget fieldCard(BasicData basicData) {
    Widget card = const SizedBox();

    card = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  basicData.displayingAccountName ?? '',
                  style: TextStyles.lightText(
                      _themeData!.primaryColor.withOpacity(0.5),
                      size: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 15),
              // not showing location field values
              widget.category == AtCategory.LOCATION
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: basicData.type == CustomContentType.Image.name
                          ? Image.memory(basicData.value)
                          : Text(
                              basicData.value!,
                              style: TextStyles.lightText(
                                  _themeData!.primaryColor,
                                  size: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
              const Divider()
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            Icons.reorder,
            color: _themeData!.primaryColor,
          ),
        )
      ],
    );

    return card;
  }

  _saveFieldOrder() {
    FieldOrderService().updateField(widget.category, fields);
    Navigator.of(context).pop();
    widget.onSave();
  }
}
