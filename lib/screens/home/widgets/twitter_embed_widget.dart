import 'dart:convert';

import 'package:at_wavi_app/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TwitterEmbedWidget extends StatefulWidget {
  final String twitterUsername;

  const TwitterEmbedWidget({
    Key? key,
    required this.twitterUsername,
  }) : super(key: key);

  @override
  State<TwitterEmbedWidget> createState() => _TwitterEmbedWidgetState();
}

class _TwitterEmbedWidgetState extends State<TwitterEmbedWidget> {
  final String twitterEmbedText = '''
<!DOCTYPE html>
<html>
   <head>
      <title>Page Title</title>
   </head>
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <body>
      <a class="twitter-timeline" href="https://twitter.com/{username}?ref_src=twsrc%5Etfw">Tweets by {username}</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
   </body>
</html>
''';
  late String url;
  late bool isLoading;
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    url = Uri.dataFromString(
            twitterEmbedText.replaceAll('{username}', widget.twitterUsername),
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'))
        .toString();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) async {
            if (request.url == url) {
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.prevent;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url ?? ''));

    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.toHeight,
      child: WebViewWidget(
        controller: webViewController,
      ),
      /*WebView(
        javascriptMode: JavascriptMode.unrestricted,
        gestureRecognizers: Set()
          ..add(Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer())),
        onWebViewCreated: (controller) {
          controller.loadUrl(url);
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url == url) {
            return NavigationDecision.navigate;
          } else {
            return NavigationDecision.prevent;
          }
        },
      ),*/
    );
  }
}
