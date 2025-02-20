import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/ui/page/mine/order_list_page.dart';
import 'package:dealful_mall/ui/widgets/x_text.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {

  const OrderPage();

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>  {
  int initIndex = 0;
  List<String> title = [
    AppStrings.ORDER_ALL,
    AppStrings.AWAITING_PAYMENT,
    AppStrings.TO_BE_RECEIVED,
    AppStrings.COMPLETED,
    AppStrings.REFUND,
  ];

  @override
  void initState() {
    super.initState();
    initIndex = int.tryParse(Get.parameters["initIndex"]??"") ?? initIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: initIndex,
        length: title.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.ORDERS.translated),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Container(
                color: AppColors.COLOR_FFFFFF,
                child: TabBar(
                  tabs: titleBars(),
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: AppColors.primaryColor,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: AppColors.COLOR_999999,
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: tabBarViews(),
          ),
        ));
  }

  List<Widget> titleBars() {
    List<Widget> titles = [];
    title.forEach((element) {
      titles.add(Tab(
        child: XText(
          element.translated,
          maxLines: 1,
          fontSize: AppDimens.DIMENS_36.sp,
        ),
      ));
    });
    return titles;
  }

  List<Widget> tabBarViews() {
    List<Widget> tabBarViews = [];
    int length = title.length;
    for (int i = 0; i < length; i++) {
      tabBarViews.add(OrderListPage(i));
    }
    return tabBarViews;
  }
}
