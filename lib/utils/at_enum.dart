import 'package:flutter/material.dart';

/// if new field is added here, please add the same the same into _toMap() fundtion of ChangePrivacyService
enum FieldsEnum {
  PRIVATEACCOUNT,
  ATSIGN,
  IMAGE,
  FIRSTNAME,
  LASTNAME,
  EMAIL,
  PHONE,
  ABOUT,
  PRONOUN,
  LOCATION,
  LOCATIONNICKNAME,
  TWITTER,
  FACEBOOK,
  LINKEDIN,
  INSTAGRAM,
  YOUTUBE,
  MEDIUM,
  TUMBLR,
  TIKTOK,
  SNAPCHAT,
  PINTEREST,
  GITHUB,
  PS4,
  XBOX,
  STEAM,
  DISCORD,
  TWITCH,
  HTMLTOASTVIEW,
  SWITCH,
  EPIC,
}

extension FieldsEnumValues on FieldsEnum {
  String get label {
    switch (this) {
      case FieldsEnum.PRIVATEACCOUNT:
        return 'PRIVATEACCOUNT';
      case FieldsEnum.FIRSTNAME:
        return 'FIRSTNAME';
      case FieldsEnum.LASTNAME:
        return 'LASTNAME';
      case FieldsEnum.PHONE:
        return 'PHONE';
      case FieldsEnum.EMAIL:
        return 'EMAIL';
      case FieldsEnum.ABOUT:
        return 'ABOUT ME';
      case FieldsEnum.LOCATION:
        return 'SHOW ON MAP';
      case FieldsEnum.LOCATIONNICKNAME:
        return 'LOCATION NICKNAME';
      case FieldsEnum.TWITTER:
        return 'TWITTER';
      case FieldsEnum.INSTAGRAM:
        return 'INSTAGRAM';
      case FieldsEnum.FACEBOOK:
        return 'FACEBOOK';
      case FieldsEnum.LINKEDIN:
        return 'LINKEDIN';
      case FieldsEnum.TUMBLR:
        return 'TUMBLR';
      case FieldsEnum.MEDIUM:
        return 'MEDIUM';
      case FieldsEnum.YOUTUBE:
        return 'YOUTUBE';
      case FieldsEnum.PRONOUN:
        return 'PRONOUN';
      case FieldsEnum.PS4:
        return 'PS4';
      case FieldsEnum.XBOX:
        return 'XBOX';
      case FieldsEnum.STEAM:
        return 'STEAM (PC)';
      case FieldsEnum.DISCORD:
        return 'DISCORD';
      case FieldsEnum.HTMLTOASTVIEW:
        return 'HTMLTOASTVIEW';
      case FieldsEnum.TIKTOK:
        return 'TIKTOK';
      case FieldsEnum.SNAPCHAT:
        return 'SNAPCHAT';
      case FieldsEnum.PINTEREST:
        return 'PINTEREST';
      case FieldsEnum.GITHUB:
        return 'GITHUB';
      case FieldsEnum.TWITCH:
        return 'TWITCH';
      case FieldsEnum.SWITCH:
        return 'SWITCH';
      case FieldsEnum.EPIC:
        return 'EPIC';
      default:
        return '';
    }
  }

  String get name {
    return toString().split('.').last.toLowerCase();
  }

  String get title {
    return this == FieldsEnum.ABOUT
        ? 'About Me'
        : toString().split('.').last.toLowerCase();
  }

  String get hintText {
    switch (this) {
      case FieldsEnum.PRIVATEACCOUNT:
        return 'Private Account';

      case FieldsEnum.FIRSTNAME:
        return 'First Name';

      case FieldsEnum.LASTNAME:
        return 'Last Name';

      case FieldsEnum.PHONE:
        return 'Phone Number';

      case FieldsEnum.EMAIL:
        return 'Email Address';

      case FieldsEnum.ABOUT:
        return 'About';

      case FieldsEnum.PRONOUN:
        return 'Preferred Pronoun';

      case FieldsEnum.LOCATIONNICKNAME:
        return 'Home, Office, School, etc...';

      case FieldsEnum.LOCATION:
        return 'Type postal code, city, country, or street';

      case FieldsEnum.TWITTER:
        return 'Twitter';
      case FieldsEnum.INSTAGRAM:
        return 'Instagram';
      case FieldsEnum.FACEBOOK:
        return 'Facebook';
      case FieldsEnum.LINKEDIN:
        return 'Linkedin';
      case FieldsEnum.TUMBLR:
        return 'Tumblr';
      case FieldsEnum.MEDIUM:
        return 'Medium';
      case FieldsEnum.YOUTUBE:
        return 'Youtube';

      case FieldsEnum.PS4:
        return 'PS4';

      case FieldsEnum.XBOX:
        return 'XBox';

      case FieldsEnum.STEAM:
        return 'Steam (PC)';

      case FieldsEnum.DISCORD:
        return 'Discord';

      case FieldsEnum.TIKTOK:
        return 'Tiktok';
      case FieldsEnum.SNAPCHAT:
        return 'Snapchat';
      case FieldsEnum.PINTEREST:
        return 'Pinterest';
      case FieldsEnum.GITHUB:
        return 'Github';
      case FieldsEnum.TWITCH:
        return 'Twitch';
      case FieldsEnum.SWITCH:
        return 'Switch';
      case FieldsEnum.EPIC:
        return 'Epic';

      default:
        return '';
    }
  }
}

valueOf(String property) {
  for (var field in FieldsEnum.values) {
    if (property == field.name) {
      return field;
    }
  }
  return '';
}

RegExp getRegex(String name) {
  switch (name) {
    case "Email":
      return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    case "Twitter":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?twitter\.com\/([a-zA-Z0-9_]+)");
    case "Instagram":
      return RegExp(
          r"http(?:s)?:\/\/(?:www\.)?instagram\.com\/([a-zA-Z0-9_]+)");
    case "Facebook":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?facebook\.com\/([a-zA-Z0-9_]+)");
    case "Linkedin":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?linkedin\.com\/([a-zA-Z0-9_]+)");
    case "Youtube":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?youtube\.com\/([a-zA-Z0-9@_]+)");
    case "Tumblr":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?tumblr\.com\/([a-zA-Z0-9_]+)");
    case "Medium":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?medium\.com\/([a-zA-Z0-9@_]+)");
    case "Snapchat":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?snapchat\.com\/([a-zA-Z0-9_]+)");
    case "Tiktok":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?ticktok\.com\/([a-zA-Z0-9_]+)");
      case "Github":
      return RegExp(r"http(?:s)?:\/\/(?:www\.)?github\.com\/([a-zA-Z0-9_]+)");
    case "Pinterest":
      return RegExp(
          r"http(?:s)?:\/\/(?:www\.)?pinterest\.com\/([a-zA-Z0-9_]+)");
    default:
      return RegExp("");
  }
}

String getUrl(String name, String value) {
  switch (name) {
    case "Twitter":
      return "https://www.twitter.com/$value";
    case "Instagram":
      return "https://www.instagram.com/$value";
    case "Facebook":
      return "https://www.facebook.com/$value";
    case "Linkedin":
      return "https://www.linkedin.com/in/$value";
    case "Youtube":
      return "https://www.youtube.com/$value";
    case "Tumblr":
      return "https://www.tumblr.com/$value";
    case "Medium":
      return "https://www.medium.com/$value";
    case "Snapchat":
      return "https://www.snapchat.com/$value";
    case "Tiktok":
      return "https://www.tiktok.com/$value";
    case "Pinterest":
      return "https://www.pinterest.com/$value";
      case "Github":
      return "https://www.github.com/$value";
    default:
      return "";
  }
}

// enum CATEGORY { DETAILS, ADDITIONAL_DETAILS, LOCATION, SOCIAL, GAMER, FEATURED }

/// new app doesnt have IMAGE
enum AtCategory {
  IMAGE,
  DETAILS,
  LOCATION,
  SOCIAL,
  GAMER,

  /// Added for new wavi app
  ADDITIONAL_DETAILS,
  FEATURED
}

extension AtCategoryValues on AtCategory {
  String get name {
    return toString().split('.').last;
  }

  String get label {
    switch (this) {
      case AtCategory.IMAGE:
        return 'Image';

      case AtCategory.DETAILS:
        return 'Details';

      case AtCategory.SOCIAL:
        return 'Social';

      case AtCategory.GAMER:
        return 'Gaming';

      /// Added for new wavi app
      case AtCategory.LOCATION:
        return 'Location';
      case AtCategory.FEATURED:
        return 'Featured';
      case AtCategory.ADDITIONAL_DETAILS:
        return 'Additional_Details';

      default:
        return '';
    }
  }

  String get newLabel {
    switch (this) {
      case AtCategory.IMAGE:
        return 'Image';
      case AtCategory.DETAILS:
        return 'Contact';
      case AtCategory.SOCIAL:
        return 'Social';
      case AtCategory.GAMER:
        return 'Gaming';
      case AtCategory.LOCATION:
        return 'Location';
      case AtCategory.FEATURED:
        return 'Featured';
      case AtCategory.ADDITIONAL_DETAILS:
        return 'About';
      default:
        return '';
    }
  }
}

enum Operation { EDIT, DELETE, PRINT, SAVE }

List<String> tooltipOperations = [Operation.EDIT.name, Operation.DELETE.name];

extension OperationValues on Operation {
  String get name {
    switch (this) {
      case Operation.DELETE:
        return 'Delete';

      case Operation.EDIT:
        return 'Edit';

      case Operation.PRINT:
        return 'Print';

      case Operation.SAVE:
        return 'Save';

      default:
        return '';
    }
  }
}

enum LocationJson { RADIUS, LOCATION }

extension LocationJsonValues on LocationJson {
  String get name {
    return toString().split('.').last.toLowerCase();
  }
}

enum OnboardStatus {
  ATSIGN_NOT_FOUND,
  PRIVATE_KEY_NOT_FOUND,
  ACTIVATE,
  RESTORE
}

// extension on OnboardStatus {
//   bool isEqual => this.toString().split
// }

extension status on OnboardStatus {
  String get value => toString().split('.').last.toUpperCase();
  String get name {
    switch (this) {
      case OnboardStatus.ACTIVATE:
        return 'Activate';

      case OnboardStatus.RESTORE:
        return 'Restore';

      default:
        return '';
    }
  }
}

enum RootEnvironment { Staging, Production, Testing }

extension value on RootEnvironment {
  String get domain {
    switch (this) {
      case RootEnvironment.Staging:
        return 'root.atsign.wtf';

      case RootEnvironment.Production:
        return 'root.atsign.org';

      case RootEnvironment.Testing:
        return 'vip.ve.atsign.zone';

      default:
        return '';
    }
  }

  String get website {
    switch (this) {
      case RootEnvironment.Staging:
        return 'https://atsign.wtf';

      case RootEnvironment.Production:
        return 'https://atsign.com';

      case RootEnvironment.Testing:
        return 'https://atsign.wtf';

      default:
        return '';
    }
  }
  // String get apikey {
  //   switch(this){
  //     case RootEnvironment.Staging:
  //       return AppConstants.deviceapikey;
  //
  //     case RootEnvironment.Production:
  //       return AppConstants.prodapikey;
  //
  //     case RootEnvironment.Testing:
  //       return AppConstants.deviceapikey;
  //
  //     default:
  //       return '';
  //

  //   }
  // }

  String get previewLink {
    switch (this) {
      case RootEnvironment.Staging:
        return 'https://directory.atsign.wtf/';

      case RootEnvironment.Production:
        return 'https://wavi.ng/';


      default:
        return '';
    }
  }
}

enum CustomContentStatus { Exists, Success, Fails }

enum CustomContentType { Text, Link, Number, Image, Youtube, Html, Location }

extension values on CustomContentType {
  String get name {
    switch (this) {
      case CustomContentType.Text:
        return 'Text';

      case CustomContentType.Link:
        return 'Link';

      case CustomContentType.Number:
        return 'Number';

      case CustomContentType.Image:
        return 'Image';

      case CustomContentType.Youtube:
        return 'Youtube';

      case CustomContentType.Html:
        return 'Html';

      case CustomContentType.Location:
        return 'Location';

      default:
        return '';
    }
  }

  String get label {
    if (this == CustomContentType.Youtube) {
      return 'YouTube';
    } else if (this == CustomContentType.Html) {
      return 'HTML';
    } else {
      return name;
    }
  }

  TextInputType get keyboardType {
    switch (this) {
      case CustomContentType.Link:
        return TextInputType.url;

      case CustomContentType.Youtube:
        return TextInputType.url;

      case CustomContentType.Number:
        return TextInputType.number;

      default:
        return TextInputType.text;
    }
  }
}

CustomContentType customContentNameToType(String name) {
  switch (name) {
    case 'Text':
      return CustomContentType.Text;

    case 'Link':
      return CustomContentType.Link;

    case 'Number':
      return CustomContentType.Number;

    case 'Image':
      return CustomContentType.Image;

    case 'Youtube':
      return CustomContentType.Youtube;

    case 'Html':
      return CustomContentType.Html;

    default:
      return CustomContentType.Text;
  }
}

enum FollowType { notification, website }
