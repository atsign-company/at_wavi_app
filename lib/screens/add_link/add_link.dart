import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';

class AddLink extends StatefulWidget {
  final String url;
  const AddLink(this.url, {Key? key}) : super(key: key);

  @override
  _AddLinkState createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  late String _linkValue;
  final List<String> _sections = [
    'Basic Details',
    'Additional Details',
    'Location',
    'Social Channel',
    'Game Channel',
    'Featured Content'
  ];

  String _selectedValue = '';

  AtCategory _getCategory() {
    switch (_selectedValue) {
      case 'Basic Details':
        return AtCategory.DETAILS;
      case 'Additional Details':
        return AtCategory.ADDITIONAL_DETAILS;
      case 'Location':
        return AtCategory.LOCATION;
      case 'Social Channel':
        return AtCategory.SOCIAL;
      case 'Game Channel':
        return AtCategory.GAMER;
      case 'Featured Content':
        return AtCategory.FEATURED;
      default:
        return AtCategory.DETAILS;
    }
  }

  @override
  void initState() {
    _linkValue = widget.url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      bottomSheet: InkWell(
        onTap: _selectedValue == ''
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    'Select a section',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 1),
                ));
              }
            : () {
                SetupRoutes.push(context, Routes.CREATE_CUSTOM_ADD_LINK,
                    arguments: {
                      'value': _linkValue,
                      'category': _getCategory()
                    });
              },
        child: Container(
            alignment: Alignment.center,
            height: 70.toHeight,
            width: SizeConfig().screenWidth,
            color: _selectedValue == ''
                ? ColorConstants.dullColor(
                    color: (Theme.of(context).scaffoldBackgroundColor ==
                            ColorConstants.black
                        ? ColorConstants.DARK_GREY
                        : ColorConstants.black),
                    opacity: 0.5)
                : (Theme.of(context).scaffoldBackgroundColor ==
                        ColorConstants.black
                    ? ColorConstants.DARK_GREY
                    : ColorConstants.black),
            child: Text(
              'Next',
              style: CustomTextStyles.customTextStyle(ColorConstants.white,
                  size: 18),
            )),
      ),
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text(
          'Select a section',
          style: CustomTextStyles.customBoldTextStyle(
              Theme.of(context).primaryColor,
              size: 16),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return _radioButtons(_sections[index]);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: _sections.length),
    );
  }

  Widget _radioButtons(String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedValue = value;
        });
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 16.toWidth, vertical: 4.toHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: CustomTextStyles.customTextStyle(
                  Theme.of(context).primaryColor,
                  size: 16),
            ),
            Transform.scale(
  scale: 1.4,
  child: Radio<String>(
    value: value,
    groupValue: _selectedValue,
    activeColor: Theme.of(context).primaryColor,
    splashRadius: 5,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onChanged: (String? newValue) {
      setState(() {
        _selectedValue = newValue!;
      });
    },
  ),
),

          ],
        ),
      ),
    );
  }
}
