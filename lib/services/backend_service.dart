import 'dart:io';
import 'package:at_client/at_client.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class BackendService {
  static final BackendService _singleton = BackendService._internal();
  BackendService._internal();

  factory BackendService() {
    return _singleton;
  }

  late AtClientService atClientServiceInstance;
  late AtClientImpl atClientInstance;
  String? currentAtSign;
  AtClientPreference? atClientPreference;
  Directory? downloadDirectory;
  Map<String?, AtClientService> atClientServiceMap = {};

  onboard(String atSign, {AtClientPreference? atClientPreference}) async {
    var atClientPrefernce;
    await getAtClientPreference()
        .then((value) => atClientPrefernce = value)
        .catchError((e) => print(e));
    Onboarding(
      atsign: atSign,
      context: NavService.navKey.currentContext!,
      atClientPreference: atClientPrefernce,
      domain: MixedConstants.ROOT_DOMAIN,
      appAPIKey: MixedConstants.devAPIKey,
      onboard: (value, atsign) async {
        String? atSign = value[atsign]!.atClient!.currentAtSign;
        atClientInstance = value[atsign]!.atClient!;
        atClientServiceMap = value;
        currentAtSign = atSign;
        await atClientServiceMap[atSign]!.makeAtSignPrimary(atSign!);
        await startMonitor(atsign: atsign, value: value);
        SetupRoutes.pushAndRemoveAll(
            NavService.navKey.currentContext!, Routes.EDIT_PERSONA);
      },
      onError: (error) {
        print('Onboarding throws $error error');
      },
    );
  }

  Future<AtClientPreference> getAtClientPreference() async {
    if (Platform.isIOS) {
      downloadDirectory =
          await path_provider.getApplicationDocumentsDirectory();
    } else {
      downloadDirectory = await path_provider.getExternalStorageDirectory();
    }

    var _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = downloadDirectory!.path
      ..downloadPath = downloadDirectory!.path
      ..namespace = MixedConstants.appNamespace
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = MixedConstants.ROOT_DOMAIN
      ..syncRegex = MixedConstants.regex
      ..outboundConnectionTimeout = MixedConstants.TIME_OUT
      ..hiveStoragePath = downloadDirectory!.path;
    return _atClientPreference;
  }

  Future<bool> startMonitor({value, atsign}) async {
    if (value.containsKey(atsign)) {
      currentAtSign = atsign;
      atClientServiceMap = value;
      atClientInstance = value[atsign].atClient;
      atClientServiceInstance = value[atsign];
    }

    String? privateKey = await getPrivateKey(atsign);
    await atClientInstance.startMonitor(privateKey!, _notificationCallBack);
    print('monitor started');
    return true;
  }

  _notificationCallBack() {}

  ///Fetches privatekey for [atsign] from device keychain.
  Future<String?> getPrivateKey(String atsign) async {
    return await atClientServiceInstance.getPrivateKey(atsign);
  }

  ///Fetches atsign from device keychain.
  Future<String?> getAtSign() async {
    await getAtClientPreference().then((value) {
      return atClientPreference = value;
    });

    atClientServiceInstance = AtClientService();

    return await atClientServiceInstance.getAtSign();
  }
}
