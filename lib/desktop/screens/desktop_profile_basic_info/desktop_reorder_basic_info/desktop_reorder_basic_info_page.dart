import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/utils.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_reorder_basic_info_model.dart';
import 'widgets/desktop_reorderable_item_widget.dart';

class DesktopReorderBasicDetailPage extends StatefulWidget {
  final AtCategory atCategory;

  const DesktopReorderBasicDetailPage({
    Key? key,
    required this.atCategory,
  }) : super(key: key);

  @override
  _DesktopReorderBasicDetailPageState createState() =>
      _DesktopReorderBasicDetailPageState();
}

class _DesktopReorderBasicDetailPageState
    extends State<DesktopReorderBasicDetailPage> {
  late DesktopReorderBasicDetailModel _model;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopReorderBasicDetailModel(
          userPreview: userPreview,
          atCategory: widget.atCategory,
        );
        return _model;
      },
      child: Container(
        width: DesktopDimens.dialogWidth,
        padding: const EdgeInsets.all(DesktopDimens.paddingNormal),
        decoration: BoxDecoration(
          color: appTheme.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reorder Content',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appTheme.primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildContentWidget(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DesktopButton(
                    title: 'Save New Order',
                    width: double.infinity,
                    backgroundColor: appTheme.primaryColor,
                    onPressed: _onSaveData,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DesktopWhiteButton(
                    title: 'Cancel',
                    width: double.infinity,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentWidget() {
    return Consumer<DesktopReorderBasicDetailModel>(
      builder: (_, model, child) {
        List<Widget> itemWidgets = [];
        for (int i = 0; i < model.fields.length; i++) {
          itemWidgets.add(DesktopReorderableItemWidget(
            key: Key(model.fields[i]),
            index: i,
            title: getTitle(model.fields[i]),
            margin: const EdgeInsets.symmetric(vertical: 4),
          ));
        }
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 360.0,
          ),
          child: ReorderableListView(
            onReorder: _model.reorder,
            shrinkWrap: true,
            buildDefaultDragHandles: false,
            physics: const ClampingScrollPhysics(),
            children: itemWidgets,
          ),
          // shrinkWrap: true,
          // physics: ClampingScrollPhysics(),
          // itemBuilder: (c, index) {
          //   final data = model.basicData[index];
          //   return DesktopReorderableItemWidget(
          //       title: data.accountName ?? '');
          // },
          // separatorBuilder: (context, index) {
          //   return SizedBox(height: 4);
          // },
          // itemCount: model.basicData.length,
        );
      },
    );
  }

  void _onSaveData() {
    _model.saveData(context);
  }
}
