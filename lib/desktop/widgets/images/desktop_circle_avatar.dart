import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DesktopCircleAvatar extends StatelessWidget {
  final String url;
  final double size;

  const DesktopCircleAvatar({Key? key, 
    required this.url,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    bool isValidUrl = Uri.tryParse(url)?.isAbsolute == true;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: isValidUrl
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: CachedNetworkImage(
                imageUrl: url,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return SizedBox(
                    width: size,
                    height: size,
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      backgroundColor: appTheme.primaryColor,
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.grey,
                    ),
                  );
                },
                fit: BoxFit.fill,
              ),
            )
          : const SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
            ),
    );
  }
}
