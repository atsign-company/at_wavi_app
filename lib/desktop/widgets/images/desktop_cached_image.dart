import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DesktopCachedImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;

  const DesktopCachedImage({
    Key? key,
    this.url = "",
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    bool isValidUrl = Uri.tryParse(url)?.isAbsolute == true;
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      child: isValidUrl
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              child: CachedNetworkImage(
                imageUrl: url,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        backgroundColor: appTheme.primaryColor,
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.network(
                    url,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceHolderImage(),
                    fit: fit,
                  );
                },
                fit: fit,
              ),
            )
          : _buildPlaceHolderImage(),
    );
  }

  Widget _buildPlaceHolderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: Container(
        color: const Color(0xFFe6e6e6),
        child: const Center(
          child: Icon(
            Icons.broken_image_rounded,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
