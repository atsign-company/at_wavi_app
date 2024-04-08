// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

class MixedConstants {
  // static const String WEBSITE_URL = 'https://staging.atsign.wtf/';
  static const String WEBSITE_URL = 'https://atsign.com/';

  // for local server
  // static const String ROOT_DOMAIN = 'vip.ve.atsign.zone';

  // for staging server
  // static const String ROOT_DOMAIN = 'root.atsign.wtf';
  // for production server
  static const String ROOT_DOMAIN = 'root.atsign.org';

  static String devAPIKey = '560w-806a-zzev-z02i-6a3p';

  static const int ROOT_PORT = 64;

  static const String TERMS_CONDITIONS = 'https://atsign.com/terms-conditions/';

  static const String FILEBIN_URL = 'https://filebin2.aws.atsign.cloud/';
  // static const String PRIVACY_POLICY = 'https://atsign.com/privacy-policy/';
  static const String PRIVACY_POLICY =
      "https://atsign.com/apps/atmosphere/atmosphere-privacy/";

  static const String WAVI_API = 'https://wavi.ng/api/?atp=';

  // the time to await for file transfer acknowledgement in milliseconds
  static const int TIME_OUT = 60000;

  static String appNamespace = 'wavi';
  static String regex =
      '(.$appNamespace|atconnections|[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12})';

  static const String syncRegex = '.(wavi|persona)@';

  static const String FOLLOWING_KEY = 'following_by_self';
  static const String FOLLOWERS_KEY = 'followers_of_self';

  static String MAP_KEY = dotenv.get('MAP_KEY');
  static String API_KEY = dotenv.get('API_KEY');

  static String NONCE_URL = dotenv.get('NONCE_URL');
  static String IMAGE_API_KEY = dotenv.get('IMAGE_API_KEY');
  
  static final String twitterBearerToken = '';
  static const int responseTimeLimit = 30;
  static const String fieldOrderKey = 'field_order_of_self';

  /// Load the environment variables from the .env file.
  /// Directly calls load from the dotenv package.
  static Future<void> load() => dotenv.load();

  /// release tags
  static const MACOS_STORE_LINK = 'https://apps.apple.com/app/id1583231748';
  static const WINDOWS_STORE_LINK =
      'https://www.microsoft.com/en-in/p/wavi/9pnfnw1mqqwc?activetab=pivot:overviewtab';
  static const RELEASE_TAG_API =
      'https://atsign-foundation.github.io/wavi/version.html';
  static const LINUX_STORE_LINK = 'https://atsign.com/apps/';
}
