import 'dart:async';

import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:flutter/material.dart';

class DesktopOnBoardingPage extends StatefulWidget {
  const DesktopOnBoardingPage({Key? key}) : super(key: key);

  @override
  _DesktopOnBoardingPageState createState() => _DesktopOnBoardingPageState();
}

class _DesktopOnBoardingPageState extends State<DesktopOnBoardingPage>
    with SingleTickerProviderStateMixin {
  final numOfPage = 2;
  late PageController _pageController;
  late TabController _tabController;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(vsync: this, length: numOfPage);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        _jumpToNextPage();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      color: appTheme.primaryLighterColor,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: DesktopDimens.marginExtraLarge),
          Expanded(
            child: PageView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: 2,
              onPageChanged: (int page) {
                _tabController.animateTo(page);
              },
              controller: _pageController,
              itemBuilder: (context, index) {
                return _buildPageItem(index);
              },
            ),
          ),
          TabPageSelector(
            controller: _tabController,
            color: appTheme.secondaryTextColor,
            selectedColor: appTheme.primaryColor,
            indicatorSize: 10,
          ),
          SizedBox(height: DesktopDimens.marginExtraLarge),
        ],
      ),
    );
  }

  Widget _buildPageItem(int index) {
    final appTheme = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: DesktopDimens.paddingLarge),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/images/login${index + 1}.png',
                fit: BoxFit.fitHeight,
                height: 150,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              Strings.desktop_login_title_page[index],
              textAlign: TextAlign.center,
              style: appTheme.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesktopDimens.paddingNormal),
            Text(
              Strings.desktop_login_sub_title_page[index],
              textAlign: TextAlign.center,
              style: appTheme.textTheme.bodyText2?.copyWith(
                color: appTheme.secondaryTextColor,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _jumpToNextPage() {
    final currentPage = (_pageController.page ?? 0).toInt();
    final nextPage = currentPage >= numOfPage - 1 ? 0 : currentPage + 1;
    _pageController.animateToPage(
      nextPage,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _jumpToPrevPage() {
    final currentPage = (_pageController.page ?? 0).toInt();
    final nextPage = currentPage == 0 ? numOfPage - 1 : currentPage - 1;
    _pageController.animateToPage(
      nextPage,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }
}
