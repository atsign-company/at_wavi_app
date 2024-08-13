import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_wavi_app/common_components/custom_input_field.dart';
import 'package:at_wavi_app/common_components/empty_widget.dart';
import 'package:at_wavi_app/common_components/header.dart';
import 'package:at_wavi_app/model/at_follows_value.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/screens/home/widgets/Home_details.dart';
import 'package:at_wavi_app/screens/home/widgets/home_channel.dart';
import 'package:at_wavi_app/screens/home/widgets/home_empty_details.dart';
import 'package:at_wavi_app/screens/home/widgets/home_featured.dart';
import 'package:at_wavi_app/screens/home/widgets/home_private_account.dart';
import 'package:at_wavi_app/screens/options.dart';
import 'package:at_wavi_app/services/backend_service.dart';
import 'package:at_wavi_app/services/common_functions.dart';
import 'package:at_wavi_app/services/field_order_service.dart';
import 'package:at_wavi_app/view_models/base_model.dart';
import 'package:at_wavi_app/view_models/deep_link_provider.dart';
import 'package:at_wavi_app/view_models/follow_service.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/services/search_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/internet_connectivity_checker.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:at_location_flutter/utils/constants/constants.dart'
    as location_package_constants;

import '../../desktop/utils/utils.dart';
import '../qr_screen.dart';

enum HOME_TABS { DETAILS, CHANNELS, FEATURED }

class HomeScreen extends StatefulWidget {
  final ThemeData? themeData;
  final bool isPreview;
  const HomeScreen({this.themeData, this.isPreview = false, Key? key})
      : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HOME_TABS _currentTab = HOME_TABS.DETAILS;
  bool _isDark = false;
  ThemeData? _themeData;
  late String _name;
  late User _currentUser;
  late var deepLinkProviderListener;

  bool _isSearchScreen = false;
  bool _isMine = false;

  bool hideHeader = false, loadingSearchedAtsign = false;
  String searchedAtsign = '';
  late AnimationController _inputBoxController;

  @override
  void initState() {
    _inputBoxController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<InternetConnectivityChecker>(context, listen: false)
          .checkConnectivity();
    });

    checkForUpdate();
    startDeepLinkProviderListener();

    if (widget.isPreview) {
      _currentUser = Provider.of<UserPreview>(context, listen: false).user()!;
    } else if (Provider.of<UserProvider>(context, listen: false).user != null) {
      _currentUser = Provider.of<UserProvider>(context, listen: false).user!;
    } else {
      _currentUser = User(
          atsign: AtClientManager.getInstance().atClient.getCurrentAtSign());
    }

    if ((widget.isPreview) &&
        (_currentUser.atsign !=
            BackendService().atClientInstance.getCurrentAtSign())) {
      _isSearchScreen = true;
    }

    initPackages();
    _getThemeData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      //commenting out since its not being used

      // var followsProvider = Provider.of<FollowService>(
      //     NavService.navKey.currentContext!,
      //     listen: false);
      // TODO: we have to optimize fetching contact details
      // await followsProvider.fetchAtsignDetails(followsProvider.followers.list!);
      // await followsProvider.fetchAtsignDetails(followsProvider.following.list!,
      // isFollowing: true);
      // Provider.of<FollowService>(NavService.navKey.currentContext!,
      //         listen: false)
      //     .init();
    });

    String? previewUserName =
        Provider.of<UserPreview>(context, listen: false).user()?.atsign;
    String? currentUserName =
        Provider.of<UserProvider>(context, listen: false).user?.atsign;
    _isMine = widget.isPreview &&
        (toAccountNameWithAtsign(previewUserName) ==
            toAccountNameWithAtsign(currentUserName));

    super.initState();
  }

  Future<void> checkForUpdate() async {
    final newVersion = NewVersion();

    // commenting out since its not being used
    // final status = await newVersion.getVersionStatus();

    //// for forced version update
    // newVersion.showUpdateDialog(
    //   context: context,
    //   versionStatus: status,
    //   allowDismissal: false,
    // );

    newVersion.showAlertIfNecessary(context: context);
  }

  getCurrentUserName() {
    if (widget.isPreview &&
        Provider.of<UserPreview>(context, listen: false).user() != null) {
      _currentUser = Provider.of<UserPreview>(context, listen: false).user()!;
    } else if (Provider.of<UserProvider>(context, listen: false).user != null) {
      _currentUser = Provider.of<UserProvider>(context, listen: false).user!;
    } else {
      _currentUser = User(
          atsign: AtClientManager.getInstance().atClient.getCurrentAtSign());
    }

    _name = _currentUser.firstname.value ?? '';
    if (_currentUser.lastname.value != null) {
      _name = '$_name ${_currentUser.lastname.value}';
    }

    if (_name.isEmpty) {
      _name = _currentUser.atsign.replaceFirst('@', '');
    }
  }

  initPackages() async {
    location_package_constants.MixedConstants.setMapKey(MixedConstants.MAP_KEY);
    location_package_constants.MixedConstants.setApiKey(MixedConstants.API_KEY);
  }

  _getThemeData() async {
    if (widget.themeData != null) {
      _themeData = widget.themeData!;
    } else {
      _themeData =
          await Provider.of<ThemeProvider>(context, listen: false).getTheme();
    }

    if (_themeData!.scaffoldBackgroundColor ==
        Themes.darkTheme().scaffoldBackgroundColor) {
      _isDark = true;
    }

    if (mounted) {
      setState(() {});
    }
  }

  _animate() {
    if (_inputBoxController.isCompleted) {
      setState(() {
        hideHeader = false;
        searchedAtsign = '';
        loadingSearchedAtsign = false;
      });
      _inputBoxController.reverse();
      return;
    }

    setState(() {
      hideHeader = true;
    });
    _inputBoxController.forward();
  }

  startDeepLinkProviderListener() async {
    Provider.of<DeepLinkProvider>(context, listen: false).init();

    deepLinkProviderListener = context.read<DeepLinkProvider>();
    deepLinkProviderListener.addListener(() {
      var provider = Provider.of<DeepLinkProvider>(context, listen: false);
      if (provider.status[provider.INITIAL_DATA] == Status.Done) {
        _initialDeepLinkData(provider.searchedAtsign);
      }

      if (provider.status[provider.NEW_DATA] == Status.Done) {
        _newDeepLinkData(provider.searchedAtsign);
      }
    });
  }

  _newDeepLinkData(String searchedAtsign) async {
    if (mounted) {
      if (!_inputBoxController.isCompleted) {
        _animate(); // only animate if not already open
      }
      this.searchedAtsign = searchedAtsign;
      _searchProfile();
    }
  }

  _initialDeepLinkData(String searchedAtsign) async {
    if (mounted) {
      this.searchedAtsign = searchedAtsign;
      hideHeader = true;
      _inputBoxController.value = _inputBoxController.upperBound;
      _searchProfile(); // setState() will happen here
    }
  }

  @override
  void dispose() {
    deepLinkProviderListener.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUserName();

    SizeConfig().init(context);
    if (_themeData == null) {
      return const CircularProgressIndicator();
    } else {
      return Scaffold(
        backgroundColor: _themeData!.scaffoldBackgroundColor,
        // TODO: commented notification screen because we don't show notification updates
        // bottomNavigationBar: widget.isPreview
        //     ? null
        //     : BottomNavigationBar(
        //         backgroundColor: _themeData!.scaffoldBackgroundColor,
        //         items: const <BottomNavigationBarItem>[
        //           BottomNavigationBarItem(
        //             icon: Icon(Icons.person),
        //             label: '',
        //           ),
        //           BottomNavigationBarItem(
        //             icon: Icon(Icons.notifications),
        //             label: '',
        //           )
        //         ],
        //         currentIndex: _selectedIndex,
        //         selectedItemColor: ColorConstants.orange,
        //         onTap: _onItemTapped,
        //         // elevation: 0,
        //       ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15.0.toWidth),
            child: RefreshIndicator(
              onRefresh: () async {
                if (_isSearchScreen) {
                  var searchRes = await SearchService().getAtsignDetails(
                      _currentUser.atsign,
                      serverLookup: true);
                  if (searchRes != null) {
                    Provider.of<UserPreview>(context, listen: false).setUser =
                        searchRes.user;
                    FieldOrderService().setPreviewOrder =
                        searchRes.fieldOrders;
                    _currentUser =
                        Provider.of<UserPreview>(context, listen: false)
                            .user()!;
                  } else {
                    BackendService().showSyncSnackbar();
                  }
                }
                if (mounted) setState(() {});
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    header(),
                    hideHeader && loadingSearchedAtsign
                        ? const LinearProgressIndicator()
                        : const SizedBox(),
                    SizedBox(height: 30.toHeight),
                    // content
                    Consumer<UserProvider>(
                      builder: (context, provider, _) {
                        if ((!widget.isPreview) && (provider.user != null)) {
                          _currentUser = provider.user!;
                        } // for image
                        String loggedInUserName = getName(provider.user);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 116.toWidth,
                              height: 116.toWidth,
                              decoration: BoxDecoration(
                                color: ColorConstants.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(60.toWidth),
                              ),
                              child: (_currentUser.image.value != null)
                                  ? CircleAvatar(
                                      radius: 50.toFont,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          Image.memory(_currentUser.image.value)
                                              .image,
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 50.toFont,
                                    ),
                            ),
                            SizedBox(
                              width: 10.toWidth,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _isSearchScreen ? _name : loggedInUserName,
                                    style: TextStyle(
                                        fontSize: 18.toFont,
                                        color: _themeData!.primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 8.toHeight),
                                  Text(
                                    _currentUser.atsign,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: ColorConstants.orange,
                                      fontSize: 18.toFont,
                                    ),
                                  ),
                                  SizedBox(height: 18.5.toHeight),
                                  Divider(
                                    color: _themeData!.highlightColor,
                                  ),
                                  SizedBox(height: 18.5.toHeight),
                                  followersFollowingRow()
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 20.toHeight),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 55.toHeight,
                            child: Consumer<FollowService>(
                                builder: (context, provider, _) {
                              if (_isMine && _isSearchScreen) {
                                return Container();
                              }
                              return TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          _themeData!.highlightColor
                                              .withOpacity(0.1)),
                                ),
                                onPressed: widget.isPreview
                                    ? () async {
                                        if (_isSearchScreen) {
                                          // LoadingDialog()
                                          //     .show(text: 'Updating');
                                          await provider.performFollowUnfollow(
                                              _currentUser.atsign);
                                          // LoadingDialog().hide();
                                          // setState(() {});
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: ColorConstants.RED,
                                            content: Text(
                                              'You are currently in preview mode',
                                              style: CustomTextStyles
                                                  .customTextStyle(
                                                ColorConstants.white,
                                              ),
                                            ),
                                          ));
                                        }
                                      }
                                    : () async {
                                        SetupRoutes.push(
                                            NavService.navKey.currentContext!,
                                            Routes.EDIT_PERSONA);
                                      },
                                child: RichText(
                                  text: TextSpan(
                                    text: _isSearchScreen
                                        ? (provider.isFollowing(
                                                _currentUser.atsign)
                                            ? 'Following'
                                            : 'Follow')
                                        : 'Edit  ',
                                    style: TextStyle(
                                        fontSize: 16.toFont,
                                        color: _themeData!.primaryColor
                                            .withOpacity(0.5)),
                                    children: _isSearchScreen
                                        ? []
                                        : [
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: _themeData!.primaryColor
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 55.toHeight,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(_themeData!
                                        .highlightColor
                                        .withOpacity(0.1)),
                              ),
                              onPressed: widget.isPreview
                                  ? () {
                                      if (_isSearchScreen) {
                                        shareProfile();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          backgroundColor: ColorConstants.RED,
                                          content: Text(
                                            'You are currently in preview mode',
                                            style: CustomTextStyles
                                                .customTextStyle(
                                              ColorConstants.white,
                                            ),
                                          ),
                                        ));
                                      }
                                    }
                                  : () {
                                      shareProfile();
                                    },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Share  ',
                                  style: TextStyle(
                                      fontSize: 16.toFont,
                                      color: _themeData!.primaryColor
                                          .withOpacity(0.5)),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Icon(
                                        Icons.share,
                                        size: 18,
                                        color: _themeData!.primaryColor
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25.toHeight),

                    _isSearchScreen &&
                            SearchService()
                                .getAlreadySearchedAtsignDetails(
                                    _currentUser.atsign)!
                                .isPrivateAccount
                        ? HomePrivateAccount(_themeData!)
                        : const SizedBox(),

                    _isSearchScreen &&
                            SearchService()
                                .getAlreadySearchedAtsignDetails(
                                    _currentUser.atsign)!
                                .isPrivateAccount
                        ? const SizedBox()
                        : Container(
                            height: 70.toHeight,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: _themeData!.primaryColor
                                      .withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentTab = HOME_TABS.DETAILS;
                                      });
                                    },
                                    child: tab('Details', HOME_TABS.DETAILS),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _currentTab = HOME_TABS.CHANNELS;
                                        });
                                      },
                                      child:
                                          tab('Channels', HOME_TABS.CHANNELS)),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentTab = HOME_TABS.FEATURED;
                                      });
                                    },
                                    child: tab('Featured', HOME_TABS.FEATURED),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: _isSearchScreen &&
                              SearchService()
                                  .getAlreadySearchedAtsignDetails(
                                      _currentUser.atsign)!
                                  .isPrivateAccount
                          ? 0
                          : 20.toHeight,
                    ),
                    _isSearchScreen &&
                            SearchService()
                                .getAlreadySearchedAtsignDetails(
                                    _currentUser.atsign)!
                                .isPrivateAccount
                        ? const SizedBox()
                        : Consumer<UserProvider>(
                            builder: (context, provider, _) {
                            return homeContent();
                          })
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget header() {
    return Stack(
      children: [
        hideHeader
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Header(
                  leading: Row(
                    children: [
                      widget.isPreview
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: _themeData!.primaryColor,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(width: 5),
                      Text(
                        widget.isPreview ? 'Preview' : 'My Profile',
                        style: TextStyle(
                            fontSize: 18.toFont,
                            color: _themeData!.primaryColor,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  trailing: widget.isPreview
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    _animate();
                                    // SetupRoutes.push(
                                    //     context, Routes.SEARCH_SCREEN);
                                  },
                                  child: Icon(Icons.search,
                                      size: 25.toFont,
                                      color: _themeData!.primaryColor),
                                ),
                              ),
                              SizedBox(height: 18.5.toHeight),
                              Divider(
                                color: _themeData!.highlightColor,
                              ),
                              SizedBox(height: 18.5.toHeight),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const StadiumBorder(),
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 480.toHeight,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: _themeData!
                                                .scaffoldBackgroundColor,
                                            borderRadius: const BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(12.0),
                                              topRight:
                                                  Radius.circular(12.0),
                                            ),
                                          ),
                                          child: Options(
                                            name: _name,
                                            image: _currentUser.image.value,
                                          ),
                                        );
                                      });
                                },
                                child: Icon(Icons.more_vert,
                                    size: 25.toFont,
                                    color: _themeData!.primaryColor),
                              )
                            ],
                          ),
                        ),
                ),
              ),
        _isSearchScreen
            ? const SizedBox()
            : Positioned(
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.1, 0),
                    end: Offset.zero,
                  ).animate(_inputBoxController),
                  child: CustomInputField(
                    textInputType: TextInputType.visiblePassword,
                    blankSpacesAllowed: false,
                    autoCorrectAllowed: false,
                    padding: const EdgeInsets.only(right: 10),
                    width: 343.toWidth,
                    // height: 60.toHeight,
                    bgColor: ColorConstants.MILD_GREY,
                    hintText: '',
                    height: 50,
                    expands: false,
                    maxLines: 1,
                    icon: loadingSearchedAtsign
                        ? Icons.access_time
                        : Icons.search,
                    secondIcon: Icons.cancel,
                    borderColor: Colors.transparent,
                    focusedBorderColor: Colors.transparent,
                    textColor: ColorConstants.black,
                    initialValue: searchedAtsign,
                    baseOffset: searchedAtsign.length,
                    value: (String s) {
                      setState(() {
                        searchedAtsign = s;
                      });
                    },
                    onSubmitted: (str) {
                      _searchProfile();
                    },
                    onIconTap: () {
                      _searchProfile();
                    },
                    onSecondIconTap: _animate,
                  ),
                ),
              )
      ],
    );
  }

  Widget followersFollowingRow() {
    return Consumer<FollowService>(builder: (context, provider, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                SetupRoutes.push(
                  context,
                  Routes.FOLLOWING_SCREEN,
                  arguments: {
                    'forSearchedAtsign': _isSearchScreen,
                    'searchedAtsign':
                        _isSearchScreen ? _currentUser.atsign : null,
                    'themeData': _themeData,
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isSearchScreen
                        ? (SearchService()
                                    .getAlreadySearchedAtsignDetails(
                                        _currentUser.atsign)
                                    ?.following_count ??
                                '-')
                            .toString()
                        : followsCount(),
                    style: TextStyle(
                        fontSize: 18.toFont,
                        color: _isDark
                            ? _themeData!.primaryColor
                            : _themeData!.highlightColor,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(
                        fontSize: 14.toFont,
                        color: _themeData!.primaryColor.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: GestureDetector(
              onTap: () {
                SetupRoutes.push(
                  context,
                  Routes.FOLLOWING_SCREEN,
                  arguments: {
                    'forSearchedAtsign': _isSearchScreen,
                    'searchedAtsign':
                        _isSearchScreen ? _currentUser.atsign : null,
                    'tabIndex': 1,
                    'themeData': _themeData,
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isSearchScreen
                        ? (SearchService()
                                    .getAlreadySearchedAtsignDetails(
                                        _currentUser.atsign)!
                                    .followers_count ??
                                '-')
                            .toString()
                        : followsCount(isFollowers: true),
                    style: TextStyle(
                        fontSize: 18.toFont,
                        color: _isDark
                            ? _themeData!.primaryColor
                            : _themeData!.highlightColor,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(
                        fontSize: 14.toFont,
                        color: _themeData!.primaryColor.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget tab(String title, HOME_TABS tab) {
    return Container(
      decoration: BoxDecoration(
        color: _currentTab == tab
            ? _themeData!.primaryColorDark
            : _themeData!.scaffoldBackgroundColor,
        border: _currentTab == tab
            ? Border.all(
                color: _isDark
                    ? _themeData!.highlightColor
                    : ColorConstants.lightGrey)
            : null,
        // borderRadius: _currentTab == tab ? BorderRadius.circular(60) : null,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              color: _currentTab == tab
                  ? Colors.white
                  : _themeData!.highlightColor,
              fontSize: 18.toFont),
        ),
      ),
    );
  }

  Widget homeContent() {
    if (_currentTab == HOME_TABS.DETAILS) {
      return CommonFunctions().isFieldsPresentForCategory(AtCategory.DETAILS,
                  isPreview: widget.isPreview) ||
              CommonFunctions().isFieldsPresentForCategory(
                  AtCategory.ADDITIONAL_DETAILS,
                  isPreview: widget.isPreview) ||
              CommonFunctions().isFieldsPresentForCategory(AtCategory.LOCATION,
                  isPreview: widget.isPreview)
          ? HomeDetails(themeData: _themeData, isPreview: widget.isPreview)
          : getEmptyWidget(_themeData!);
    } else if (_currentTab == HOME_TABS.CHANNELS) {
      return CommonFunctions().isFieldsPresentForCategory(AtCategory.GAMER,
                  isPreview: widget.isPreview) ||
              CommonFunctions().isFieldsPresentForCategory(AtCategory.SOCIAL,
                  isPreview: widget.isPreview)
          ? HomeChannels(themeData: _themeData, isPreview: widget.isPreview)
          : getEmptyWidget(_themeData!);
    } else if (_currentTab == HOME_TABS.FEATURED) {
      return CommonFunctions().isTwitterFeatured(isPreview: widget.isPreview) ||
              CommonFunctions().isInstagramFeatured(isPreview: widget.isPreview)
          ? HomeFeatured(
              twitterUsername: _currentUser.twitter.value,
              instagramUsername: _currentUser.instagram.value,
              isPrivateTwitter: _currentUser.twitter.isPrivate,
              isPrivateInstagram: _currentUser.instagram.isPrivate,
              themeData: _themeData)
          : getEmptyWidget(_themeData!);
    } else
      return const SizedBox();
  }

  _searchProfile() async {
    if (searchedAtsign.isEmpty) {
      return;
    }

    if (loadingSearchedAtsign) {
      return;
    }
    if (mounted) {
      setState(() {
        loadingSearchedAtsign = true;
      });
    }

    var searchedAtsignData =
        SearchService().getAlreadySearchedAtsignDetails(searchedAtsign);

    late bool isPresent;
    if (searchedAtsignData != null) {
      isPresent = true;
    } else {
      isPresent = await CommonFunctions().checkAtsign(searchedAtsign);
    }

    if (isPresent) {
      SearchInstance? searchService =
          await SearchService().getAtsignDetails(searchedAtsign);
      User? res = searchService?.user;

      /// in case the search is cancelled, dont do anything
      if (loadingSearchedAtsign) {
        if (searchService == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.RED,
            content: Text(
              'Something went wrong',
              style: CustomTextStyles.customTextStyle(
                ColorConstants.white,
              ),
            ),
          ));
          setState(() {
            loadingSearchedAtsign = false;
          });
          return;
        }

        // Provider.of<UserPreview>(context,
        //         listen: false)
        //     .setSearchedUser(_res);

        Provider.of<UserPreview>(context, listen: false).setUser = res;
        FieldOrderService().setPreviewOrder = searchService.fieldOrders;

        // if already in searched screen then replace
        if (widget.isPreview) {
          await SetupRoutes.replace(context, Routes.HOME, arguments: {
            'key': Key(searchedAtsign),
            'themeData': searchService.currentAtsignThemeData,
            'isPreview': true,
          });
        } else {
          await SetupRoutes.push(context, Routes.HOME, arguments: {
            'key': Key(searchedAtsign),
            'themeData': searchService.currentAtsignThemeData,
            'isPreview': true,
          });
        }

        setState(() {
          loadingSearchedAtsign = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorConstants.RED,
        content: Text(
          '$searchedAtsign not found',
          style: CustomTextStyles.customTextStyle(
            ColorConstants.white,
          ),
        ),
      ));
      setState(() {
        loadingSearchedAtsign = false;
      });
    }
  }

  Widget getEmptyWidget(ThemeData themeData) {
    return _isSearchScreen ? EmptyWidget(themeData) : const HomeEmptyDetails();
  }

  shareProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => QrScreen(atSign: _currentUser.atsign)),
    );
  }

  String getName(User? user) {
    if (user == null) return '';

    String name = '';
    String firstName = '';
    if (user.firstname.value != null) {
      firstName = user.firstname.value;
    }

    if (user.lastname.value != null) {
      name = firstName + (firstName == '' ? '' : ' ') + user.lastname.value;
    }

    if (name == '') {
      name = user.atsign;
    }

    return name;
  }

  String followsCount({bool isFollowers = false}) {
    AtFollowsData atFollowsData;
    var followsProvider = Provider.of<FollowService>(
        NavService.navKey.currentContext!,
        listen: false);
    if (!followsProvider.isFollowersFetched && isFollowers) {
      return '--';
    }

    if (!followsProvider.isFollowingFetched && !isFollowers) {
      return '--';
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
}
