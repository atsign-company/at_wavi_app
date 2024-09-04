import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';

class HomePrivateAccount extends StatefulWidget {
  final ThemeData themeData;
  const HomePrivateAccount(this.themeData, {Key? key}) : super(key: key);

  @override
  _HomePrivateAccountState createState() => _HomePrivateAccountState();
}

class _HomePrivateAccountState extends State<HomePrivateAccount> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.lock,
              size: 25,
              color: widget.themeData.primaryColor,
            ),
            SizedBox(height: 10.toHeight),
            Text('Private profile',
                style: CustomTextStyles.customBoldTextStyle(
                    widget.themeData.primaryColor,
                    size: 18)),
            SizedBox(height: 10.toHeight),
            Text(
              "This user prefers to keep an air of mystery about them.",
              style: TextStyles.grey15,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
