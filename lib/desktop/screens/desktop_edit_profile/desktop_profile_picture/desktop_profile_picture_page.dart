import 'dart:typed_data';

import 'package:at_wavi_app/common_components/provider_callback.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/snackbar_utils.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/services/image_picker.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesktopProfilePicturePage extends StatefulWidget {
  DesktopProfilePicturePage({Key? key}) : super(key: key);

  @override
  _DesktopProfilePicturePageState createState() => _DesktopProfilePicturePageState();
}

class _DesktopProfilePicturePageState extends State<DesktopProfilePicturePage> {
  bool _isPickingFile = false;

  @override
  void initState() {
    super.initState();
  }

  void _onSelectMedia() async {
    if (_isPickingFile) {
      return;
    } else {
      _isPickingFile = true;
    }

    ImagePicker().desktopPickImage(context).then((data) {
      if (data != null) {
        final image = Provider.of<UserPreview>(context, listen: false).user()!.image;
        image.value = data;
        Provider.of<UserPreview>(context, listen: false).user()!.image = image;
        Provider.of<UserPreview>(context, listen: false).notify();
      }
      _isPickingFile = false;
    });
  }

  void _handleSaveAndNext(BuildContext context) async {
    await providerCallback<UserProvider>(
      context,
      task: (provider) async {
        await provider.saveUserData(Provider.of<UserPreview>(context, listen: false).user()!);
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

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: DesktopDimens.paddingLarge,
          ),
          Text(
            'Edit image',
            style: appTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: DesktopDimens.paddingSmall,
          ),
          Text(
            'All info is public unless set to Private',
            style: appTheme.textTheme.bodyMedium,
          ),
          const SizedBox(
            height: DesktopDimens.paddingNormal,
          ),
          Text(
            'Update your profile Image',
            style: appTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: DesktopDimens.paddingNormal,
          ),
          Expanded(
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: _buildAvatarWidget(),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: DesktopIconButton(
                  onPressed: _onSelectMedia,
                  iconData: Icons.edit,
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: DesktopDimens.paddingNormal,
          ),
          _buildPrivateWidget(),
          Padding(
            padding: const EdgeInsets.only(
              right: DesktopDimens.paddingLarge,
              bottom: DesktopDimens.paddingLarge,
            ),
            child: Row(
              children: [
                Spacer(),
                DesktopButton(
                  title: 'Save',
                  onPressed: () => _handleSaveAndNext(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatarWidget() {
    return Consumer<UserPreview>(builder: (context, provider, child) {
      dynamic data = provider.user()?.image.value;
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          child: data is Uint8List
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.memory(
                    data,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Icon(Icons.account_circle, color: Colors.grey),
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildPrivateWidget() {
    final appTheme = AppTheme.of(context);
    return Consumer<UserPreview>(builder: (context, provider, child) {
      bool isPrivate = provider.user()?.image.isPrivate ?? false;
      return Container(
        width: 300,
        child: SwitchListTile(
          activeColor: appTheme.primaryColor,
          title: Text(
            'Set image to private',
            style: appTheme.textTheme.bodyMedium,
          ),
          value: isPrivate,
          onChanged: (bool value) {
            final image = Provider.of<UserPreview>(context, listen: false).user()!.image;
            image.isPrivate = value;
            Provider.of<UserPreview>(context, listen: false).user()!.image = image;
            Provider.of<UserPreview>(context, listen: false).notify();
          },
        ),
      );
    });
  }
}
