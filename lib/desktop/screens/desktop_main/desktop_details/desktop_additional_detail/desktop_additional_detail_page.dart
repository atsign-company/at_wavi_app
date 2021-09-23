import 'package:at_wavi_app/desktop/screens/desktop_main/desktop_details/desktop_additional_detail/desktop_additional_detail_model.dart';
import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/dialog_utils.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_visibility_detector_widget.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../desktop_basic_item.dart';

class DesktopAdditionalDetailPage extends StatefulWidget {
  DesktopAdditionalDetailPage({Key? key}) : super(key: key);

  var _desktopAdditionalDetailPageState = _DesktopAdditionalDetailPageState();

  @override
  _DesktopAdditionalDetailPageState createState() =>
      this._desktopAdditionalDetailPageState =
          new _DesktopAdditionalDetailPageState();

  Future addField(BasicData basicData) async {
    await _desktopAdditionalDetailPageState.addField(basicData);
  }
}

class _DesktopAdditionalDetailPageState
    extends State<DesktopAdditionalDetailPage>
    with AutomaticKeepAliveClientMixin<DesktopAdditionalDetailPage> {
  late DesktopAdditionalDetailModel _model;

  @override
  bool get wantKeepAlive => true;

  Future addField(BasicData basicData) async {
    _model.addField(basicData);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return DesktopVisibilityDetectorWidget(
      keyScreen: MixedConstants.ADDITIONAL_DETAILS_KEY,
      child: ChangeNotifierProvider(
        create: (BuildContext c) {
          final userPreview = Provider.of<UserPreview>(context);
          _model = DesktopAdditionalDetailModel(userPreview: userPreview);
          return _model;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ColorConstants.LIGHT_GREY,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Consumer<DesktopAdditionalDetailModel>(
                builder: (_, model, child) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: model.fields.length,
                    itemBuilder: (context, index) {
                      return DesktopBasicItem(
                        title: model.fields[index].accountName ?? '',
                        value: model.fields[index].valueDescription ?? '',
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          height: 1,
                          color: appTheme.borderColor,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DesktopWhiteButton(
                          title: Strings.desktop_reorder,
                          height: 48,
                          onPressed: () async {
                            await showReOderFieldsPopUp(
                              context,
                              AtCategory.ADDITIONAL_DETAILS,
                              (fields) {
                                /// Update Fields after reorder
                                _model.reorderField(fields);
                              },
                            );
                          },
                        ),
                        SizedBox(width: 12),
                        DesktopButton(
                          title: Strings.desktop_save_publish,
                          height: 48,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
