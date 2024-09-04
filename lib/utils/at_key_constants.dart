import 'package:at_wavi_app/utils/constants.dart';

class AtKeyConstants {
  static const String keyExtension = '';
  static const String themePreference = 'THEME$keyExtension';
  static const String highlightColorPreference = 'THEME_COLOR$keyExtension';
}

///Texts used across [@me].
class AtText {
  // final String atsign;
  // AtText({this.atsign});

  static const IS_DELETED = '_deleted';
  static const MAP_PREVIEW = 'Map Preview';
  static const SHOW_RADIUS_OVERLAY = 'Show radius overlay';
  static const CONFIRM = "I've saved my private key. ";
  static const APP_NAMESPACE = 'persona';
  static const PUBLIC = 'public';
  static const CUSTOM = 'custom';
  static var rootDomain = MixedConstants.ROOT_DOMAIN;
  static const EMPTY = '';
  static const SCAN = 'scan';
  static const COPYRIGHT = '2019-2021 THE @ COMPANY';
  static const HOME_START = 'Hi';
  static const HEADER = 'All info is public unless set to ';
  static const HEADER_SUB = 'Private';
  static const BUTTON_DETAILS = 'Next: Add More Info';
  static const BUTTON_DASHBOARD = 'Next: Dashboard';
  static const BUTTON_SOCIAL = 'Next: Social';
  static const SOURCE_CAMERA = 'Take a new picture';
  static const SOURCE_GALLERY = 'Pick from Gallery';
  static const SOURCE_REMOVE = 'Remove Photo';
  static const CROPPER = 'Cropper';
  static const PROFILE_OPTIONS = 'Camera/Gallery';
  static const PRIVATE_IMAGE = 'Set image to private';
  static const PRIVATE_KEY_CAUTION =
      "Please save your private key. For security reasons, it's highly recommended to save it in GDrive/iCloudDrive.";
  static const APP_REGEX = '.*persona@';
  static const APP_KEY_SPLIT_REGEX = '(w*.)*persona@';
  static const TITLE_ERROR_DIALOG = 'Error';
  static const ADD_AT_SIGN = 'ADD ANOTHER @SIGN';
  static const VISIT_DASHBOARD = 'Visit Dashboard';
  static const CONFIGURE_ATSIGN = "Let's configure your new atSign!";
  static const CUSTOM_CONTENT = 'CUSTOM CONTENT';
  static const PROFILE_IMAGE_LIMIT = "Allows maximum of 512KB";
  static const PRIVACY_POLICY_URL =
      'https://atsign.com/apps/wavi/privacy-policy/';
  static const PRIVACY_POLICY = 'Privacy Policy';
  static const URL_PATTERN =
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.?[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$";
  static const YOUTUBE_PATTERN =
      r"^(?:https?:\/\/)?(?:m\.|www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((?<id>\w|-){11})(?:\S+)?$";
  static const SOCIAL_URL_PATTERN =
      r"^(https|http):\/\/(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(\/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$";
  static const APP_URL = 'atprotocol://persona';
}
