import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/ad_banner_entity.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/ui/widgets/product_widget.dart';
import 'package:dealful_mall/ui/widgets/waterfull_product_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TabHomeProducts extends StatelessWidget {
  final List<ProductEntity> productList;
  final String title;
  final GestureTapCallback? onTapTitle;

  /// UI类型，0是水平排列，1是瀑布流
  final int uiType;

  TabHomeProducts(this.title, this.productList,
      {this.onTapTitle, this.uiType = 0});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: productList.isNotEmpty,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTapTitle,
            child: Container(
              
              width: double.infinity,
              padding: EdgeInsets.only(left: AppDimens.DIMENS_30.w, top: AppDimens.DIMENS_30.h, bottom: AppDimens.DIMENS_30.h),
              child: Row(
                children: [
                  Expanded(
                      child: Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: XTextStyle.color_333333_size_52_bold)),
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
            color: AppColors.COLOR_F6F6F6,
            child: createWidgetByUiType(),
          )
        ],
      ),
    );
  }

  Widget createWidgetByUiType() {
    double space = ScreenUtil().screenWidth - AppDimens.DIMENS_30.w * 3;
    double cardWidth = uiType == 0 ? space / 3 : space / 2;
    switch (uiType) {
      case 1:
        return MasonryGridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: AppDimens.DIMENS_20.h,
          itemCount: productList.length,
          crossAxisSpacing: AppDimens.DIMENS_30.w,
          itemBuilder: (context, index) {
            ProductEntity entity = productList[index];
            return WaterfullProductWidget(
                entity, (value) => _goGoodsDetail(context, value), cardWidth);
          },
        );
      default:
        return SizedBox(
          height: AppDimens.DIMENS_490.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
            itemBuilder: (context, index) {
              ProductEntity entity = productList[index];
              return ProductWidget(
                  entity, (value) => _goGoodsDetail(context, value), cardWidth);
            },
            separatorBuilder: (_, index) =>
                SizedBox(width: AppDimens.DIMENS_30.w),
            itemCount: productList.length,
            scrollDirection: Axis.horizontal,
          ),
        );
    }
  }

  _goGoodsDetail(BuildContext context, String goodsId) {
    NavigatorUtil.goGoodsDetails(context, goodsId);
  }
}
