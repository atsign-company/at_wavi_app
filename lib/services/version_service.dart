import 'dart:convert';
import 'dart:io';

import 'package:at_common_flutter/at_common_flutter.dart';
import 'package:at_wavi_app/model/version.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/utils/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class VersionService {
  VersionService._();
  static final VersionService _internal = VersionService._();
  factory VersionService.getInstance() {
    return _internal;
  }

  Version? version;
  late PackageInfo packageInfo;
  bool isBackwardCompatible = true, isNewVersionAvailable = false;

  Future<void> init() async {
    isBackwardCompatible = true;
    isNewVersionAvailable = false;
    await getVersion();
    compareVersions();
    showVersionUpgradeDialog();
  }

  Future<void> getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();

    try {
      var response = await http.get(Uri.parse(MixedConstants.RELEASE_TAG_API));

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);

        version = Version(
          latestVersion: decodedResponse['latestVersion'],
          minVersion: decodedResponse['minimumVersion'],
        );
      } else {
        SnackbarService().showSnackbar(
          NavService.navKey.currentContext!,
          Strings.appVersionFetchError,
        );
      }
    } catch (e) {
      SnackbarService().showSnackbar(
        NavService.navKey.currentContext!,
        Strings.releaseTagError,
      );
    }
  }

  void showVersionUpgradeDialog() {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        mobileUpgradedDialog();
      } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        desktopUpgradeDialog();
      }
    } catch (e) {
      SnackbarService().showSnackbar(
        NavService.navKey.currentContext!,
        Strings.upgradeDialogShowError,
      );
    }
  }

  void desktopUpgradeDialog() {
    if (isNewVersionAvailable && version != null) {
      showDialog(
          context: NavService.navKey.currentContext!,
          barrierDismissible: isBackwardCompatible ? true : false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.toWidth),
              ),
              content: SizedBox(
                width: 300.toWidth,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                          'You can now update this app from ${packageInfo.version}.${packageInfo.buildNumber} to ${version!.latestVersion}')
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: desktopUpdateHandler,
                  child: const Text(Strings.update),
                ),
                isBackwardCompatible
                    ? TextButton(
                        onPressed: () {
                          if (Navigator.of(NavService.navKey.currentContext!)
                              .canPop()) {
                            Navigator.of(NavService.navKey.currentContext!)
                                .pop();
                          }
                        },
                        child: const Text(Strings.mayBeLater),
                      )
                    : const SizedBox()
              ],
            );
          });
    }
  }

  void compareVersions() {
    if (version == null) {
      return;
    }

    try {
      var currentPackageNumbers = packageInfo.version.split('.');
      var latestPackageNumbers = version!.latestVersion.split('.');
      var minPackageNumbers = version!.minVersion.split('.');

      // checking for new version
      if (int.parse(latestPackageNumbers[0]) >
          int.parse(currentPackageNumbers[0])) {
        isNewVersionAvailable = true;
      } else if (int.parse(latestPackageNumbers[1]) >
          int.parse(currentPackageNumbers[1])) {
        isNewVersionAvailable = true;
      } else if (int.parse(latestPackageNumbers[2]) >
          int.parse(currentPackageNumbers[2])) {
        isNewVersionAvailable = true;
      }

      // checking for backward compatibility
      if (int.parse(minPackageNumbers[0]) >
          int.parse(currentPackageNumbers[0])) {
        isBackwardCompatible = false;
      } else if (int.parse(minPackageNumbers[1]) >
          int.parse(currentPackageNumbers[1])) {
        isBackwardCompatible = false;
      } else if (int.parse(minPackageNumbers[2]) >
          int.parse(currentPackageNumbers[2])) {
        isBackwardCompatible = false;
      }

      print(
        'isNewVersionAvailable : $isNewVersionAvailable, isback: $isBackwardCompatible',
      );
    } catch (e) {
      print('error in comparing versions');
    }
  }

  Future<void> mobileUpgradedDialog() async {
    final newVersion = NewVersion();
    final status = await newVersion.getVersionStatus();

    if (status != null && isNewVersionAvailable && version != null) {
      newVersion.showUpdateDialog(
          context: NavService.navKey.currentContext!,
          versionStatus: status,
          allowDismissal: isBackwardCompatible ? true : false,
          dialogText:
              'You can now update this app from ${packageInfo.version}.${packageInfo.buildNumber} to ${version!.latestVersion}');
    }
  }

  Future<void> desktopUpdateHandler() async {
    late String url;
    if (Platform.isMacOS) {
      url = MixedConstants.MACOS_STORE_LINK;
    } else if (Platform.isWindows) {
      url = MixedConstants.WINDOWS_STORE_LINK;
    } else if (Platform.isLinux) {
      url = MixedConstants.LINUX_STORE_LINK;
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

class SnackbarService {
  static final SnackbarService _singleton = SnackbarService._internal();
  SnackbarService._internal();
  factory SnackbarService() {
    return _singleton;
  }

  void showSnackbar(BuildContext context, String title, {Color? bgColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        content: Text(title),
      ),
    );
  }
}
