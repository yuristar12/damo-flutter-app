import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/homepage_data.dart';
import 'package:dealful_mall/model/language_entity.dart';
import 'package:dealful_mall/model/simple_json_object.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 语言选择Popop
class LanguageSelectorPopop extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelectorPopop> {
  List<LanguageEntity>? entities;
  Rx<LanguageEntity?> selectedLanguageX = Rx(null);

  @override
  void initState() {
    super.initState();
    HttpUtil.fetchApiStore().getHomepageData().apiCallback((res) async {
      if (res is HomepageData) {
        List<LanguageEntity> data = res.language?.languages ?? [];
        LanguageEntity? entity = XLocalization.getLanguageEntity();
        LanguageEntity? dafaultLanguage = res.language?.defaultLanguages;
        if(dafaultLanguage != null && !data.contains(dafaultLanguage)) {
          data.insert(0, dafaultLanguage);
        }
        if (entity == null || !data.contains(entity)) {
          if (data.isNotEmpty == true) {
            entity = dafaultLanguage ?? data.first;
          }
        }
        selectedLanguageX.value = entity;
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
          child: Obx(() => DropdownButton<LanguageEntity>(
              value: selectedLanguageX.value,
              underline: const SizedBox.shrink(),
              dropdownColor: Colors.white,
              onChanged: (entity) {
                if (entity != null && entity != selectedLanguageX.value) {
                  loadLanguagePack(entity);
                }
              },
              items: buildMenuItem(entities ?? []))),
        ));
  }

  List<DropdownMenuItem<LanguageEntity>> buildMenuItem(
          List<LanguageEntity> entities) =>
      List.generate(entities.length, (index) {
        LanguageEntity value = entities[index];
        return DropdownMenuItem<LanguageEntity>(
            value: value,
            child: Row(
              children: [
                CachedImageView(
                  AppDimens.DIMENS_100.r,
                  AppDimens.DIMENS_100.r,
                  value.flagPath,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  width: AppDimens.DIMENS_40.r,
                ),
                Text(
                  XUtils.textOf(value.name),
                  style: XTextStyle.color_333333_size_38,
                )
              ],
            ));
      });

  void loadLanguagePack(LanguageEntity entity) async{
    EasyLoading.show();
    XLocalization.setLanguageEntity(entity);
    HttpUtil.fetchApiStore().getGeneralTranslation().apiCallback((result) {
      EasyLoading.dismiss();
      selectedLanguageX.value = entity;
      SharedPreferencesUtil.getInstance().setObject(AppStrings.APP_LANGUAGE, entity);
      if (result is SimpleJsonObject) {
        XLocalization.setLanguagePack(result, true);
      }
      Get.forceAppUpdate();
    }, (errorMsg) {
      EasyLoading.dismiss();
      XUtils.showError(errorMsg);
      if (selectedLanguageX.value != null) {
        XLocalization.setLanguageEntity(selectedLanguageX.value!);
      }
    });
  }
}
