import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/model/brand_detail_entity.dart';
import 'package:dealful_mall/service/brand_detail_service.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';

class BrandDetailViewModel extends BaseViewModel {
  BrandDetailService _brandDetailService = BrandDetailService();
  BrandDetailEntity? _brandDetialEntity;

  BrandDetailEntity? get brandDetialEntity => _brandDetialEntity;

  queryBrandDetail(int id) {
    var parmeters = {AppParameters.ID: id};
    _brandDetailService.queryBrandDetail(parmeters).then((response) {
      if (response.isSuccess!) {
        _brandDetialEntity = response.data;
        pageState = PageState.hasData;
        notifyListeners();
      } else {
        XUtils.showToast(response.message);
      }
    });
  }
}
