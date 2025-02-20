import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/event/tab_select_event.dart';
import 'package:dealful_mall/model/brand_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabHomeBrand extends StatelessWidget {
  final List<BrandEntity> brands;
  final String title;
  TabHomeBrand(this.title,this.brands);

  Widget build(BuildContext context) {
    return  Visibility(
        visible: brands.isNotEmpty,
        child: Column(
        children: [
          GestureDetector(
            onTap: () {
              tabSelectBus.fire(TabSelectEvent(1, innerTabIndex: 1));
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: AppDimens.DIMENS_30.w, top: AppDimens.DIMENS_30.h, bottom: AppDimens.DIMENS_30.h),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                      child: Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: XTextStyle.color_333333_size_52_bold)
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.COLOR_333333,
                    size: AppDimens.DIMENS_64.r,
                  ),
                  SizedBox(
                    width: AppDimens.DIMENS_30.w,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppDimens.DIMENS_30.w,
            ),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: brands.length,
              itemBuilder: (BuildContext context, int index) {
                return _itemView(context, brands[index], index);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  mainAxisSpacing:
                  AppDimens.DIMENS_10.h,
                  crossAxisSpacing:
                  AppDimens.DIMENS_20.w),
            ),
          )
        ],
      ));
  }

  _searchProductByBrand(BuildContext context, BrandEntity brand) {
    NavigatorUtil.goSearchGoods(context, brandId: XUtils.textOf(brand.id));
  }

  Widget _itemView(BuildContext context, BrandEntity brandEntity, int index) {
    return GestureDetector(
      onTap: () => _searchProductByBrand(context, brandEntity),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.DIMENS_20.r),
            color: Colors.white
        ),
        padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_10.r),
        child: Column(
          children: [
            SizedBox(height: AppDimens.DIMENS_20.r,),
            CachedImageView(
              AppDimens.DIMENS_120.r,
              AppDimens.DIMENS_120.r,
              XUtils.textOf(brandEntity.image),
              fit: BoxFit.contain,
            ),
            Expanded(
                child: Center(
                  child: Text(
                    XUtils.textOf(brandEntity.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.COLOR_333333,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimens.DIMENS_36.sp),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
