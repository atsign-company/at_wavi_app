import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:at_common_flutter/services/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class WebsiteScreen extends StatefulWidget {
  final String title;
  final String url;
  final bool isShareProfileScreen;

  const WebsiteScreen(
      {Key? key,
      required this.title,
      required this.url,
      this.isShareProfileScreen = false})
      : super(key: key);

  @override
  _WebsiteScreenState createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  late WebViewController webViewController;
  late bool isLoading;

  @override
  void initState() {
    super.initState();

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              // on page started codes
            });
          },
          onProgress: (int progress) {},
          onPageFinished: (String url) async {
            setState(() {
              isLoading = false;
            });
            if (widget.isShareProfileScreen) {
              await Future.delayed(const Duration(milliseconds: 1000));

              webViewController.runJavaScriptReturningResult(
                "(document.getElementsByClassName('share-btn')[3]).click()",
              );
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
      )
      ..runJavaScriptReturningResult('');

    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: ColorConstants.black,
            size: 25.toHeight,
          ),
        ),
        title: Text(widget.title, style: CustomTextStyles.black(size: 18)),
      ),
      body: Stack(children: [
        WebViewWidget(
          controller: webViewController,
          gestureRecognizers: {
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()..onUpdate = (_) {},
            ),
          },
        ),
        /*WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureRecognizers: {
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()..onUpdate = (_) {},
            )
          },
          onWebViewCreated: (WebViewController c) {
            setState(() {
              controller = c;
            });
          },
          onPageStarted: (String s) async {
            setState(() {
              // on page started codes
            });
          },
          onPageFinished: (test1) async {
            setState(() {
              loading = false;
            });
            if (widget.isShareProfileScreen) {
              await Future.delayed(
                  Duration(milliseconds: 1000)); // To let complete page load
              if (controller != null) {
                controller!.evaluateJavascript(
                    "(document.getElementsByClassName('share-btn')[3]).click()");
              }
            }
          },
        ),*/

        isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                  ColorConstants.black,
                )),
              )
            : const SizedBox()
      ]),
    );
  }
}
