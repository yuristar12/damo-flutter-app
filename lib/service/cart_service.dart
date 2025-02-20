import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/app_urls.dart';
import 'package:dealful_mall/model/base_response.dart';
import 'package:dealful_mall/model/cart_bean.dart';
import 'package:dealful_mall/model/fill_in_order_entity.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/model/simple_cart_bean.dart';
import 'package:dealful_mall/utils/http_util.dart';

class CartService {
  Future<BaseResponse<FillInOrderEntity>> cartCheckOut(
      Map<String, dynamic> parameters) async {
    BaseResponse<FillInOrderEntity> jsonResult = BaseResponse<FillInOrderEntity>();
    try {
      var response =
          await HttpUtil.instance.get(AppUrls.CART_BUY, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        FillInOrderEntity fillInOrderEntity =
            FillInOrderEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.success = true;
        jsonResult.data = fillInOrderEntity;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
      print(e.toString());
    }
    return jsonResult;
  }

  Future<BaseListResponse<SimpleCartBean>> queryCart(PageInfo pageInfo) {
    return HttpUtil.fetchApiStore().getCartList(pageInfo.pageIndex);
  }
}
