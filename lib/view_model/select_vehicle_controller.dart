import 'package:dealful_mall/model/base_response.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:get/get.dart';

class SelectVehicleController extends GetxController {
  RxString typeIdX = RxString("");
  RxString yearIdX = RxString("");
  RxString makeIdX = RxString("");
  RxString modelIdX = RxString("");
  RxString subModelIdX = RxString("");
  RxString engineIdX = RxString("");
  RxList<KeyEntity> curOptionsX = RxList();
  RxList<KeyEntity> originOptionsX = RxList();

  Future<BaseListResponse<KeyEntity>>? getOptions(int curIndex) {
    Future<BaseListResponse<KeyEntity>>? resFuture;
    switch (curIndex) {
      case 0:
        resFuture = HttpUtil.fetchApiStore().getCarYear(typeIdX.value);
        break;
      case 1:
        resFuture = HttpUtil.fetchApiStore().getCarMake(yearIdX.value);
        break;
      case 2:
        resFuture = HttpUtil.fetchApiStore().getCarModel(makeIdX.value);
        break;
      case 3:
        resFuture = HttpUtil.fetchApiStore().getCarSubmodel(modelIdX.value);
        break;
      case 4:
        resFuture = HttpUtil.fetchApiStore().getCarEngine(subModelIdX.value);
        break;
    }
    return resFuture;
  }

  /// 保存选项
  void saveOption(int stepIndex, KeyEntity entity) {
    switch(stepIndex) {
      case 0:
        yearIdX.value = XUtils.textOf(entity.id);
        break;
      case 1:
        makeIdX.value = XUtils.textOf(entity.id);
        break;
      case 2:
        modelIdX.value = XUtils.textOf(entity.id);
        break;
      case 3:
        subModelIdX.value = XUtils.textOf(entity.id);
        break;
      case 4:
        engineIdX.value = XUtils.textOf(entity.id);
        break;
    }
  }

  void storeOption() {
    XLocalization.tempCarAttribute = "${typeIdX}_${yearIdX}_${makeIdX}_${modelIdX}_${subModelIdX}_${engineIdX}";
  }

  void searchFor(String keyword) {
    if(keyword.isEmpty) {
      curOptionsX.assignAll(originOptionsX);
    } else {
      keyword = keyword.toLowerCase();
      curOptionsX.assignAll(originOptionsX.where((test)=>test.title?.toLowerCase().contains(keyword) == true));
    }
  }

}
