import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_reorder_basic_info/desktop_reorder_basic_info_page.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showError({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(reason: SnackBarClosedReason.remove);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

// Future<dynamic> showNotificationsDialog(
//   BuildContext context, {
//   required String atSign,
// }) async {
//   return showDialog<dynamic>(
//     context: context,
//     barrierDismissible: true,
//     barrierColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return Center(
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//                 //    border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(5),
//                 color: Colors.white),
//             padding: EdgeInsets.all(4.0),
//             child: DesktopNotificationPage(
//               mainContext: context,
//               atSign: atSign,
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// Future showReOderTabsPopUp(
//     BuildContext context, Function(List<String>) updateFields) async {
//   var currentScreen =
//       await getStringFromSharedPreferences(key: Strings.desktop_current_tab);
//   AtCategory atCategory;
//   atCategory = AtCategory.values.firstWhere(
//     (element) {
//       return element.name == currentScreen;
//     },
//     orElse: () => AtCategory.OTHERS,
//   );
//
//   final results = await showDialog<List<String>>(
//     context: context,
//     builder: (BuildContext context) => Dialog(
//       backgroundColor: Colors.transparent,
//       child: DesktopReorderBasicDetailPage(
//         atCategory: atCategory,
//       ),
//     ),
//   );
//   if (results != null) {
//     List<String> fields = results;
//     updateFields(fields);
//   }
// }

Future showReOderFieldsPopUp(BuildContext context, AtCategory atCategory,
    Function() updateFields) async {
  final results = await showDialog<List<String>>(
    context: context,
    builder: (BuildContext context) => Dialog(
      backgroundColor: Colors.transparent,
      child: DesktopReorderBasicDetailPage(
        atCategory: atCategory,
      ),
    ),
  );
  if (results != null) {
    updateFields();
  }
}
