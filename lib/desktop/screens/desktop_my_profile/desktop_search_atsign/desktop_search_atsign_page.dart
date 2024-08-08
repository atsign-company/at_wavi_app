import 'package:at_wavi_app/desktop/screens/desktop_my_profile/desktop_follow/widgets/desktop_user_widget.dart';
import 'package:at_wavi_app/desktop/screens/desktop_user_profile/desktop_user_profile_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/load_status.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/textfields/desktop_textfield.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_search_atsign_model.dart';

class DesktopSearchAtSignPage extends StatefulWidget {
  const DesktopSearchAtSignPage({Key? key}) : super(key: key);

  @override
  _DesktopSearchAtSignPageState createState() =>
      _DesktopSearchAtSignPageState();
}

class _DesktopSearchAtSignPageState extends State<DesktopSearchAtSignPage> {
  late DesktopSearchAtSignModel _model;
  User? user;
  final textController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopSearchAtSignModel(userPreview: userPreview);
        return _model;
      },
      child: Container(
        color: appTheme.backgroundColor,
        width: DesktopDimens.sideMenuWidth + 80,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: DesktopDimens.paddingLarge),
            SizedBox(
              width: DesktopDimens.sideMenuWidth + 80,
              child: Row(
                children: [
                  Expanded(
                    child: DesktopTextField(
                      controller: textController,
                      hint: Strings.desktop_search_sign,
                      backgroundColor: appTheme.secondaryBackgroundColor,
                      borderRadius: 10,
                      hasUnderlineBorder: false,
                      contentPadding: 0,
                      prefixIcon: Container(
                        width: 30,
                        margin: const EdgeInsets.only(left: 10, bottom: 1),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: '@',
                                  style: TextStyle(
                                    color: appTheme.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _model.searchAtSignAccount(keyword: textController.text);
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
            ),
            const SizedBox(height: DesktopDimens.paddingNormal),
            Expanded(
              child: Consumer<DesktopSearchAtSignModel>(
                builder: (_, model, child) {
                  if (model.searchStatus == LoadStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: appTheme.primaryColor,
                      ),
                    );
                  } else if (model.searchStatus == LoadStatus.success) {
                    if (model.searchInstance.isEmpty) {
                      return Center(
                        child: Text(
                          Strings.desktop_empty,
                          style: appTheme.textTheme.bodyLarge,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.searchInstance.length,
                        itemBuilder: (context, index) {
                          return DesktopUserWidget(
                            user: model.searchInstance[index].user,
                            // title: _displayingName(
                            //   firstname: model.users[index].firstname,
                            //   lastname: model.users[index].lastname,
                            // ),
                            // subTitle: '@${model.users[index].atsign}',
                            onPressed: () {
                              _openUser(model.searchInstance[index].user,
                                  model.searchInstance[index].fieldOrders);
                            },
                          );
                        },
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            const SizedBox(height: DesktopDimens.paddingNormal),
          ],
        ),
      ),
    );
  }

  void _openUser(User user, Map<String, List<String>> fieldOrders) {
    FieldOrderService().setPreviewOrder = {...fieldOrders};
    Provider.of<UserPreview>(context, listen: false).setUser = user;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DesktopUserProfilePage(),
      ),
    );
  }
}
