// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/view_models/base_model.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkProvider extends BaseModel {
  DeepLinkProvider();

  final String NEW_DATA = 'new_data';
  final String INITIAL_DATA = 'initial_data';
  // ignore: unused_field
  late StreamSubscription<dynamic> _intentDataStreamSubscription;
  bool _receiveIntentStarted = false, _deepLinkStarted = false;
  String searchedAtsign = '';

  init() {
    if (!_receiveIntentStarted) {
      _receiveIntent();
      _receiveIntentStarted = true;
    }

    if (!_deepLinkStarted) {
      _deepLink();
      _deepLinkStarted = true;
    }
  }

  _deepLink() async {
    try {
      //when app is in background.
      linkStream.listen((String? link) {
        print('uni link data: $link');
        if (link != null) {
          searchedAtsign = link.replaceAll('atprotocol://persona/@', '');
          setStatus(NEW_DATA, Status.Done);
          setStatus(NEW_DATA, Status.Idle);
        }
      });

      //when app is opened with deep link.
      String? initialLink = await getInitialLink();
      if (initialLink != null) {
        searchedAtsign = initialLink.replaceAll('atprotocol://persona/@', '');
        setStatus(INITIAL_DATA, Status.Done);
        setStatus(INITIAL_DATA, Status.Idle);
      }
    } catch (e) {
      print('error in uni link');
    }
  }

  _receiveIntent() async {
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      print("Incoming Shared file in home :${value.map((f) => f.path).join(",")}");
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      print('Incoming images Value in home  is $value');
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      print('Incoming text Value in home  is $value');
      // ignore: unnecessary_null_comparison
      if ((value != null) && (!value.contains('atprotocol://persona'))) {
        SetupRoutes.push(NavService.navKey.currentContext!, Routes.ADD_LINK,
            arguments: {'url': value});
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if ((value != null) && (!value.contains('atprotocol://persona'))) {
        SetupRoutes.push(NavService.navKey.currentContext!, Routes.ADD_LINK,
            arguments: {'url': value});
      }
      print('Incoming text in home  when app is closed $value');
    });
  }
}
