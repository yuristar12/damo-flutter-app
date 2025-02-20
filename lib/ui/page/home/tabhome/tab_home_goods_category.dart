import 'package:card_swiper/card_swiper.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/event/tab_select_event.dart';
import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabHomeGoodsCategory extends StatefulWidget {
  final List<CategoryEntity>? _homeModelChannel;
  TabHomeGoodsCategory(this._homeModelChannel);
  @override
  _TabHomeGoodsCategoryState createState() => _TabHomeGoodsCategoryState();
}

class _TabHomeGoodsCategoryState extends State<TabHomeGoodsCategory> {

  @override
  void initState() {
    super.initState();
    print('widget._homeModelChannel${widget._homeModelChannel}');
    splitList(widget._homeModelChannel ?? [], 6);
  }

  _goCategoryView(BuildContext context, CategoryEntity channel) {
    NavigatorUtil.goCategoryGoodsListPage(context, channel);
  }

  int current = 0;
    List<List<CategoryEntity>> twoDimensionalArray = [];

    void splitList(List<CategoryEntity> list, int len) {
      twoDimensionalArray = [];
      if (widget._homeModelChannel != null && widget._homeModelChannel!.isNotEmpty) {
        if (widget._homeModelChannel!.length <= len) {
          if (widget._homeModelChannel!.isNotEmpty) twoDimensionalArray = [widget._homeModelChannel!];
        } else {
          List<CategoryEntity> temp1 = list.skip(0).take(len).toList();
          List<CategoryEntity> temp2 = list.skip(6).take(widget._homeModelChannel!.length - 6).toList();
          twoDimensionalArray.add(temp1);
          twoDimensionalArray.add(temp2);
      }
        setState(() {
          
        });
        print('twoDimensionalArray---${twoDimensionalArray}');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: AppDimens.DIMENS_80.h,
          margin: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
          padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w, ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                  child: Text(AppStrings.FEATURED_CATEGORY.translated,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: XTextStyle.color_333333_size_52_bold)),
              GestureDetector(
                onTap: () {
                  tabSelectBus.fire(TabSelectEvent(1, innerTabIndex: 0));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.COLOR_333333,
                  size: AppDimens.DIMENS_64.r,
                ),
              ),
              SizedBox(
                width: AppDimens.DIMENS_30.w,
              )
            ],
          ),
        ),
        twoDimensionalArray.isNotEmpty ? Container(
          margin: EdgeInsets.only(left: 42.w, right: 42.w, top: 30.h),
          height: twoDimensionalArray.isNotEmpty ? current == 0 ? ((twoDimensionalArray[current].length/2).ceil()*172 + 10).h : ((twoDimensionalArray[current].length/2).ceil() * 172+ 10).h:0,
          child: Swiper(
            index: current,
            autoplay: false,
            // viewportFraction: 0.8,
            // itemHeight: null,
            itemCount: twoDimensionalArray.length,
            itemBuilder: (context, index) {
              return Wrap(
                runSpacing: 12.h,
                alignment: WrapAlignment.spaceBetween,
                children: twoDimensionalArray[index].isNotEmpty ?  List.generate(twoDimensionalArray[index].length, (idx)  {
                  return Container(
                    child: _getGridViewItem(context, twoDimensionalArray[index][idx]),
                  );
                }):[],
              );
              return GridView.builder(
                padding: EdgeInsets.only(
                  top: AppDimens.DIMENS_30.h,
                  left: AppDimens.DIMENS_42.w,
                  right: AppDimens.DIMENS_42.w,
                ),
                physics: NeverScrollableScrollPhysics(),
                //禁止滚动
                shrinkWrap: true,
                itemCount: twoDimensionalArray[index].length,
                itemBuilder: (BuildContext context, int index) {
                  //  return _getGridViewItem(categoryList[index]);
                  if (widget._homeModelChannel == null) {
                    return SizedBox.shrink();
                  }
                  return _getGridViewItem(context, twoDimensionalArray[current][index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2.7,
                  //单个子Widget的水平最大宽度
                  crossAxisCount: 2,
                  //水平单个子Widget之间间距
                  mainAxisSpacing: ScreenUtil().setWidth(AppDimens.DIMENS_20),
                  //垂直单个子Widget之间间距
                  crossAxisSpacing: ScreenUtil().setWidth(AppDimens.DIMENS_20),
                ),
              );
            },
            onIndexChanged: (index) {
              current = index;
              setState(() {
                
              });
            },
          ),
        ):SizedBox.shrink(),
        
        twoDimensionalArray.length > 1 ? Container(
          // color: Colors.white,
          margin: EdgeInsets.only(bottom: 0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(twoDimensionalArray.length, (index) {
              return Container(
                width: current == index ? 40.w:20.w,
                height: 20.w,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: current == index ? AppColors.primaryColor:AppColors.COLOR_999999
                ),
              );
            }),
          ),
        ):SizedBox(height: 10.h,)

        // GridView.builder(
        //   padding: EdgeInsets.only(
        //     top: AppDimens.DIMENS_30.h,
        //     left: AppDimens.DIMENS_42.w,
        //     right: AppDimens.DIMENS_42.w,
        //   ),
        //   physics: NeverScrollableScrollPhysics(),
        //   //禁止滚动
        //   shrinkWrap: true,
        //   itemCount:  widget._homeModelChannel?.length != null ? widget._homeModelChannel!.length > 6 ? 6 : widget._homeModelChannel?.length : 0,
        //   itemBuilder: (BuildContext context, int index) {
        //     //  return _getGridViewItem(categoryList[index]);
        //     if (widget._homeModelChannel == null) {
        //       return SizedBox.shrink();
        //     }
        //     return _getGridViewItem(context, widget._homeModelChannel![index]);
        //   },
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     childAspectRatio: 2.7,
        //     //单个子Widget的水平最大宽度
        //     crossAxisCount: 3,
        //     //水平单个子Widget之间间距
        //     mainAxisSpacing: ScreenUtil().setWidth(AppDimens.DIMENS_20),
        //     //垂直单个子Widget之间间距
        //     crossAxisSpacing: ScreenUtil().setWidth(AppDimens.DIMENS_20),
        //   ),
        // )
      ],
    );
  }

  Widget _getGridViewItem(BuildContext context, CategoryEntity channel) {
    return Container(
      width: (MediaQuery.of(context).size.width - 84.w - 12.h)/2,
      height: 160.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h)
      ),
      child: InkWell(
        onTap: () => _goCategoryView(context, channel),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: AppDimens.DIMENS_10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      XUtils.textOf(channel.name),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: AppColors.COLOR_333333,
                          height: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(40)),
                    ),
                  ],
              )
            )),
            SizedBox(width: 10,),
            Padding(
              padding: EdgeInsets.all(AppDimens.DIMENS_6.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CachedImageView(ScreenUtil().setWidth(AppDimens.DIMENS_120),
                  ScreenUtil().setWidth(AppDimens.DIMENS_120), channel.image)),
            ),
          ],
        ),
      ),
    );
  }
}
