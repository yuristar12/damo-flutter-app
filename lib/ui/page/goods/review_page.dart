import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/ui/page/goods/comment_tab.dart';
import 'package:dealful_mall/ui/page/goods/review_tab.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReviewPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> with SingleTickerProviderStateMixin{
  int tabIndex = 0;
  String productId = "";

  @override
  void initState() {
    super.initState();
    String? showType = Get.parameters[AppParameters.SHOW_TYPE];
    productId = XUtils.textOf(Get.parameters[AppParameters.GOODS_ID]);
    if(showType == AppStrings.COMMENT) {
      tabIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.REVIEW.translated),
        centerTitle: true,
      ),
      body: SafeArea(child: DefaultTabController(length: 2, initialIndex: tabIndex,
          child: Column(
        children: [
          TabBar(
              isScrollable: true,
              dividerColor: Colors.transparent,
              indicatorColor: AppColors.primaryColor,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.black,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.only(
                  top: AppDimens.DIMENS_10.h,
                  bottom: AppDimens.DIMENS_20.h),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.normal),
              tabs: [
                Text(AppStrings.REVIEW.translated),
                Text(AppStrings.COMMENT.translated),
              ]),
          Expanded(
              child:
              TabBarView(children: [ReviewTab(productId), CommentTab(productId)]))
        ],
      ))),
    );
  }
}
