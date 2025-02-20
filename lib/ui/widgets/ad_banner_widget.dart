import 'package:cached_network_image/cached_network_image.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/model/ad_banner_entity.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdBannerWidget extends StatelessWidget {
  final List<AdBannerEntity> _adBannerEntities;

  const AdBannerWidget._(this._adBannerEntities);

  factory AdBannerWidget.fromList(
          List<AdBannerEntity> sourceEntities, String filterKey) =>
      AdBannerWidget._(filter(sourceEntities, filterKey));

  @override
  Widget build(BuildContext context) {
    if (_adBannerEntities.isEmpty) {
      return SizedBox.shrink();
    }
    double spacing = AppDimens.DIMENS_30.w;
    double screenWidth = ScreenUtil().screenWidth;
    return Padding(
        padding: EdgeInsets.only(
            left: AppDimens.DIMENS_30.w,
            right: AppDimens.DIMENS_30.w,
            top: AppDimens.DIMENS_30.h),
        child: Wrap(
          spacing: spacing,
          runSpacing: AppDimens.DIMENS_20.h,
          children: List.generate(_adBannerEntities.length, (index) {
            AdBannerEntity entity = _adBannerEntities[index];
            double count = 100.0 / (entity.bannerWidth ?? 100);
            return GestureDetector(
              onTap: () {
                NavigatorUtil.goWebView(entity.bannerUrl);
              },
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BannerImageWidget(
                      (screenWidth - (count + 1) * spacing) / count,
                      entity.bannerImagePath ?? "")),
            );
          }),
        ));
  }
}

List<AdBannerEntity> filter(
    List<AdBannerEntity> sourceEntities, String filterKey) {
  List<AdBannerEntity> result = [];
  for (AdBannerEntity adBannerEntity in sourceEntities) {
    if (adBannerEntity.bannerLocation == filterKey) {
      result.add(adBannerEntity);
    }
  }
  return result;
}

class BannerImageWidget extends StatefulWidget {
  final double width;
  final String url;

  const BannerImageWidget(this.width, this.url);

  @override
  State<StatefulWidget> createState() => _BannerImageState();
}

class _BannerImageState extends State<BannerImageWidget> {
  final double defHeight = 30;
  double? dynamicHeight;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.url,
      height: dynamicHeight ?? defHeight,
      fit: BoxFit.fitWidth,
      width: widget.width,
      imageBuilder: (_, imageProvider) {
        imageProvider.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener((ImageInfo info, bool synchronousCall) {
          double height = info.image.height / (info.image.width / widget.width);
          Future.delayed(Duration.zero).then((onValue) {
            setState(() {
              dynamicHeight = height;
            });
          });
        }));
        return Image(image: imageProvider);
      },
      errorWidget: (_, url, error) {
        return Image.asset(
          AppImages.DEFAULT_PICTURE,
          width: widget.width,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
