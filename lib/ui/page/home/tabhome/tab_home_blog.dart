import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/blog_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TabHomeBlog extends StatelessWidget {
  final List<BlogEntity> blogs;
  final String title;

  TabHomeBlog(this.title, this.blogs);

  Widget build(BuildContext context) {
    return Visibility(
        visible: blogs.isNotEmpty,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(XRouterPath.blogPosts);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                    left: AppDimens.DIMENS_30.w,
                    top: AppDimens.DIMENS_30.h,
                    bottom: AppDimens.DIMENS_30.h),
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
            SizedBox(
              height: AppDimens.DIMENS_640.r,
              child: ListView.separated(
                  padding: EdgeInsets.only(
                      left: AppDimens.DIMENS_30.w,
                      right: AppDimens.DIMENS_30.w),
                  itemCount: blogs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return _itemView(context, blogs[index]);
                  },
                  separatorBuilder: (_, int index) => SizedBox(
                        width: AppDimens.DIMENS_20.w,
                      )),
            ),
          ],
        ));
  }

  _goBlogDetail(BuildContext context, BlogEntity brand) {
    Get.toNamed(XRouterPath.blogDetail, parameters: {
      AppParameters.ID: brand.id
    });
  }

  Widget _itemView(BuildContext context, BlogEntity brand) {
    return Container(
      width: AppDimens.DIMENS_500.r,
      child: InkWell(
        onTap: () => _goBlogDetail(context, brand),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: CachedImageView(
                    double.infinity, AppDimens.DIMENS_360.r, brand.image)),
            Padding(
                padding: EdgeInsets.only(top: AppDimens.DIMENS_10.h),
                child: Text(XUtils.textOf(brand.title),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: XTextStyle.color_333333_size_38)),
            Padding(
                padding: EdgeInsets.only(top: AppDimens.DIMENS_10.h),
                child: Text(XUtils.textOf(brand.summary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: XTextStyle.color_999999_size_32)),
          ],
        ),
      ),
    );
  }
}
