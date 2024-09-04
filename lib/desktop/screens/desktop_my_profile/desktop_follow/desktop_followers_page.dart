import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/textfields/desktop_textfield.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/view_models/follow_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/desktop_atsign_widget.dart';

enum FollowListType { followers, following }

class DesktopFollowersPage extends StatefulWidget {
  final FollowListType followListType;

  const DesktopFollowersPage({
    Key? key,
    required this.followListType,
  }) : super(key: key);

  @override
  _DesktopFollowersPageState createState() => _DesktopFollowersPageState();
}

class _DesktopFollowersPageState extends State<DesktopFollowersPage>
    with AutomaticKeepAliveClientMixin<DesktopFollowersPage> {
  final textEditingController = TextEditingController();


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appTheme = AppTheme.of(context);
    SizeConfig().init(context);
    return Consumer<FollowService>(builder: (context, provider, _) {
      List<String?> users = [];
      switch (widget.followListType) {
        case FollowListType.followers:
          users = provider.followers.list ?? [];
          break;
        case FollowListType.following:
          users = provider.following.list ?? [];
          break;
      }
      users = users
          .where((element) =>
              (element?.contains(textEditingController.text.trim()) ?? false))
          .toList();

      return Container(
        color: appTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: DesktopDimens.paddingNormal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DesktopTextField(
              controller: textEditingController,
              hint: Strings.desktop_search_sign,
              backgroundColor: appTheme.secondaryBackgroundColor,
              borderRadius: 10,
              hasUnderlineBorder: false,
              contentPadding: 0,
              onChanged: (text) {
                setState(() {});
              },
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
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  bool isFollowingThisAtSign =
                      Provider.of<FollowService>(context, listen: false)
                          .isFollowing(users[index] ?? '');
                  return DesktopAtSignWidget(
                    atSign: users[index] ?? '',
                    isFollowing: isFollowingThisAtSign,
                    onFollowPressed: () {
                      unfollowAtSign(users[index] ?? '');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void unfollowAtSign(String atSign) async {
    await Provider.of<FollowService>(context, listen: false)
        .performFollowUnfollow(atSign);
    setState(() {});
  }
}
