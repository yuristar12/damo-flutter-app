import 'dart:convert';

import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/app_urls.dart';
import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/collection_entity.dart';
import 'package:dealful_mall/model/coupon_entity.dart';
import 'package:dealful_mall/model/foot_print_entity.dart';
import 'package:dealful_mall/model/base_response.dart';
import 'package:dealful_mall/model/order_detail_entity.dart';
import 'package:dealful_mall/model/order_entity.dart';
import 'package:dealful_mall/utils/http_util.dart';

class MineService {
  //收藏或者取消收藏
  Future<BaseResponse<dynamic>> addOrDeleteCollect(
      Map<String, dynamic> parameters) async {
    BaseResponse<dynamic> jsonResult = BaseResponse<dynamic>();
    try {
      var response = await HttpUtil.instance.post(
        AppUrls.COLLECT_ADD_DELETE,
        parameters: parameters,
      );
      if (response[AppStrings.ERR_NO] == 0 ) {
        jsonResult.success = true;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //查询收藏
  Future<BaseResponse<CollectionEntity>> queryCollect(
      Map<String, dynamic> parameters) async {
    BaseResponse<CollectionEntity> jsonResult = BaseResponse<CollectionEntity>();
    try {
      var response = await HttpUtil.instance
          .get(AppUrls.MINE_COLLECT, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        CollectionEntity collectEntity =
            CollectionEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.success = true;
        jsonResult.data = collectEntity;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //查询地址详情
  Future<BaseResponse<AddressEntity>> queryAddressDetail(String addressId)  {
    return HttpUtil.fetchApiStore().getAddressDetail(addressId);
  }

  //删除地址
  Future<BaseResponse> deleteAddress(List<String> ids) async {
    return HttpUtil.fetchApiStore().deleteAddress(json.encode(ids));
  }

  //添加地址
  Future<BaseResponse> saveAddress(Map<String, dynamic> map)  {
    return HttpUtil.fetchApiStore().saveAddress(map);
  }

  //我的优惠券
  Future<BaseResponse<CouponEntity>> queryCoupon(
      Map<String, dynamic> parameters) async {
    BaseResponse<CouponEntity> jsonResult = BaseResponse<CouponEntity>();
    try {
      var response = await HttpUtil.instance
          .get(AppUrls.MINE_COUPON_LIST, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        CouponEntity addressDetailEntity =
            CouponEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.success = true;
        jsonResult.data = addressDetailEntity;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //领取优惠券
  Future<BaseResponse<dynamic>> receiveCoupon(
      Map<String, dynamic> parameters) async {
    BaseResponse<dynamic> jsonResult = BaseResponse<dynamic>();
    try {
      var response = await HttpUtil.instance
          .post(AppUrls.RECEIVE_COUPON, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        jsonResult.success = true;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //反馈
  Future<BaseResponse<dynamic>> feedback(Map<String, dynamic> parameters) async {
    BaseResponse<dynamic> jsonResult = BaseResponse<dynamic>();
    try {
      var response = await HttpUtil.instance.post(
        AppUrls.FEED_BACK,
        parameters: parameters,
      );
      if (response[AppStrings.ERR_NO] == 0) {
        jsonResult.success = true;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //足迹
  Future<BaseResponse<dynamic>> queryFootPrint(
      Map<String, dynamic> parameters) async {
    BaseResponse<FootPrintEntity> jsonResult = BaseResponse<FootPrintEntity>();
    try {
      var response = await HttpUtil.instance.get(
        AppUrls.MINE_FOOTPRINT,
        parameters: parameters,
      );
      if (response[AppStrings.ERR_NO] == 0) {
        FootPrintEntity footPrintEntity =
            FootPrintEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.success = true;
        jsonResult.data = footPrintEntity;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //删除足迹
  Future<BaseResponse<dynamic>> deleteFootPrint(
      Map<String, dynamic> parameters) async {
    BaseResponse<dynamic> jsonResult = BaseResponse<dynamic>();
    try {
      var response = await HttpUtil.instance.post(
        AppUrls.MINE_FOOTPRINT_DELETE,
        parameters: parameters,
      );
      if (response[AppStrings.ERR_NO] == 0) {
        jsonResult.success = true;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //查询订单
  Future<BaseListResponse<OrderEntity>> queryOrder(
      Map<String, dynamic> parameters) {
    return HttpUtil.fetchApiStore().getOrderList(parameters);
  }

  //删除订单
  Future<BaseResponse<dynamic>> deleteOrder(
      Map<String, dynamic> parameters) async {
    BaseResponse<dynamic> jsonResult = BaseResponse<dynamic>();
    try {
      var response = await HttpUtil.instance.post(
        AppUrls.MINE_ORDER_DELETE,
        parameters: parameters,
      );
      if (response[AppStrings.ERR_NO] == 0) {
        jsonResult.success = true;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

  //取消订单
  Future<BaseResponse<dynamic>> cancelOrder(
      Map<String, dynamic> parameters) async {
    BaseResponse<dynamic> jsonResult = BaseResponse<dynamic>();
    try {
      var response = await HttpUtil.instance.post(
        AppUrls.MINE_ORDER_CANCEL,
        parameters: parameters,
      );
      if (response[AppStrings.ERR_NO] == 0) {
        jsonResult.success = true;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
    }
    return jsonResult;
  }

//查询订单详情
  Future<BaseResponse<OrderDetailEntity>> queryOrderDetail(String orderId) {
    return HttpUtil.fetchApiStore().getOrderDetail(orderId);
  }

}
