import 'package:at_wavi_app/common_components/provider_callback.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_add_custom_field/desktop_profile_add_custom_field.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/desktop_profile_media/widgets/desktop_media_item.dart';
import 'package:at_wavi_app/desktop/screens/desktop_profile_basic_info/widgets/desktop_empty_category_widget.dart';
import 'package:at_wavi_app/desktop/screens/desktop_user_profile/desktop_user_profile_page.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/snackbar_utils.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_preview_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_welcome_widget.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/at_key_constants.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesktopProfileMediaPage extends StatefulWidget {
  final AtCategory atCategory = AtCategory.IMAGE;
  final bool hideMenu;
  final bool showWelcome;
  final bool isMyProfile;
  final bool isEditable;

  const DesktopProfileMediaPage({
    Key? key,
    this.hideMenu = false,
    this.showWelcome = true,
    required this.isMyProfile,
    required this.isEditable,
  }) : super(key: key);

  @override
  _DesktopProfileMediaPageState createState() =>
      _DesktopProfileMediaPageState();
}

class _DesktopProfileMediaPageState extends State<DesktopProfileMediaPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = AppTheme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appTheme.backgroundColor,
      body: _buildContentWidget(),
    );
  }

  Widget _buildEmptyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (widget.showWelcome)
          Container(
            padding: EdgeInsets.only(top: DesktopDimens.paddingLarge),
            child: DesktopWelcomeWidget(
              titlePage: widget.atCategory.titlePage,
            ),
          ),
        Expanded(
          child: Container(
            child: Center(
              child: DesktopEmptyCategoryWidget(
                atCategory: widget.atCategory,
                onAddDetailsPressed: _showAddCustomContent,
                showAddButton: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentWidget() {
    User? user;
    User? myProfile = Provider.of<UserProvider>(context).user;;
    if (widget.isMyProfile && widget.isEditable == false) {
      user = Provider.of<UserProvider>(context).user;
    } else {
      user = Provider.of<UserPreview>(context).user();
    }
    List<BasicData> customFields =
        user?.customFields[AtCategory.IMAGE.name] ?? [];
    final items = customFields
        .where((element) =>
            element.accountName?.contains(AtText.IS_DELETED) == false)
        .toList();

    //Fix: app don't show save button after delete all images
    List<BasicData> myCustomFields =
        myProfile?.customFields[AtCategory.IMAGE.name] ?? [];
    final myItems = myCustomFields
        .where((element) =>
    element.accountName?.contains(AtText.IS_DELETED) == false)
        .toList();

    bool isEmptyData = (items).isEmpty;

    if (isEmptyData && widget.isEditable == false) {
      return _buildEmptyWidget();
    }

    if (isEmptyData && widget.isEditable && myItems.isEmpty) {
      return _buildEmptyWidget();
    }

    final appTheme = AppTheme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: DesktopDimens.paddingExtraLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hideMenu == false)
            SizedBox(height: DesktopDimens.paddingLarge),
          if (widget.hideMenu == false)
            Container(
              child: Row(
                children: [
                  Text(
                    widget.atCategory.label,
                    style: TextStyle(
                      color: appTheme.primaryTextColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  DesktopIconButton(
                    iconData: Icons.add_circle_outline_sharp,
                    onPressed: _showAddCustomContent,
                  ),
                  SizedBox(width: 10),
                  DesktopPreviewButton(
                    onPressed: _showUserPreview,
                  ),
                ],
              ),
            ),
          if (widget.hideMenu == false)
            SizedBox(height: DesktopDimens.paddingLarge),
          Expanded(
            child: Container(
              child: _buildFieldsWidget(items),
            ),
          ),
          SizedBox(height: DesktopDimens.paddingNormal),
          if (widget.isEditable)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DesktopButton(
                  title: 'Save',
                  onPressed: _handleSaveAndNext,
                ),
              ],
            ),
          if (widget.isEditable) SizedBox(height: DesktopDimens.paddingLarge),
        ],
      ),
    );
  }

  Widget _buildFieldsWidget(List<BasicData> items) {
    return Container(
      width: double.infinity,
      child: GridView.count(
        controller: _scrollController,
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        children: items
            .map((e) => DesktopMediaItem(
                  data: e,
                  showMenu: widget.isEditable,
                  onEditPressed: () {
                    _editData(e);
                  },
                  onDeletePressed: () {
                    _deleteData(e);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showUserPreview() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DesktopUserProfilePage(),
      ),
    );
  }

  void _showAddCustomContent() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopProfileAddCustomField(
          atCategory: widget.atCategory,
          allowContentType: [
            CustomContentType.StorjImage,
          ],
        ),
      ),
    );
  }

  void _deleteData(BasicData basicData) {
    UserPreview().deletCustomField(AtCategory.IMAGE, basicData);
    setState(() {});
  }

  void _editData(BasicData basicData) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopProfileAddCustomField(
          atCategory: AtCategory.IMAGE,
          data: basicData,
          allowContentType: [
            CustomContentType.StorjImage,
          ],
        ),
      ),
    );
  }

  void _handleSaveAndNext() async {
    await providerCallback<UserProvider>(
      context,
      task: (provider) async {
        await provider.saveUserData(
            Provider.of<UserPreview>(context, listen: false).user()!);
      },
      onError: (provider) {},
      showDialog: false,
      text: 'Saving user data',
      taskName: (provider) => provider.UPDATE_USER,
      onSuccess: (provider) async {
        // Provider.of<DesktopEditProfileModel>(context, listen: false).jumpNextPage();
        SnackBarUtils.show(
          context: context,
          message: 'Your changes have been saved!',
        );
      },
    );
  }
}
