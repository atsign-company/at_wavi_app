import 'package:at_wavi_app/common_components/empty_widget.dart';
import 'package:at_wavi_app/screens/home/widgets/twitter_embed_widget.dart';
import 'package:at_wavi_app/screens/website_webview/website_webview.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:at_wavi_app/utils/theme.dart';
import 'package:at_wavi_app/view_models/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:at_wavi_app/services/size_config.dart';
import 'package:provider/provider.dart';

class HomeFeatured extends StatefulWidget {
  final String? twitterUsername, instagramUsername;
  final bool isPrivateTwitter;
  final bool isPrivateInstagram;
  final ThemeData? themeData;

  const HomeFeatured({Key? key, 
    this.twitterUsername,
    this.instagramUsername,
    this.isPrivateTwitter = true,
    this.isPrivateInstagram = true,
    this.themeData,
  }) : super(key: key);

  @override
  _HomeFeaturedState createState() => _HomeFeaturedState();
}

class _HomeFeaturedState extends State<HomeFeatured> {
  late bool _isDark = false;
  ThemeData? _themeData;

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
        Themes.darkTheme().scaffoldBackgroundColor) {
      _isDark = true;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_themeData == null) {
      return const CircularProgressIndicator();
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            if ((!widget.isPrivateInstagram) &&
                (widget.instagramUsername != null))
              _buildInstagramContent(),
            if ((!widget.isPrivateTwitter) && (widget.twitterUsername != null))
              _buildTwitterContent(),
          ],
        ),
      );
    }
  }

  Widget _buildInstagramContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Instagram',
              style: TextStyles.boldText(_themeData!.primaryColor, size: 18),
            )
          ],
        ),
        SizedBox(height: 15.toHeight),
        widget.instagramUsername != null
            ? Container(
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                color: _themeData!.highlightColor.withOpacity(0.1),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebsiteScreen(
                          title: 'Instagram',
                          url:
                              'https://instagram.com/${widget.instagramUsername}',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Click here to login',
                    style: TextStyles.linkText(),
                  ),
                ),
              )
            : EmptyWidget(
                _themeData!,
                limitedContent: true,
              ),
        SizedBox(height: 40.toHeight),
      ],
    );
  }

  Widget _buildTwitterContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Twitter',
              style: TextStyles.boldText(_themeData!.primaryColor, size: 18),
            ),
            widget.twitterUsername != null
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebsiteScreen(
                            title: 'Twitter',
                            url:
                                'https://twitter.com/${widget.twitterUsername}',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'See more',
                      style: TextStyles.linkText(),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        SizedBox(height: 15.toHeight),
        widget.twitterUsername != null
            ? TwitterEmbedWidget(twitterUsername: widget.twitterUsername!)
            // ? Column(
            //     children: CommonFunctions().getFeaturedTwitterCards(
            //         widget.twitterUsername!, _themeData!))
            : EmptyWidget(
                _themeData!,
                limitedContent: true,
              ),
      ],
    );
  }
}
