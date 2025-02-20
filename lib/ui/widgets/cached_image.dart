import 'package:cached_network_image/cached_network_image.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_avif/flutter_avif.dart';

class CachedImageView extends StatelessWidget {
  final double width;
  final double height;
  final String? url;
  final BoxFit? fit;
  final int? cacheWidth;
  CachedImageView(this.width, this.height, this.url, {super.key, this.fit = BoxFit.cover, this.cacheWidth});

  bool get _isAvifImage => url?.toLowerCase().endsWith('.avif') ?? false;

  @override
  Widget build(BuildContext context) {
    int memCacheWidth = cacheWidth?? Get.width.toInt();
    return Container(
      width: this.width,
      height: this.height,
      alignment: Alignment.center,
      child: this.url?.isNotEmpty == true
          ? _isAvifImage 
              ? _buildAvifImage()
              : CachedNetworkImage(
                  imageUrl: this.url!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: fit,
                  useOldImageOnUrlChange: true,
                  memCacheWidth: memCacheWidth,
                  errorWidget: (_, url, error) => _buildPlaceholder(true),
                )
          : _buildPlaceholder(),
    );
  }

  Widget _buildAvifImage() {
    return AvifImage.network(
      url!,
      width: double.infinity,
      height: double.infinity,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(true),
    );
  }

  /**
   * 创建占位图
   */
  Container _buildPlaceholder([bool error = false]) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        AppImages.DEFAULT_PICTURE,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
