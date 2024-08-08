import 'package:at_wavi_app/services/size_config.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/utils/text_styles.dart';
import 'package:flutter/material.dart';

class AddCustomContentButton extends StatelessWidget {
  final String? text;
  final Function? onTap;
  const AddCustomContentButton({Key? key, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: double.infinity,
        height: 50.toHeight,
        decoration: BoxDecoration(
          color: ColorConstants.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: ColorConstants.orange,
            ),
            Text(
              text ?? 'Add Custom Content',
              style: CustomTextStyles.customTextStyle(ColorConstants.orange),
            )
          ],
        ),
      ),
    );
  }
}
