import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DesktopThemeCard extends StatelessWidget {
  final Color primaryColor;
  final Brightness brightness;
  final bool isSelected;
  final VoidCallback? onPressed;

  const DesktopThemeCard({
    Key? key,
    required this.primaryColor,
    required this.brightness,
    required this.isSelected,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.from(
      primaryColor: primaryColor,
      brightness: brightness,
    );
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(theme.backgroundColor),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 166,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  color: primaryColor.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  color: primaryColor.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      backgroundColor:
                          WidgetStateProperty.all<Color>(primaryColor),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Container(),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isSelected,
              child: Center(
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Icon(Icons.check_rounded, color: primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
