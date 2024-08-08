import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/screens/add_link/add_link.dart';
import 'package:at_wavi_app/screens/add_link/create_custom_add_link/create_custom_add_link.dart';
import 'package:at_wavi_app/screens/edit_persona/add_custom_field.dart';
import 'package:at_wavi_app/screens/edit_persona/edit_category_fields.dart';
import 'package:at_wavi_app/screens/edit_persona/edit_persona.dart';
import 'package:at_wavi_app/screens/edit_persona/reorder_fields.dart';
import 'package:at_wavi_app/screens/following.dart';
import 'package:at_wavi_app/screens/home/home.dart';
import 'package:at_wavi_app/screens/location/location_widget.dart';
import 'package:at_wavi_app/screens/location/widgets/create_custom_location.dart';
import 'package:at_wavi_app/screens/location/widgets/preview_location.dart';
import 'package:at_wavi_app/screens/location/widgets/selected_location.dart';
import 'package:at_wavi_app/screens/search.dart';
import 'package:at_wavi_app/screens/website_webview/website_webview.dart';
import 'package:at_wavi_app/screens/welcome.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../screens/qr_screen.dart';

class SetupRoutes {
  static String initialRoute = Routes.WELCOME_SCREEN;
  // static String initialRoute = Routes.ADD_LINK;
  static Map<String, WidgetBuilder> get routes {
    return {
      Routes.WELCOME_SCREEN: (context) => const Welcome(),
      Routes.EDIT_PERSONA: (context) => const EditPersona(),
      Routes.HOME: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return HomeScreen(
            themeData: args['themeData'],
            isPreview: args['isPreview'],
            key: args['key'],
          );
        }

        return const HomeScreen();
      },
      Routes.ADD_LINK: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return AddLink(args['url']);
        }
        return const AddLink('');
      },
      Routes.FOLLOWING_SCREEN: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return Following(
            forSearchedAtsign: args['forSearchedAtsign'] ?? false,
            searchedAtsign: args['searchedAtsign'],
            tabIndex: args['tabIndex'] ?? 0,
            themeData: args['themeData'],
          );
        }
        return const SizedBox();
      },
      Routes.SEARCH_SCREEN: (context) => const Search(),
      Routes.LOCATION_WIDGET: (context) => const LocationWidget(),
      Routes.SELECTED_LOCATION: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return SelectedLocation(args['displayName'], args['point'],
              callbackFunction: args['callbackFunction']);
        }
        return const SelectedLocation('', LatLng(0, 0));
      },
      Routes.CREATE_CUSTOM_ADD_LINK: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return CreateCustomAddLink(args['value'], category: args['category']);
        }

        return const CreateCustomAddLink('', category: AtCategory.DETAILS);
      },
      Routes.PREVIEW_LOCATION: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return PreviewLocation(
              title: args['title'],
              latLng: args['latLng'],
              zoom: args['zoom'],
              diameterOfCircle: args['diameterOfCircle']);
        }

        return const SizedBox();
      },
      Routes.CREATE_CUSTOM_LOCATION: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return CreateCustomLocation(
              basicData: args['basicData'], onSave: args['onSave']);
        }

        return const CreateCustomLocation();
      },
      Routes.FAQS: (context) => const WebsiteScreen(
            title: 'FAQ',
            url: '${MixedConstants.WEBSITE_URL}/faqs',
          ),
      Routes.TERMS_CONDITIONS_SCREEN: (context) => const WebsiteScreen(
            title: 'Terms and Conditions',
            url: '${MixedConstants.WEBSITE_URL}/terms-conditions',
          ),
      Routes.WEB_VIEW: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;

          return WebsiteScreen(
            title: args['title'],
            url: args['url'],
          );
        } else {
          return const SizedBox();
        }
      },
      Routes.EDIT_CATEGORY_FIELDS: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;

          return EditCategoryFields(
            category: args['category'],
            filedHeading: args['filedHeading'],
          );
        } else {
          return const SizedBox();
        }
      },
      Routes.ADD_CUSTOM_FIELD: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;

          return AddCustomField(
            onSave: args['onSave'],
            isEdit: args['isEdit'],
            basicData: args['basicData'],
            category: args['category'],
          );
        } else {
          return const SizedBox();
        }
      },
      Routes.REORDER_FIELDS: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;

          return ReorderFields(
            category: args['category'],
            onSave: args['onSave'],
          );
        } else {
          return const SizedBox();
        }
      },
      Routes.QR_SCREEN: (context) {
        if ((ModalRoute.of(context) != null) &&
            (ModalRoute.of(context)!.settings.arguments != null)) {
          Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return QrScreen(
            atSign: args['atSign'],
          );
        } else {
          return const SizedBox();
        }
      }
    };
  }

  static Future push(BuildContext context, String value,
      {Object? arguments, Function? callbackAfterNavigation}) {
    return Navigator.of(context)
        .pushNamed(value, arguments: arguments)
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }

  // ignore: always_declare_return_types
  static replace(BuildContext context, String value,
      {dynamic arguments, Function? callbackAfterNavigation}) {
    Navigator.of(context)
        .pushReplacementNamed(value, arguments: arguments)
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }

  // ignore: always_declare_return_types
  static pushAndRemoveAll(BuildContext context, String value,
      {dynamic arguments, Function? callbackAfterNavigation}) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(
      value,
      (_) => false,
      arguments: arguments,
    )
        .then((response) {
      if (callbackAfterNavigation != null) {
        callbackAfterNavigation();
      }
    });
  }
}
