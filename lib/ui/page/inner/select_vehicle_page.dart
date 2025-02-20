import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/ui/widgets/custom_horizontal_steps.dart';
import 'package:dealful_mall/ui/widgets/simple_key_widget.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:dealful_mall/view_model/select_vehicle_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectVehiclePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelectVehicleState();
}

class SelectVehicleState extends State<SelectVehiclePage> {
  final TextEditingController _keyController = TextEditingController();
  final CustomStepsController stepsController = CustomStepsController();
  PageState pageState = PageState.loading;
  late SelectVehicleController xController;
  int _stepIndex = 0;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    String carTypeId = XUtils.textOf(Get.parameters[AppParameters.ID]);
    if (carTypeId.isEmpty) {
      Future.delayed(Duration.zero).then((onValue) {
        Get.offNamed(XRouterPath.selectCarType);
      });
    } else {
      if (Get.isRegistered<SelectVehicleController>()) {
        Get.delete<SelectVehicleController>();
      }
      xController = Get.put(SelectVehicleController());
      xController.typeIdX.value = carTypeId;
      stepsController.addListener(() {
        if (stepsController.currentIndex != _stepIndex) {
          _stepIndex = stepsController.currentIndex;
          prepareData();
        }
      });
      prepareData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.SELECT_YOUR_VEHICLE.translated),
        centerTitle: true,
      ),
      body: buildContent(),
    );
  }

  List<CustomBrunoStep> buildSteps() {
    return [
      CustomBrunoStep(stepContentText: AppStrings.CAR_YEAR.translated),
      CustomBrunoStep(stepContentText: AppStrings.CAR_MAKE.translated),
      CustomBrunoStep(stepContentText: AppStrings.CAR_MODEL.translated),
      CustomBrunoStep(stepContentText: AppStrings.CAR_SUBMODEL.translated),
      CustomBrunoStep(stepContentText: AppStrings.CAR_ENGINE.translated),
    ];
  }

  Widget buildContent() {
    return Column(
      children: [
        CustomHorizontalSteps(
          steps: buildSteps(),
          controller: stepsController,
          onTapCallback: (index) {
            if (index < _stepIndex) {
              stepsController.setCurrentIndex(index);
            }
          },
        ),
        _searchWidget(),
        Expanded(child: contentWidget())
      ],
    );
  }

  Widget _searchWidget() {
    return Container(
      height: AppDimens.DIMENS_90.h,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: AppDimens.DIMENS_30.r, left: AppDimens.DIMENS_30.r, right: AppDimens.DIMENS_30.r),
        decoration: BoxDecoration(
          color: AppColors.COLOR_FFFFFF,
          border: Border.all(
              color: AppColors.COLOR_FFFFFF, width: AppDimens.DIMENS_1.w),
          borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
        ),
        child: TextField(
          onSubmitted: (value) {
            toSearch();
          },
          controller: _keyController,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: AppColors.COLOR_333333,
              fontSize: ScreenUtil().setSp(AppDimens.DIMENS_42)),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: toSearch,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(AppBar().preferredSize.height.w),
                ),
                margin: EdgeInsets.all(AppDimens.DIMENS_10.r),
                child: Icon(
                  Icons.search_outlined,
                  size: AppDimens.DIMENS_70.w,
                  color: Colors.white,
                ),
              ),
            ),
            contentPadding:
            EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
            hintText: AppStrings.KEYWORD.translated,
            hintStyle: XTextStyle.color_999999_size_42,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ));
  }

  contentWidget() {
    if (pageState != PageState.hasData) {
      return ViewModelStateWidget.pageStateWidget(pageState, _errorMessage, () {
        prepareData();
      });
    }
    return Obx(() => ListView.builder(
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              KeyEntity entity = xController.curOptionsX[index];
              if (entity.id?.isNotEmpty == true) {
                xController.saveOption(_stepIndex, entity);
                if (_stepIndex == 4) {
                  BrnDialogManager.showConfirmDialog(context,
                      message: AppStrings.CONFIRM_ACTION.translated,
                      cancel: AppStrings.CANCEL.translated,
                      confirm: AppStrings.OK.translated,onCancel: () {
                        Navigator.pop(context);
                      }, onConfirm: () {
                    xController.storeOption();
                    XRouter.setResult();
                    Get.delete<SelectVehicleController>();
                    Navigator.pop(context);
                    HttpUtil.fetchApiStore().saveSelectCarVehicle().apiCallback((onValue) {
                      XLocalization.tempCarAttribute = "";
                      Get.until((Route<dynamic> route) {
                        String routeName = XUtils.textOf(route.settings.name);
                        int index = routeName.indexOf("?");
                        if (index > 0 && index < routeName.length) {
                          routeName = routeName.substring(0, index);
                        }
                        return ![
                          XRouterPath.selectCarType,
                          XRouterPath.selectVehicle
                        ].contains(routeName);
                      });
                    }, (error) {
                      XLocalization.tempCarAttribute = "";
                      XUtils.showError(error);
                    });
                  });
                } else {
                  stepsController.forwardStep();
                }
              } else {
                XUtils.showToast(AppStrings.INVALID_ATTEMPT.translated);
              }
            },
            child: SimpleKeyWidget(xController.curOptionsX[index]),
          );
        },
        itemCount: xController.curOptionsX.length));
  }

  void prepareData() {
    int curIndex = _stepIndex;
    if (pageState != PageState.loading) {
      setState(() {
        pageState = PageState.loading;
      });
    }
    xController.getOptions(curIndex)?.apiCallback((data) {
      if (_stepIndex == curIndex && data is List<KeyEntity>) {
        xController.originOptionsX.assignAll(data);
        _keyController.text = "";
        toSearch();
      }
    }, (errorMsg) {
      if (_stepIndex == curIndex) {
        setState(() {
          _errorMessage = errorMsg;
          pageState = PageState.error;
        });
      }
    });
  }

  void toSearch() {
    String keyword = _keyController.text;
    xController.searchFor(keyword);
    setState(() {
      if (xController.curOptionsX.isEmpty) {
        pageState = PageState.empty;
      } else {
        pageState = PageState.hasData;
      }
    });
  }
}
