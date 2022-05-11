import 'dart:convert';

import 'package:at_client/at_client.dart';
import 'package:at_wavi_app/desktop/routes/desktop_route_names.dart';
import 'package:at_wavi_app/desktop/screens/desktop_share_profile/desktop_share_profile_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/utils/utils.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_logo.dart';
import 'package:at_wavi_app/model/at_follows_value.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/services/search_service.dart';
import 'package:at_wavi_app/view_models/follow_service.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DesktopProfileInfoPage extends StatefulWidget {
  final String? atSign;
  final VoidCallback? onFollowerPressed;
  final VoidCallback? onFollowingPressed;
  final bool isPreview;

  DesktopProfileInfoPage({
    Key? key,
    required this.atSign,
    required this.isPreview,
    this.onFollowerPressed,
    this.onFollowingPressed,
  }) : super(key: key);

  @override
  _DesktopProfileInfoPageState createState() => _DesktopProfileInfoPageState();
}

class _DesktopProfileInfoPageState extends State<DesktopProfileInfoPage> {
  late User _currentUser;
  bool _isSearchScreen = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {}

  @override
  Widget build(BuildContext context) {
    if (widget.isPreview) {
      _currentUser = Provider.of<UserPreview>(context).user()!;
    } else if (Provider.of<UserProvider>(context).user != null) {
      _currentUser = Provider.of<UserProvider>(context).user!;
    } else {
      _currentUser = User(
        atsign: AtClientManager.getInstance().atClient.getCurrentAtSign(),
      );
    }
    if ((widget.isPreview) &&
        (_currentUser.atsign !=
            BackendService().atClientInstance.getCurrentAtSign())) {
      _isSearchScreen = true;
    }
    String? previewUserName =
        Provider.of<UserPreview>(context, listen: false).user()?.atsign;
    String? currentUserName =
        Provider.of<UserProvider>(context, listen: false).user?.atsign;
    bool isMine = widget.isPreview &&
        (toAccountNameWithAtsign(previewUserName) ==
            toAccountNameWithAtsign(currentUserName));
    print(isMine);
    final appTheme = AppTheme.of(context);
    return Container(
      color: appTheme.primaryLighterColor,
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: DesktopDimens.paddingLarge),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: DesktopDimens.paddingNormal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (_currentUser.image.value != null)
                      ? Container(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(80.0),
                            child: Image.memory(
                              _currentUser.image.value,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          width: 120,
                          height: 120,
                          child: Icon(
                            Icons.account_circle,
                            size: 120,
                          ),
                        ),
                  SizedBox(height: DesktopDimens.paddingNormal),
                  _buildNameWidget(),
                  SizedBox(height: DesktopDimens.paddingSmall),
                  Text(
                    _currentUser.atsign,
                    style: appTheme.textTheme.subtitle1?.copyWith(
                      color: appTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: DesktopDimens.paddingLarge),
                  Consumer<FollowService>(builder: (context, _provider, _) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.onFollowerPressed,
                      child: _buildInteractiveItem(
                          Strings.desktop_followers,
                          _isSearchScreen
                              ? (SearchService()
                                          .getAlreadySearchedAtsignDetails(
                                              _currentUser.atsign)
                                          ?.followers_count ??
                                      '-')
                                  .toString()
                              : '${followsCount(isFollowers: true)}',
                          appTheme),
                    );
                  }),
                  SizedBox(height: DesktopDimens.paddingSmall),
                  Consumer<FollowService>(builder: (context, _provider, _) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.onFollowingPressed,
                      child: _buildInteractiveItem(
                          Strings.desktop_following,
                          _isSearchScreen
                              ? (SearchService()
                                          .getAlreadySearchedAtsignDetails(
                                              _currentUser.atsign)
                                          ?.following_count ??
                                      '-')
                                  .toString()
                              : '${followsCount(isFollowers: false)}',
                          appTheme),
                    );
                  }),
                  SizedBox(height: DesktopDimens.paddingLarge),
                  !widget.isPreview
                      ? Column(
                          children: [
                            DesktopButton(
                              width: double.infinity,
                              height: DesktopDimens.buttonHeight,
                              backgroundColor: Colors.transparent,
                              titleColor: appTheme.primaryColor,
                              borderColor: appTheme.primaryColor,
                              title: Strings.desktop_edit_profile,
                              onPressed: _openEditProfile,
                            ),
                            SizedBox(height: DesktopDimens.paddingNormal),
                            DesktopButton(
                              width: double.infinity,
                              height: DesktopDimens.buttonHeight,
                              title: Strings.desktop_share_profile,
                              backgroundColor: appTheme.primaryColor,
                              onPressed: shareProfile,
                            ),
                          ],
                        )
                      : Consumer<FollowService>(
                          builder: (context, provider, _) {
                          final isFollowing =
                              provider.isFollowing(_currentUser.atsign);
                          if (!isMine) {
                            return DesktopButton(
                              width: double.infinity,
                              height: DesktopDimens.buttonHeight,
                              backgroundColor: appTheme.primaryColor,
                              title: isFollowing
                                  ? Strings.desktop_unfollow
                                  : Strings.desktop_follow,
                              onPressed: () async {
                                unfollowAtSign(_currentUser.atsign);
                              },
                            );
                          } else {
                            return Container();
                          }
                        }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void unfollowAtSign(String atSign) async {
    await Provider.of<FollowService>(context, listen: false)
        .performFollowUnfollow(atSign);
    setState(() {});
  }

  Widget _buildHeader() {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: DesktopDimens.paddingLarge),
            child: Center(
              child: DesktopLogo(),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Visibility(
              visible: widget.isPreview,
              child: DesktopIconButton(
                iconData: Icons.close_rounded,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameWidget() {
    final appTheme = AppTheme.of(context);
    final user = Provider.of<UserProvider>(context).user;
    String name = '';
    if (widget.isPreview) {
      name = context.select<UserPreview, String>(
        (userPreview) {
          return _displayingName(
            firstName: userPreview.user()?.firstname.value,
            lastName: userPreview.user()?.lastname.value,
          );
        },
      );
    } else if (user != null) {
      name = context.select<UserProvider, String>(
        (userProvider) {
          return _displayingName(
            firstName: userProvider.user?.firstname.value,
            lastName: userProvider.user?.lastname.value,
          );
        },
      );
    }
    return Text(
      name,
      style: appTheme.textTheme.headline6?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
    );
  }

  _buildInteractiveItem(String title, String subTitle, AppTheme appTheme) {
    return Row(
      children: [
        Text(
          title,
          style: appTheme.textTheme.subtitle2?.copyWith(
            color: appTheme.secondaryTextColor,
            fontWeight: FontWeight.normal,
          ),
        ),
        Spacer(),
        Text(
          subTitle,
          style: appTheme.textTheme.subtitle1?.copyWith(
            color: appTheme.primaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _displayingName({dynamic firstName, dynamic lastName}) {
    String _name = '';
    _name = _currentUser.firstname.value ?? '';
    if (_currentUser.lastname.value != null) {
      _name = '$_name ${_currentUser.lastname.value}';
    }

    if (_name.isEmpty) {
      _name = _currentUser.atsign.replaceFirst('@', '');
    }
    return _name;
  }

  void _openEditProfile() async {
    FieldOrderService().setPreviewOrder = {...FieldOrderService().fieldOrders};
    var userJson =
        User.toJson(Provider.of<UserProvider>(context, listen: false).user!);
    User previewUser = User.fromJson(json.decode(json.encode(userJson)));
    Provider.of<UserPreview>(context, listen: false).setUser = previewUser;
    await Navigator.pushNamed(context, DesktopRoutes.DESKTOP_EDIT_PROFILE);
    _initData();
    setState(() {});
  }

  String followsCount({bool isFollowers: false}) {
    AtFollowsData atFollowsData;
    var followsProvider = Provider.of<FollowService>(
        NavService.navKey.currentContext!,
        listen: false);
    if (!followsProvider.isFollowersFetched && isFollowers) {
      return '0';
    }

    if (!followsProvider.isFollowingFetched && !isFollowers) {
      return '0';
    }

    if (isFollowers) {
      atFollowsData = followsProvider.followers;
    } else {
      atFollowsData = followsProvider.following;
    }

    int num = atFollowsData.list!.length;

    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  void shareProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            DesktopShareProfilePage(atSign: _currentUser.atsign),
      ),
    );
    // try {
    //   launch('https://wavi.ng/${_currentUser.atsign}');
    // } catch (e) {}
  }
}
