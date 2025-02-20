import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/homepage_data.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 币种选择Popop
class CurrencySelectorPopop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelectorPopop> {
  List<CurrencyEntity>? entities;
  Rx<CurrencyEntity?> selectedCurrencyX = Rx(null);

  @override
  void initState() {
    super.initState();
    HttpUtil.fetchApiStore().getHomepageData().apiCallback((res) async {
      if (res is HomepageData) {
        List<CurrencyEntity> data = res.currency?.currencies ?? [];
        CurrencyEntity? entity = XLocalization.currencyEntity;
        if (entity == null || !data.contains(entity)) {
          if (data.isNotEmpty == true) {
            entity = data.first;
          }
        }
        selectedCurrencyX.value = entity;
        setState(() {
          entities = data;
        });
      }
    }, (error) {
      setState(() {
        entities = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (entities?.isEmpty == true) {
      return SizedBox.shrink();
    }
    return SizedBox(
        height: AppDimens.DIMENS_56.h,
        child: Visibility(
          visible: entities?.isNotEmpty == true,
          child: Obx(() => DropdownButton<CurrencyEntity>(
              value: selectedCurrencyX.value,
              underline: const SizedBox.shrink(),
              dropdownColor: Colors.white,
              onChanged: (entity) {
                if (entity != null && entity != selectedCurrencyX.value) {
                  selectedCurrencyX.value = entity;
                  XLocalization.setCurrencyEntity(entity, true);
                }
              },
              items: buildMenuItem(entities ?? []))),
        ));
  }

  List<DropdownMenuItem<CurrencyEntity>> buildMenuItem(
          List<CurrencyEntity> entities) =>
      List.generate(entities.length, (index) {
        CurrencyEntity value = entities[index];
        return DropdownMenuItem<CurrencyEntity>(
            value: value,
            child: Text(
              XUtils.textOf(value.showCode),
              style: XTextStyle.color_333333_size_38,
            ));
      });
}
