import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/model/order_entity.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/service/mine_service.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';

/**
 * Create by luyouxin
 * description
    Created by $USER_NAME on 2020/10/30.
 */

class OrderViewModel extends BaseViewModel {
  bool _canLoadMore = false;
  List<OrderEntity>? _data = [];
  MineService _mineService = MineService();
  final List<String> searchTypes = ["0", "10", "30", "100"];

  bool get canLoadMore => _canLoadMore;

  List<OrderEntity>? get data => _data;

  queryOrder(int orderType, PageInfo pageInfo) {
    Map<String, dynamic> parameters = {
      "PageNum" : pageInfo.pageIndex,
    };
    switch(orderType) {
      case 1:
        parameters["Search"] = {
          "PaymentStatus" : "awaiting_payment"
        };
        break;
      case 2:
        parameters["Search"] = {
          "shipped_status" : "shipped",
        };
        break;
      case 3:
        parameters["Search"] = {
          "status" : 1,
        };
        break;
    }
    _mineService.queryOrder(parameters).then((response) {
      if (response.isSuccess!) {
        List<OrderEntity> orderListEntities = response.data ?? [];
        if (pageInfo.isFirstPage()) {
          _data = orderListEntities;
        } else {
          _data!.addAll(orderListEntities);
        }
        print(_data!.length);
        _canLoadMore = (response.total ?? 0) > _data!.length;
        pageState = _data!.length == 0 ? PageState.empty : PageState.hasData;
        notifyListeners();
      } else {
        pageState = PageState.error;
        XUtils.showToast(response.message);
        notifyListeners();
      }
    });
  }

  Future<bool?> deleteOrder(String orderId) async {
    bool? result;
    var parameters = {AppParameters.ORDER_ID: orderId};
    await _mineService.deleteOrder(parameters).then((response) {
      result = response.isSuccess;
      if (!result!) {
        XUtils.showToast(response.message);
      }
    });
    return result;
  }

  Future<bool?> cancelOrder(String orderId) async {
    bool? result;
    var parameters = {AppParameters.ORDER_ID: orderId};
    await _mineService.cancelOrder(parameters).then((response) {
      result = response.isSuccess;
      if (!result!) {
        XUtils.showToast(response.message);
      }
    });
    return result;
  }

  /// 是否可取消订单
  bool canCancel(OrderEntity order) {
    return false;
  }

  /// 是否可删除订单
  bool canDelete(OrderEntity order) {
    return false;
  }

}
