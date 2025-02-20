import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ItemClick(String value);

class ProductWidget extends StatelessWidget {
  final ProductEntity _productEntity;
  final ItemClick _itemClick;
  final double width;

  const ProductWidget(
    this._productEntity,
    this._itemClick,
    this.width,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedImageView(
                  width, width, XUtils.textOf(_productEntity.image), fit: BoxFit.contain,),
            ),
            Expanded(
                child: Padding(
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
                  style: XTextStyle.color_333333_size_36),
            )),
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
            Container(
                padding: EdgeInsets.only(
                    left: AppDimens.DIMENS_26.r,
                    right: AppDimens.DIMENS_26.r,
                    top: AppDimens.DIMENS_10.r,
                    bottom: AppDimens.DIMENS_20.r),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text(XUtils.textOf(_productEntity.priceDiscounted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: XTextStyle.color_primary_size_48_bold),
                    Visibility(
                        visible: _productEntity.price?.isNotEmpty == true,
                        child: Text(XUtils.textOf(_productEntity.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: XTextStyle.color_999999_size_36_lineThrough))
                  ],
                )),
          ],
        ),
      ),
      onTap: () => _itemClick(_productEntity.id.toString()),
    );
  }
}
