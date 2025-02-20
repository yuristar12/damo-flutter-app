import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/event/tab_select_event.dart';
import 'package:dealful_mall/model/home_entity.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_best_goods_category.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TabRecommendMenu extends StatefulWidget {
  final List<HomeModelRecommend>? menuData;
  final Color? textColor;
  final bool? isWhite;
  final String? backgroundImage;
  const TabRecommendMenu(this.menuData, this.textColor, this.isWhite, this.backgroundImage);

  @override
  State<TabRecommendMenu> createState() => _TabRecommendMenuState();
}

class _TabRecommendMenuState extends State<TabRecommendMenu> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              current = 0;
              setState(() {
                
              });
            },
            child: Container(
              height: 60.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white, width: current == 0 ? 4.h:0)
                // color: current == 0 ? Colors.white:Colors.transparent
              ),
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(XUtils.textOf(AppStrings.For_You_index.translated), style: TextStyle(
                color:  widget.textColor,
                fontWeight: FontWeight.bold
              )),
            ),
          ),
          Expanded(
            child: Container(
              height: 60.h,
              padding: EdgeInsets.only(right: 40.w,),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.menuData!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Get.toNamed(XRouterPath.searchGoods, parameters: {
                      //   AppParameters.KEYWORD: '',
                      //   AppParameters.BRAND_ID: '',
                      //   AppParameters.CATEGORY_ID: widget.menuData![index].Id.toString(),
                      //   AppParameters.CATEGORY_NAME: widget.menuData![index].Name ?? '',
                      //   AppParameters.TYPE: '',
                      //   AppParameters.TITLE: '',
                      // });
                      current = index + 1;
                      setState(() {
                        
                      });
                      Get.to(TabBestGoodsCategoryPage(), arguments: {
                        "current": index,
                        "menuData": widget.menuData,
                        "backgroundImage": widget.backgroundImage
                      })!.then((val) {
                        current = 0;
                          setState(() {
                            
                          });
                      });
                      // tabSelectBus.fire(TabSelectEvent(1, innerTabIndex: 0, menuIndex: index));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 40.h, left: index == 0 ? 40.w:0),
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      alignment: Alignment.center,
                      decoration: current == index + 1 ? BoxDecoration(
                        borderRadius: BorderRadius.circular(30.h),
                        border: Border.all(color: Colors.white, width: 4.h)
                      ):BoxDecoration(),
                      child: Text(
                          textAlign: TextAlign.center,
                            XUtils.textOf('${widget.menuData![index].Name}'),
                              maxLines: 2,
                              style: TextStyle(
                                color: widget.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    ),
                  );
                }
              ),
            )
          ),
          GestureDetector(
            onTap: () {
              tabSelectBus.fire(TabSelectEvent(1, innerTabIndex: 0,));
            },
            child: Image.asset('${widget.isWhite! ? 'images/icon_menu_w.png':'images/icon_menu_w.png'}', width: 20,),
          )
        ],
      ),
    );
  }
}