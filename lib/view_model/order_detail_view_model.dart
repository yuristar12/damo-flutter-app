import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/order_detail_entity.dart';
import 'package:dealful_mall/service/mine_service.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';


class OrderDetailViewModel extends BaseViewModel {
  MineService _mineService = MineService();
  OrderDetailEntity? _orderDetailEntity;

  OrderDetailEntity? get orderDetailEntity => _orderDetailEntity;

  queryOrderDetail(String? orderId) {
    if(orderId == null) {
      return;
    }
    _mineService.queryOrderDetail(orderId).then((response) {
      if (response.isSuccess!) {
        _orderDetailEntity = response.data;
        pageState =
            _orderDetailEntity == null ? PageState.empty : PageState.hasData;
        notifyListeners();
      } else {
        pageState = PageState.error;
        XUtils.showToast(response.message);
        notifyListeners();
      }
    });
  }

  bool canCancel() {
    return false;
  }

  bool canDelete() {
    return false;
  }

  bool shouldPay() {
    return _orderDetailEntity?.paymentStatus != AppStrings.PAYMENT_RECEIVED;
  }

  String getOrderStatusText() {
    return XUtils.textOf(_orderDetailEntity?.status);
  }

}
