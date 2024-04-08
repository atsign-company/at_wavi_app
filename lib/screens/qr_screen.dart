import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/text_styles.dart';

class QrScreen extends StatefulWidget {
  QrScreen({required this.atSign});

  String atSign;

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  ThemeData? _themeData;
  late Color _highlightColor;

  TextEditingController _commentController = new TextEditingController();

  _getThemeData() async {
    _themeData =
        await Provider.of<ThemeProvider>(context, listen: false).getTheme();
    _highlightColor =
        Provider.of<ThemeProvider>(context, listen: false).highlightColor!;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _getThemeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_themeData == null) {
      return CircularProgressIndicator();
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: _themeData!.primaryColor),
            toolbarHeight: 55,
            title: Text(
              'Share Profile',
              style: CustomTextStyles.customBoldTextStyle(
                  _themeData!.primaryColor,
                  size: 16),
            ),
            centerTitle: false,
            backgroundColor: _themeData!.scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                    child: Text(
                  "Scan the QR Code with Wavi App",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )),
                SizedBox(
                  height: 30,
                ),
                QrImageView(
                  data: widget.atSign,
                  size: 180,
                  eyeStyle: QrEyeStyle(
                      color: _themeData!.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 20.0,
                        endIndent: 10.0,
                        thickness: 1.5,
                        color: _themeData!.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 10.0,
                        endIndent: 20.0,
                        thickness: 1.5,
                        color: _themeData!.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 15.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      label: Text("Comment"),
                      labelStyle: TextStyle(color: _highlightColor),
                      focusColor: _highlightColor,
                      fillColor: _highlightColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: _highlightColor, width: 2.0),
                      ),
                      border: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1.5),
                      ),
                    ),
                    minLines: 3,
                    maxLines: 3,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    backgroundColor: _highlightColor,
                  ),
                  onPressed: () {
                    // print(_commentController.text.length);
                    Share.share("https://wavi.ng/" + widget.atSign.toString(),
                        subject: _commentController.text);
                    _commentController.clear();
                  },
                  child: Text('Share Via App'),
                )
              ],
            ),
          )),
    );
  }
}
