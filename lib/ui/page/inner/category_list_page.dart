import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/ui/page/goods/category_goods_widget.dart';
import 'package:dealful_mall/view_model/category_goods_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoryListPage extends StatefulWidget {

  const CategoryListPage();

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  late String categoryName;
  late String categoryId;
  PageState pageState = PageState.loading;
  String errorMessage = "";
  RxList<CategoryEntity> categoryEntitiesX = RxList();
  @override
  void initState() {
    super.initState();
    categoryId = XUtils.textOf(Get.parameters[AppParameters.ID]);
    categoryName = XUtils.textOf(Get.parameters[AppParameters.CATEGORY_NAME]);
    acquireData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(XUtils.textOf(categoryName)),
          centerTitle: true),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    if(pageState != PageState.hasData) {
      return ViewModelStateWidget.pageStateWidget(pageState, errorMessage, acquireData);
    }
    return Obx(()=>
      ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          CategoryEntity entity = categoryEntitiesX[index];
          return Padding(padding: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_10.h),
            child: Text(XUtils.textOf(entity.name), style: XTextStyle.color_333333_size_48,),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>SizedBox(height: AppDimens.DIMENS_10.h,),
        itemCount: categoryEntitiesX.length,
      )
    );
  }

  void acquireData() {
    HttpUtil.fetchApiStore().getMainCategories(categoryId, 0)
        .apiCallback((data){
          if(data is List<CategoryEntity>) {
              setState(() {
                if(data.isEmpty) {
                  pageState = PageState.empty;
                } else {
                  categoryEntitiesX.assignAll(data);
                }
              });
          }
    }, (error){
          setState(() {
            errorMessage = error;
            pageState = PageState.error;
          });
    });
  }

}
