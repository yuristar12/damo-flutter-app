import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/ui/page/goods/category_goods_widget.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CategoryGoodsPage extends StatefulWidget {

  @override
  _CategoryGoodsPageState createState() => _CategoryGoodsPageState();
}

class _CategoryGoodsPageState extends State<CategoryGoodsPage> {
  late RxString _categoryNameX;
  late String _categoryId;
  @override
  void initState() {
    super.initState();
    _categoryNameX = RxString(XUtils.textOf(Get.parameters[AppParameters.NAME]));
    _categoryId = Get.parameters[AppParameters.CATEGORY_ID] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(()=>Text(_categoryNameX.value)),
        ),
        body: CategoryGoodsWidget(_categoryId, _categoryNameX));
  }
}
