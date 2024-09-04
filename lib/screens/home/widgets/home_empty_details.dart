import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';

class HomeEmptyDetails extends StatefulWidget {
  const HomeEmptyDetails({Key? key}) : super(key: key);

  @override
  _HomeEmptyDetailsState createState() => _HomeEmptyDetailsState();
}

class _HomeEmptyDetailsState extends State<HomeEmptyDetails> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            Text(
              'Edit your profile',
              style: Theme.of(context).brightness == Brightness.light
                  ? TextStyles.black18bold
                  : TextStyles.white18bold,
            ),
            SizedBox(height: 10.toHeight),
            Text(
              '''
Edit your profile and add details to start 
sharing your profile with others.''',
              style: TextStyles.grey15,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25.toHeight),
            GestureDetector(
              onTap: () {
                SetupRoutes.push(
                    NavService.navKey.currentContext!, Routes.EDIT_PERSONA);
              },
              child: Text('Add Details', style: TextStyles.orange18bold),
            ),
          ],
        ),
      ),
    );
  }
}
