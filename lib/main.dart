import 'dart:async';
import 'dart:io';

import 'package:at_wavi_app/app.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZoned<Future<void>>(() async {
    print(await path_provider.getApplicationDocumentsDirectory());
    if (Platform.isLinux || Platform.isMacOS) {
      await DesktopWindow.setWindowSize(const Size(1024, 576));
      await DesktopWindow.setMinWindowSize(const Size(1024, 576));
      // DartVLC.initialize();
    } else if (Platform.isWindows) {
      await DesktopWindow.setMinWindowSize(const Size(1024, 576));
    }
    await MixedConstants.load();
    // ignore: unawaited_futures
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((_) {
      runApp(const MyApp());
    });
  });
}
