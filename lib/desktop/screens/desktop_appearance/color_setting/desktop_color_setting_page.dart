import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../desktop_appearance_model.dart';
import 'widgets/desktop_color_card.dart';

class DesktopColorSettingPage extends StatefulWidget {
  const DesktopColorSettingPage({Key? key}) : super(key: key);

  @override
  _DesktopColorSettingPageState createState() =>
      _DesktopColorSettingPageState();
}

class _DesktopColorSettingPageState extends State<DesktopColorSettingPage>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    // final appTheme = AppTheme.of(context);
    final desktopAppearanceModel = Provider.of<DesktopAppearanceModel>(
      context,
    );
    List<Color> primaryColors = desktopAppearanceModel.isDarkMode
        ? desktopAppearanceModel.darkPaletteColors
        : desktopAppearanceModel.paletteColors;
    return Container(
      padding: const EdgeInsets.only(
          left: DesktopDimens.marginExtraLarge, top: DesktopDimens.marginLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: 98 * 4 + 12 * 3,
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(
                  primaryColors.length,
                  (index) {
                    return Container(
                      child: DesktopColorCard(
                        color: primaryColors[index],
                        isSelected: primaryColors[index] ==
                            desktopAppearanceModel.color,
                        onPressed: () {
                          desktopAppearanceModel
                              .changeHighlightColor(primaryColors[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
