import 'package:at_wavi_app/common_components/header.dart';
import 'package:at_wavi_app/routes/route_names.dart';
import 'package:at_wavi_app/routes/routes.dart';
import 'package:at_wavi_app/screens/home/widgets/home_channel.dart';
import 'package:at_wavi_app/screens/home/widgets/home_details.dart';
import 'package:at_wavi_app/screens/home/widgets/home_featured.dart';
import 'package:at_wavi_app/screens/options.dart';
import 'package:at_wavi_app/services/nav_service.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum HOME_TABS { DETAILS, CHANNELS, FEATURED }

class HomeScreen extends StatefulWidget {
  final ThemeData? themeData;
  final bool isPreview;
  HomeScreen({this.themeData, this.isPreview = false});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  HOME_TABS _currentTab = HOME_TABS.DETAILS;
  bool _isDark = false;
  ThemeData? _themeData;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _getThemeData();
    super.initState();
  }

  _getThemeData() async {
    if (widget.themeData != null) {
      _themeData = widget.themeData!;
    } else {
      _themeData =
          await Provider.of<ThemeProvider>(context, listen: false).getTheme();
    }

    if (_themeData!.scaffoldBackgroundColor ==
        Themes.darkTheme(ColorConstants.purple).scaffoldBackgroundColor) {
      _isDark = true;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (_themeData == null) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        backgroundColor: _themeData!.scaffoldBackgroundColor,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: _themeData!.scaffoldBackgroundColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: '',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorConstants.orange,
          onTap: _onItemTapped,
          // elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // header
                  Header(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                            fontSize: 18.toFont,
                            color: _themeData!.primaryColor,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () {
                                SetupRoutes.push(context, Routes.SEARCH_SCREEN);
                              },
                              child: Icon(Icons.search,
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
                                  shape: StadiumBorder(),
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 546,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(12.0),
                                          topRight: const Radius.circular(12.0),
                                        ),
                                      ),
                                      child: Options(),
                                    );
                                  });
                            },
                            child: Icon(Icons.more_vert,
                                color: _themeData!.primaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.toHeight),

                  // content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 116.toWidth,
                        height: 116.toHeight,
                        child: Icon(Icons.person),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Lauren London',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: _themeData!.primaryColor,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 8.toHeight),
                            Text(
                              '@lauren',
                              style: TextStyle(
                                  color: ColorConstants.orange,
                                  fontSize: 18.toFont),
                            ),
                            SizedBox(height: 18.5.toHeight),
                            Divider(
                              color: _themeData!.highlightColor,
                            ),
                            SizedBox(height: 18.5.toHeight),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            fontSize: 18.toFont,
                                            color: _isDark
                                                ? _themeData!.primaryColor
                                                : _themeData!.highlightColor,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          SetupRoutes.push(
                                              context, Routes.FOLLOWING_SCREEN);
                                        },
                                        child: Text(
                                          'Followers',
                                          style: TextStyle(
                                              fontSize: 14.toFont,
                                              color: _themeData!.primaryColor
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            fontSize: 18.toFont,
                                            color: _isDark
                                                ? _themeData!.primaryColor
                                                : _themeData!.highlightColor,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          SetupRoutes.push(
                                              context, Routes.FOLLOWING_SCREEN);
                                        },
                                        child: Text(
                                          'Following',
                                          style: TextStyle(
                                              fontSize: 14.toFont,
                                              color: _themeData!.primaryColor
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.toHeight),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 55.toHeight,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  _themeData!.highlightColor.withOpacity(0.1)),
                            ),
                            onPressed: widget.isPreview
                                ? () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: ColorConstants.RED,
                                      content: Text(
                                        'This is a Preview',
                                        style: CustomTextStyles.customTextStyle(
                                          ColorConstants.white,
                                        ),
                                      ),
                                    ));
                                  }
                                : () {
                                    SetupRoutes.push(
                                        NavService.navKey.currentContext!,
                                        Routes.EDIT_PERSONA);
                                  },
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                  fontSize: 16.toFont,
                                  color: _themeData!.primaryColor
                                      .withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 55.toHeight,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  _themeData!.highlightColor.withOpacity(0.1)),
                            ),
                            onPressed: widget.isPreview
                                ? () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: ColorConstants.RED,
                                      content: Text(
                                        'This is a Preview',
                                        style: CustomTextStyles.customTextStyle(
                                          ColorConstants.white,
                                        ),
                                      ),
                                    ));
                                  }
                                : () {},
                            child: Text('Share Profile',
                                style: TextStyle(
                                    fontSize: 16.toFont,
                                    color: _themeData!.primaryColor
                                        .withOpacity(0.5))),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 25.toHeight),

                  Container(
                    height: 70.toHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: _themeData!.primaryColor.withOpacity(0.1)),
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
                              child: tab('Channels', HOME_TABS.CHANNELS)),
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
                  SizedBox(height: 20.toHeight),
                  homeContent()
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget tab(String title, HOME_TABS tab) {
    return Container(
      decoration: BoxDecoration(
        color: _currentTab == tab
            ? _themeData!.highlightColor
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
      // return HomeEmptyDetails();
      return HomeDetails(themeData: _themeData!);
    } else if (_currentTab == HOME_TABS.CHANNELS) {
      return HomeChannels(themeData: _themeData!);
    } else if (_currentTab == HOME_TABS.FEATURED) {
      return HomeFeatured(themeData: _themeData!);
    } else
      return SizedBox();
  }
}
