import 'package:card_swiper/card_swiper.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/simple_banner_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabHomeBanner extends StatelessWidget {
  final List<SimpleBannerEntity>? _bannerData;

  const TabHomeBanner(this._bannerData);

  @override
  Widget build(BuildContext context) {
    if (_bannerData == null || _bannerData?.isEmpty == true) {
      return SizedBox.shrink();
    }
    return Container(
      alignment: Alignment.center,
      height: AppDimens.DIMENS_240.h,
      margin: EdgeInsets.only(left: AppDimens.DIMENS_30.w, right: AppDimens.DIMENS_30.w, top: AppDimens.DIMENS_30.w),
      width: double.infinity,
      child: _bannerData?.isNotEmpty == true
          ? Swiper(
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppDimens.DIMENS_20.r)),
                  child: CachedImageView(double.infinity,
                      AppDimens.DIMENS_240.h, _bannerData![index].image, cacheWidth: 600,),
                );
              },
              autoplay: _bannerData!.length>1,
              autoplayDelay: 5000,
              itemCount: _bannerData!.length,
              pagination:
                  SwiperCustomPagination(builder: (swiperContext, config) {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(2)),
                    margin: EdgeInsets.only(
                        bottom: AppDimens.DIMENS_20.h,
                        right: AppDimens.DIMENS_30.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_20.w),
                    child: Text(
                      "${config.activeIndex + 1}/${config.itemCount}",
                      style: XTextStyle.color_ffffff_size_36,
                    ),
                  ),
                );
              }),
        onTap: (index) {

        },
            )
          : SizedBox.shrink(),
    );
  }
}
