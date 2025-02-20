import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/comment_entity.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentWidget extends StatelessWidget {
  final CommentEntity? entity;

  const CommentWidget(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    if(entity == null) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: AppDimens.DIMENS_10.h),
              child: Text(
                XUtils.textOf(entity!.userInfo?.username),
                style: XTextStyle.color_333333_size_42_bold,
              )),
          Padding(
            padding: EdgeInsets.only(left: AppDimens.DIMENS_10.h),
            child: Text(
              XUtils.textOf(entity!.comment),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: XTextStyle.color_333333_size_42,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: AppDimens.DIMENS_10.h),
            child: Text(
              XUtils.textOf(entity!.timeAgo),
              style: XTextStyle.color_999999_size_32,
            ),
          )
        ],
      );
  }
}
