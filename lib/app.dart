import 'dart:async';
import 'dart:io';

import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/view_models/deep_link_provider.dart';
import 'package:at_wavi_app/view_models/follow_service.dart';

// import 'package:at_wavi_app/services/follow_service.dart';
import 'package:at_wavi_app/screens/options.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/internet_connectivity_checker.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'desktop/routes/desktop_routes.dart';
import 'desktop/services/theme/app_theme.dart';
import 'desktop/services/theme/inherited_app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String? initialRoute;
  late Map<String, WidgetBuilder> routes;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      initialRoute = SetupRoutes.initialRoute;
      routes = SetupRoutes.routes;
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      initialRoute = DesktopSetupRoutes.initialRoute;
      routes = DesktopSetupRoutes.routes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
              create: (context) => ThemeProvider()),
          ChangeNotifierProvider<FollowService>(
              create: (context) => FollowService()),
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider()),
          ChangeNotifierProvider<UserPreview>(
              create: (context) => UserPreview()),
          ChangeNotifierProvider<SetPrivateState>(
              create: (context) => SetPrivateState()),
          ChangeNotifierProvider<DeepLinkProvider>(
              create: (context) => DeepLinkProvider()),
          ChangeNotifierProvider<InternetConnectivityChecker>(
              create: (context) => InternetConnectivityChecker()),
        ],
        child: MaterialAppClass(
          initialRoute: initialRoute,
          routes: routes,
        ));
  }
}

final StreamController<AppTheme> appThemeController =
    StreamController<AppTheme>.broadcast();

class MaterialAppClass extends StatelessWidget {
  final String? initialRoute;
  final Map<String, WidgetBuilder> routes;

  const MaterialAppClass({Key? key, 
    required this.initialRoute,
    required this.routes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;

    /// MaterialApp for desktop
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      /// Mock data
      // Provider.of<UserPreview>(context, listen: false).setUser = MockData.getMockUser;
      // FieldOrderService().setPreviewOrder = MockData.getMockPreviewOrders;
      // FieldOrderService().setFieldOrder = MockData.getMockFieldOrders;

      return StreamBuilder<AppTheme>(
        stream: appThemeController.stream,
        initialData: AppTheme.from(brightness: brightness),
        builder: (context, snapshot) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          // theme: ((Provider.of<ThemeProvider>(context)
          //     .currentAtsignThemeData
          //     ?.scaffoldBackgroundColor ==
          //     ColorConstants.black)
          //     ? Themes.darkTheme(highlightColor: Colors.transparent)
          //     : Themes.lightTheme(highlightColor: Colors.transparent)),

          // AppTheme appTheme = snapshot.data ?? AppTheme.from();
          AppTheme appTheme = AppTheme.from(
            brightness: (themeProvider
                        .currentAtsignThemeData?.scaffoldBackgroundColor ==
                    ColorConstants.black)
                ? Brightness.dark
                : Brightness.light,
            primaryColor:
                themeProvider.currentAtsignThemeData?.highlightColor ??
                    ColorConstants.green,
          );
          return InheritedAppTheme(
            theme: appTheme,
            child: MaterialApp(
              builder: (BuildContext context, Widget? child) {
                final data = MediaQuery.of(context);
                return MediaQuery(
                  data: data.copyWith(textScaler: const TextScaler.linear(1)),
                  child: child!,
                );
              },
              title: 'AtSign wavi',
              debugShowCheckedModeBanner: false,
              initialRoute: initialRoute,
              navigatorKey: NavService.navKey,
              theme: appTheme.toThemeData(),
              routes: routes,
            ),
          );
        },
      );
    }

    /// MaterialApp for mobile
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final data = MediaQuery.of(context);
        return GestureDetector(
          onVerticalDragDown: (__) {
            // When running in iOS, dismiss the keyboard when when user scrolls
            if (Platform.isIOS) hideKeyboard(context);
          },
          child: MediaQuery(
            data: data.copyWith(textScaler: const TextScaler.linear(1)),
            child: child!,
          ),
        );
      },
      title: 'AtSign wavi',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      navigatorKey: NavService.navKey,
      theme: ((Provider.of<ThemeProvider>(context)
                  .currentAtsignThemeData
                  ?.scaffoldBackgroundColor ==
              ColorConstants.black)
          ? Themes.darkTheme(highlightColor: Colors.transparent)
          : Themes.lightTheme(highlightColor: Colors.transparent)),
      //  ?? Themes.lightTheme(highlightColor: Colors.transparent),
      // theme: Themes.lightTheme(highlightColor: Colors.transparent),
      routes: routes,
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
