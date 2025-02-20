import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/location_entity.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectLocationDialog extends StatelessWidget {
  final Function(LocationEntity? countryEntity, LocationEntity? stateEntity,
      LocationEntity? cityEntity) saveFunc;
  late SelectLocationController xController;
  final bool requireDetailedLocation;

  SelectLocationDialog(
      {super.key,
      required this.saveFunc,
      this.requireDetailedLocation = false}) {
    xController = SelectLocationController();
    xController.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight * 0.58,
        padding: EdgeInsets.symmetric(
            horizontal: AppDimens.DIMENS_30.w, vertical: AppDimens.DIMENS_30.h),
        child: Column(
          children: [
            Expanded(child: ListView(
              children: [
            Center(
              child: Text(
                AppStrings.SELECT_LOCATION.translated,
                style: XTextStyle.color_333333_size_60,
              ),
            ),
            SizedBox(
              height: AppDimens.DIMENS_20.h,
            ),
            Obx(() => Visibility(
                visible: xController.countriesX.isNotEmpty &&
                    xController.singleCountryId.isEmpty,
                replacement: SizedBox(
                  height: AppDimens.DIMENS_100.h,
                ),
                child: DropdownSearch<LocationEntity>(
                  onChanged: (locationEntity) {
                    xController.selectCountry(locationEntity);
                  },
                  itemAsString: (item) => XUtils.textOf(item.name),
                  compareFn: (item1, item2) => item1 == item2,
                  selectedItem: xController.countryX.value,
                  items: (filter, infiniteScrollProps) =>
                      xController.countriesX,
                  decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  )),
                  popupProps: PopupProps.menu(
                      showSearchBox: true,
                      menuProps: MenuProps(
                        backgroundColor: Colors.white,
                      ),
                      onItemsLoaded: (items) {
                        items.removeWhere((test) => test.id == null);
                      },
                      searchFieldProps:
                          TextFieldProps(decoration: InputDecoration()),
                      searchDelay: Duration(milliseconds: 500),
                      constraints:
                          BoxConstraints(maxHeight: AppDimens.DIMENS_800.h)),
                ))),
            SizedBox(
              height: AppDimens.DIMENS_20.h,
            ),
            Obx(
              () => Visibility(
                  visible: xController.statesX.isNotEmpty,
                  replacement: SizedBox(
                    height: AppDimens.DIMENS_100.h,
                  ),
                  child: DropdownSearch<LocationEntity>(
                    onChanged: (locationEntity) {
                      xController.selectState(locationEntity);
                    },
                    itemAsString: (item) => XUtils.textOf(item.name),
                    compareFn: (item1, item2) => item1 == item2,
                    selectedItem: xController.stateX.value,
                    items: (filter, infiniteScrollProps) => xController.statesX,
                    decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    )),
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        menuProps: MenuProps(
                          backgroundColor: Colors.white,
                        ),
                        onItemsLoaded: (items) {
                          items.removeWhere((test) => test.id == null);
                        },
                        searchFieldProps:
                            TextFieldProps(decoration: InputDecoration()),
                        searchDelay: Duration(milliseconds: 500),
                        constraints:
                            BoxConstraints(maxHeight: AppDimens.DIMENS_600.h)),
                  )),
            ),
            SizedBox(
              height: AppDimens.DIMENS_20.h,
            ),
            Obx(
              () => Visibility(
                  visible: xController.citiesX.isNotEmpty,
                  replacement: SizedBox(
                    height: AppDimens.DIMENS_100.h,
                  ),
                  child: DropdownSearch<LocationEntity>(
                    onChanged: (locationEntity) {
                      xController.selectCity(locationEntity);
                    },
                    itemAsString: (item) => XUtils.textOf(item.name),
                    compareFn: (item1, item2) => item1 == item2,
                    selectedItem: xController.cityX.value,
                    items: (filter, infiniteScrollProps) => xController.citiesX,
                    decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    )),
                    popupProps: PopupProps.menu(
                        showSearchBox: true,
                        menuProps: MenuProps(
                          backgroundColor: Colors.white,
                        ),
                        onItemsLoaded: (items) {
                          items.removeWhere((test) => test.id == null);
                        },
                        searchFieldProps:
                            TextFieldProps(decoration: InputDecoration()),
                        searchDelay: Duration(milliseconds: 500),
                        constraints:
                            BoxConstraints(maxHeight: AppDimens.DIMENS_400.h)),
                  )),
            ),],
            )),
            SizedBox(
                width: double.infinity,
                height: AppDimens.DIMENS_120.h,
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColors.COLOR_DCDCDC),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.DIMENS_30)))),
                          onPressed: () => resetSelection(),
                          child: Text(AppStrings.RESET.translated,
                              style: XTextStyle.color_ffffff_size_48),
                        )),
                    SizedBox(
                      width: AppDimens.DIMENS_20.w,
                    ),
                    _buildConfirmWidget()
                  ],
                ))
          ],
        ));
  }

  Widget _buildConfirmWidget() {
    if(requireDetailedLocation) {
      return Obx(() {
        return Visibility(
            visible: !requireDetailedLocation || xController.canSave(),
            child: _buildConfirmWidgetReal());
      });
    } else {
      return _buildConfirmWidgetReal();
    }
  }

  Widget _buildConfirmWidgetReal() {
    return Expanded(
        flex: 6,
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.DIMENS_30)))),
          onPressed: () => _saveSelection(),
          child: Text(AppStrings.OK.translated,
              style: XTextStyle.color_ffffff_size_48),
        ));
  }

  List<DropdownMenuEntry<LocationEntity>> buildDropMenus(
          RxList<LocationEntity> data) =>
      data.map((LocationEntity value) {
        return DropdownMenuEntry<LocationEntity>(
            value: value, label: value.name ?? "");
      }).toList();

  _saveSelection() {
    saveFunc.call(xController.countryX.value, xController.stateX.value,
        xController.cityX.value);
    Get.back();
  }

  resetSelection() {
    xController.resetSelection();
  }
}

class SelectLocationController extends GetxController {
  final RxList<LocationEntity> countriesX = RxList<LocationEntity>();
  final RxList<LocationEntity> statesX = RxList<LocationEntity>();
  final RxList<LocationEntity> citiesX = RxList<LocationEntity>();
  final Rx<LocationEntity?> countryX = Rx(XLocalization.countryEntity);
  final Rx<LocationEntity?> stateX = Rx(XLocalization.stateEntity);
  final Rx<LocationEntity?> cityX = Rx(XLocalization.cityEntity);
  late String singleCountryId;

  @override
  void onInit() async {
    super.onInit();
    singleCountryId = await SharedPreferencesUtil.getInstance()
            .getString(AppStrings.SINGLE_COUNTRY) ??
        "";
    if (singleCountryId.isNotEmpty) {
      countryX.value = LocationEntity(id: singleCountryId);
    }
    acquireData();
  }

  void acquireData() {
    HttpUtil.fetchApiStore().getCountries().then((onValue) {
      countriesX.value = onValue.data ?? [];
      int index = countriesX.indexOf(countryX.value);
      if (index > -1) {
        selectCountry(countriesX[index]);
      } else {
        selectCountry(countriesX.firstOrNull);
      }
    });
  }

  void selectCountry(LocationEntity? locationEntity) {
    if (locationEntity == null) {
      return;
    }
    countryX.value = locationEntity;
    if (locationEntity.id == null) {
      statesX.clear();
      stateX.value = null;
      cityX.value = null;
    } else {
      _acquireStates(locationEntity.id!);
    }
  }

  void selectState(LocationEntity? locationEntity) {
    stateX.value = locationEntity;
    if (locationEntity?.id == null) {
      citiesX.clear();
      cityX.value = null;
    } else {
      _acquireCities(locationEntity!.id!);
    }
  }

  void selectCity(LocationEntity? locationEntity) {
    cityX.value = locationEntity;
  }

  /// 获取省份列表
  void _acquireStates(String countryId) {
    HttpUtil.fetchApiStore().getStates(countryId).then((onValue) {
      if (hasValidItem(onValue.data)) {
        statesX.value = onValue.data ?? [];
        int index = statesX.indexOf(stateX.value);
        if (index > -1) {
          selectState(statesX[index]);
        } else {
          selectState(statesX.firstOrNull);
        }
      } else {
        statesX.clear();
        stateX.value = null;
      }
    });
  }

  /// 获取城市列表
  void _acquireCities(String stateId) {
    HttpUtil.fetchApiStore().getCities(stateId).then((onValue) {
      if (hasValidItem(onValue.data)) {
        citiesX.value = onValue.data ?? [];
        int index = citiesX.indexOf(cityX.value);
        if (index > -1) {
          selectCity(citiesX[index]);
        } else {
          selectCity(citiesX.firstOrNull);
        }
      } else {
        citiesX.clear();
        cityX.value = null;
      }
    });
  }

  bool hasValidItem(List<LocationEntity>? entities) {
    if (entities != null) {
      return entities.firstWhereOrNull((test) => test.id != null) != null;
    }
    return false;
  }

  void resetSelection() {
    countryX.value = null;
    stateX.value = null;
    cityX.value = null;
    if (singleCountryId.isEmpty) {
      countryX.value = countriesX.firstOrNull;
      countriesX.refresh();
      statesX.clear();
    } else {
      stateX.value = statesX.firstOrNull;
      statesX.refresh();
    }
    citiesX.clear();
  }

  bool canSave() {
    return cityX.value?.id != null || (stateX.value?.id != null && citiesX.isEmpty);
  }
}
