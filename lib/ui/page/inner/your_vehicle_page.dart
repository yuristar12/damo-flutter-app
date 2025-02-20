import 'dart:convert';

import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/car_model.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YourVehiclePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => YourVehicleState();
}

class YourVehicleState extends State<YourVehiclePage> {
  PageState pageState = PageState.loading;
  String errorMessage = "";
  RxList<CarModel> carModelsX = RxList();

  @override
  void initState() {
    super.initState();
    acquireData();
  }

  void acquireData() {
    HttpUtil.fetchApiStore().getSelectCarVehicle().apiCallback((data) {
      if (data is List<CarModel>) {
        carModelsX.assignAll(data);
        setState(() {
          if (carModelsX.isNotEmpty) {
            pageState = PageState.hasData;
          } else {
            pageState = PageState.empty;
          }
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
        title: Text(AppStrings.YOUR_VEHICLES.translated),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(XRouterPath.selectCarType)?.then((onValue) {
                if (XRouter.fetchResult() == XRouter.resultOk) {
                  acquireData();
                }
              });
            },
            child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  AppStrings.NEW_ADD.translated,
                  style: XTextStyle.color_000000_size_48,
                )),
          )
        ],
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    if (pageState != PageState.hasData) {
      return ViewModelStateWidget.pageStateWidget(
          pageState, errorMessage, acquireData);
    }
    return Column(
      children: [
        Expanded(
            child: Obx(() => ListView.separated(
                  padding: EdgeInsets.all(AppDimens.DIMENS_30.r),
                  itemBuilder: (_, index) {
                    return carItem(carModelsX[index]);
                  },
                  itemCount: carModelsX.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    height: AppDimens.DIMENS_10.h,
                  ),
                ))),
        SizedBox(
            width: double.infinity,
            child: Padding(
                padding:
                    EdgeInsets.only(left: AppDimens.DIMENS_30.w, right: AppDimens.DIMENS_30.w, bottom: AppDimens.DIMENS_30.h),
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primaryColor),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimens.DIMENS_30)))),
                  onPressed: () {
                    XLocalization.saveCarAttribute(null, true);
                    carModelsX.refresh();
                  },
                  child: Text(AppStrings.RESTORE.translated,
                      style: XTextStyle.color_ffffff_size_48),
                )))
      ],
    );
  }

  Widget carItem(CarModel carmodel) {
    bool isDefault =
        XLocalization.getCarAttribute() == carmodel.obtainCarAttribute();
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
          padding: EdgeInsets.all(AppDimens.DIMENS_20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                carmodel.obtainCarModelStr(),
                style: XTextStyle.color_333333_size_48_bold,
              ),
              Padding(
                padding: EdgeInsets.only(top: AppDimens.DIMENS_10.h),
                child: Text(
                  "${carmodel.year} ${carmodel.engine}",
                  style: XTextStyle.color_666666_size_38,
                ),
              ),
              SizedBox(
                  height: AppDimens.DIMENS_72.r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                              horizontal: AppDimens.DIMENS_10.w)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              side: BorderSide(
                                  color: isDefault
                                      ? AppColors.COLOR_GREEN
                                      : AppColors.primaryColor),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppDimens.DIMENS_10.w)))),
                        ),
                        onPressed: () {
                          if (isDefault) {
                            XLocalization.saveCarAttribute(null, true);
                          } else {
                            XLocalization.saveCarAttribute(
                                carmodel.obtainCarAttribute(), true);
                          }
                          carModelsX.refresh();
                        },
                        child: Text(
                            isDefault
                                ? AppStrings.DEFAULT.translated
                                : AppStrings.SET_AS_DEFAULT.translated,
                            style: isDefault
                                ? XTextStyle.color_7eff21_size_42_bold
                                : XTextStyle.color_primary_size_42_bold),
                      ),
                      SizedBox(
                        width: AppDimens.DIMENS_30.w,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(
                                    horizontal: AppDimens.DIMENS_10.w)),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: AppColors.COLOR_333333),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimens.DIMENS_10.w))))),
                        onPressed: () {
                          removeItem(carmodel);
                        },
                        child: Text(AppStrings.DELETE.translated,
                            style: XTextStyle.color_333333_size_42),
                      ),
                    ],
                  )),
            ],
          )),
    );
  }

  void removeItem(CarModel carmodel) {
    BrnDialogManager.showConfirmDialog(context,
        message: AppStrings.CONFIRM_ACTION.translated,
        cancel: AppStrings.CANCEL.translated,
        confirm: AppStrings.OK.translated, onCancel: () {
      Navigator.pop(context);
    }, onConfirm: () {
      Navigator.pop(context);
      HttpUtil.fetchApiStore()
          .removeSelectedCarVehicle(json.encode([carmodel.id]))
          .apiCallback((successFunc) {
        carModelsX.remove(carmodel);
        if (carmodel.obtainCarAttribute() == XLocalization.getCarAttribute()) {
          XLocalization.saveCarAttribute(
              carModelsX.firstOrNull?.obtainCarAttribute(), true);
          carModelsX.refresh();
        }
      });
    });
  }
}
