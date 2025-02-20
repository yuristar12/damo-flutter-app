import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/review_entity.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewEntity? entity;

  const ReviewWidget(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    if(entity == null) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BrnRatingStar(
              selectedCount: entity!.rating?.toDouble() ?? 0,
            ),
            Padding(
              padding: EdgeInsets.only(left: AppDimens.DIMENS_20.w),
              child: Text(
                XUtils.textOf(entity!.timeAgo),
                style: XTextStyle.color_999999_size_32,
              ),
            )
          ],
        ),
        Padding(
            padding: EdgeInsets.only(left: AppDimens.DIMENS_10.h),
            child: Text(
              XUtils.textOf(entity!.userInfo?.username),
              style: XTextStyle.color_333333_size_42_bold,
            )),
        Padding(
          padding: EdgeInsets.only(left: AppDimens.DIMENS_10.h),
          child: Text(
            XUtils.textOf(entity!.review),
            style: XTextStyle.color_333333_size_38,
          ),
        )
      ],
    );
  }
}
