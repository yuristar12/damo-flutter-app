import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/ui/widgets/simple_key_widget.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCarTypePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectCarTypeState();
}

class SelectCarTypeState extends State<SelectCarTypePage> {
  PageState pageState = PageState.loading;
  String errorMessage = "";
  RxList<KeyEntity> carTypesX = RxList();

  @override
  void initState() {
    super.initState();
    HttpUtil.fetchApiStore().getCarTypes({}).apiCallback((data) {
      if (data is List<KeyEntity>) {
        carTypesX.assignAll(data);
        setState(() {
          pageState = PageState.hasData;
        });
      }
    }, (errorMsg) {
      setState(() {
        errorMessage = errorMsg;
        pageState = PageState.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.SELECT_TYPE.translated),
        centerTitle: true,
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    if (pageState != PageState.hasData) {
      return ViewModelStateWidget.pageStateWidget(
          pageState, errorMessage, () {});
    }
    return ListView.builder(
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              String typeId = XUtils.textOf(carTypesX[index].id);
              Get.toNamed(XRouterPath.selectVehicle, parameters: {
                AppParameters.ID: typeId
              });
            },
            child: SimpleKeyWidget(carTypesX[index]),
          );
        },
        itemCount: carTypesX.length);
  }
}
