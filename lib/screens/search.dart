import 'package:at_common_flutter/widgets/custom_input_field.dart';
import 'package:at_wavi_app/common_components/header.dart';
import 'package:at_wavi_app/common_components/person_horizontal_tile.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/images.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
                top: 30.0.toHeight, left: 15.toWidth, right: 15.toWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(
                  leading: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 5),
                      const Text('Search'),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.center,
                  child: CustomInputField(
                    width: 343.toWidth,
                    height: 60.toHeight,
                    hintText: '',
                    prefix: Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 6),
                      child: Image.asset(Images.atIcon),
                    ),
                    value: (String s) {
                      print('text : $s');
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Recent Search',
                  style: TextStyles.boldText(ColorConstants.black),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: List.generate(40, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CustomPersonHorizontalTile(
                            title: 'User name',
                            subTitle: '@atsign',
                          ),
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
