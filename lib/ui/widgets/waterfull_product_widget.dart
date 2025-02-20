

import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ItemClick(String value);

class WaterfullProductWidget extends StatelessWidget {
  final ProductEntity _productEntity;
  final ItemClick _itemClick;
  final double width;
  final bool isWhite;
  const WaterfullProductWidget(
    this._productEntity,
    this._itemClick,
    this.width,
    { this.isWhite = true }
  );

  @override
  Widget build(BuildContext context) {

    double discountPrice = double.tryParse(_productEntity.priceDiscounted!.replaceAll(RegExp(r'\$'), '').replaceAll(RegExp(r'\,'), '')) ?? 0;
    double originPrice = 0;
    if (_productEntity.price.toString() != 'null') {
      originPrice = double.tryParse(_productEntity.price!.replaceAll(RegExp(r'\$'), '').replaceAll(RegExp(r'\,'), '')) ?? originPrice;
    }
    return GestureDetector(
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: isWhite ? AppColors.COLOR_FFFFFF : AppColors.COLOR_F6F6F6, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: CachedImageView(
                width,
                width,
                XUtils.textOf(_productEntity.image),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AppDimens.DIMENS_26.r,
                right: AppDimens.DIMENS_26.r,
                top: AppDimens.DIMENS_10.r,
              ),
              child: Text(
                  Characters(XUtils.textOf(_productEntity.name))
                      .join('\u{200B}'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.COLOR_333333,
                      height: 1,
                      fontSize: ScreenUtil().setSp(AppDimens.DIMENS_36))),
            ),
            Visibility(
                visible: _productEntity.username?.isNotEmpty == true,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: AppDimens.DIMENS_26.r,
                      right: AppDimens.DIMENS_26.r,
                      top: AppDimens.DIMENS_10.r),
                  child: Text(XUtils.textOf(_productEntity.username),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: XTextStyle.color_333333_size_32),
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: AppDimens.DIMENS_10.r,
                    right: AppDimens.DIMENS_10.r,
                    top: AppDimens.DIMENS_10.r,
                    bottom: AppDimens.DIMENS_20.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(XUtils.textOf(_productEntity.priceDiscounted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: XTextStyle.color_primary_size_48_bold),
                    Visibility(
                        visible: _productEntity.price?.isNotEmpty == true,
                        child: Padding(
                            padding:
                                EdgeInsets.only(left: AppDimens.DIMENS_10.r),
                            child: Text(XUtils.textOf(_productEntity.price),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: XTextStyle
                                    .color_999999_size_36_lineThrough))),
                    Visibility(
                      visible: originPrice != 0,
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(width: 1, color: AppColors.primaryColor)
                        ),
                        child: Text(
                          '-${((discountPrice/originPrice)*100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryColor
                          ),
                        ),
                      )
                    ),
                  ],
                )),
          ],
        ),
      ),
      onTap: () => _itemClick(_productEntity.id.toString()),
    );
  }
}
