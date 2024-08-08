import 'package:at_wavi_app/utils/colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          message,
          style: const TextStyle(
            color: ColorConstants.white,
            fontSize: 14,
          ),
        ),
      ),
      backgroundColor: color,
      duration: const Duration(
        seconds: 2,
      ),
    ),
  );
}

String? toAccountNameWithAtsign(String? atsign) {
  if (atsign != null) {
    if (atsign.startsWith("@")) {
      return atsign;
    } else {
      return "@$atsign";
    }
  } else {
    return null;
  }
}

String getTitle(String title) {
  switch (title) {
    case 'firstname':
      return 'First Name';
    case 'lastname':
      return 'Last Name';
    case 'phone':
      return 'Phone';
    case 'email':
      return 'Email';
    case 'pronoun':
      return 'Preferred Pronouns';
    case 'about':
      return 'About';
    case 'twitter':
      return 'Twitter';
    case 'facebook':
      return 'Facebook';
    case 'linkedin':
      return 'Linkedin';
    case 'instagram':
      return 'Instagram';
    case 'youtube':
      return 'Youtube';
    case 'tumblr':
      return 'Tumblr';
    case 'medium':
      return 'Medium';
    case 'ps4':
      return 'PS4';
    case 'xbox':
      return 'XBox';
    case 'steam':
      return 'Steam';
    case 'discord':
      return 'Discord';
    default:
      return title;
  }
}
