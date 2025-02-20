import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/event/tab_select_event.dart';
import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/model/home_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabSearchGoodsCategory extends StatelessWidget {
  final List<HomeModelRecommend>? _homeModelChannel;
  TabSearchGoodsCategory(this._homeModelChannel);

  _goCategoryView(BuildContext context, CategoryEntity channel) {
    NavigatorUtil.goCategoryGoodsListPage(context, channel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          padding: EdgeInsets.only(
            top: AppDimens.DIMENS_30.h,
            left: AppDimens.DIMENS_42.w,
            right: AppDimens.DIMENS_42.w,
          ),
          physics: NeverScrollableScrollPhysics(),
          //禁止滚动
          shrinkWrap: true,
          itemCount: _homeModelChannel?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            //  return _getGridViewItem(categoryList[index]);
            if (_homeModelChannel == null) {
              return SizedBox.shrink();
            }
            return _getGridViewItem(context, _homeModelChannel![index]);
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.6,
            //单个子Widget的水平最大宽度
            crossAxisCount: 5,
            //水平单个子Widget之间间距
            mainAxisSpacing: ScreenUtil().setWidth(AppDimens.DIMENS_30),
            //垂直单个子Widget之间间距
            crossAxisSpacing: ScreenUtil().setWidth(AppDimens.DIMENS_30),
          ),
        )
      ],
    );
  }

  Widget _getGridViewItem(BuildContext context, HomeModelRecommend channel) {
    return Center(
      child: InkWell(
        onTap: () => {

        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(AppDimens.DIMENS_6.r),
              child: ClipOval(child: CachedImageView(ScreenUtil().setWidth(AppDimens.DIMENS_150),
                  ScreenUtil().setWidth(AppDimens.DIMENS_150), channel.ImageUrl)),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: AppDimens.DIMENS_10.h),
                  child: Text(
                    XUtils.textOf(channel.Name),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.COLOR_333333,
                        height: 1,
                        fontSize: ScreenUtil().setSp(AppDimens.DIMENS_38)),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
