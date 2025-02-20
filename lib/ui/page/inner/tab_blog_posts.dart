import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/blog_entity.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TabBlogPosts extends StatefulWidget{
  final String? categoryId;
  const TabBlogPosts(this.categoryId);

  @override
  State<StatefulWidget> createState() => _TabBlogState();
  
}

class _TabBlogState extends State<TabBlogPosts> {
  final RefreshController _refreshController = RefreshController();
  final PageInfo pageInfo = PageInfo(20);
  final RxList<BlogEntity> blogEntitiesX = RxList();
  late double imageWidth;
  late double imageHeight;
  PageState pageState = PageState.loading;
  @override
  void initState() {
    super.initState();
    _onRefresh();
    imageWidth = ScreenUtil().screenWidth / 3;
    imageHeight = imageWidth / 1.5;
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: true,
      header: WaterDropMaterialHeader(
        backgroundColor: AppColors.primaryColor,
      ),
      controller: _refreshController,
      child: contentWidget(),
      onRefresh: _onRefresh,
      onLoading: acquireData,
    );
  }

  Widget contentWidget() {
    if(pageState == PageState.empty) {
      return ViewModelStateWidget.pageStateWidget(pageState, "", () {});
    }
    return Obx(() => ListView.separated(
        padding: EdgeInsets.only(left: AppDimens.DIMENS_30.w, right: AppDimens.DIMENS_30.w, bottom: AppDimens.DIMENS_10.h),
        itemBuilder: (_, index) => _itemView(blogEntitiesX[index]),
        separatorBuilder: (_, index) => SizedBox.shrink(),
        itemCount: blogEntitiesX.length));
  }

  Widget _itemView(BlogEntity blogEntity) {
    return InkWell(
      onTap: () {
        Get.toNamed(XRouterPath.blogDetail, parameters: {
          AppParameters.ID: blogEntity.id
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: AppDimens.DIMENS_10.h),
              child: Text(XUtils.textOf(blogEntity.title),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: XTextStyle.color_000000_size_48_bold)),
          SizedBox(height: AppDimens.DIMENS_10.h,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(XUtils.textOf(blogEntity.createdAt),
                      style: XTextStyle.color_999999_size_36),
                  Padding(
                      padding: EdgeInsets.only(top: AppDimens.DIMENS_10.h),
                      child: Text(XUtils.textOf(blogEntity.summary),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: XTextStyle.color_333333_size_36))
                ],
              )),
              Padding(padding: EdgeInsets.only(bottom: AppDimens.DIMENS_10.h, left: AppDimens.DIMENS_30.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: CachedImageView(
                      imageWidth, imageHeight, blogEntity.image)),)
              ,
            ],
          ),
        ],
      ),
    );
  }

  void _onRefresh() {
    pageInfo.reset();
    acquireData();
  }

  void acquireData() {
    HttpUtil.fetchApiStore().getBlogPosts({
      "Search":{
        "CategoryId" : widget.categoryId
      },
      "PageNum": pageInfo.pageIndex
    }
    ).apiCallback((data) {
      List<BlogEntity> result = data is List<BlogEntity> ? data : [];
      if(result.isNotEmpty) {
        _refreshController.resetNoData();
        if(pageInfo.isFirstPage()) {
          _refreshController.refreshToIdle();
          blogEntitiesX.assignAll(result);
        } else {
          blogEntitiesX.addAll(result);
          _refreshController.loadComplete();
        }
        pageInfo.nextPage();
      } else {
        if(blogEntitiesX.isEmpty) {
          setState(() {
            pageState = PageState.empty;
          });
        }
        _refreshController.loadNoData();
      }
    }, (error) {
      XUtils.showToast(error);
      if(pageInfo.isFirstPage()) {
        _refreshController.refreshFailed();
      } else {
        _refreshController.loadFailed();
      }
    });
  }
}