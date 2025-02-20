import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/app_urls.dart';
import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/create_order_response.dart';
import 'package:dealful_mall/model/fill_in_order_entity.dart';
import 'package:dealful_mall/model/order_shipping.dart';
import 'package:dealful_mall/model/payment_setting.dart';
import 'package:dealful_mall/model/shipping_address.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'dart:convert';
import 'package:alipay_kit/alipay_kit.dart';
class FillInOrderViewModel extends BaseViewModel {
  FillInOrderEntity? _fillInOrderEntity;

  AddressEntity? _shippingAddress;
  AddressEntity? _billingAddress;

  FillInOrderEntity? get fillInOrderEntity => _fillInOrderEntity;

  AddressEntity? get shippingAddress => _shippingAddress;

  AddressEntity? get billingAddress => _billingAddress;
  RxList<PaymentSetting> paymentSettingsX = RxList();
  Rx<PaymentSetting?> selectPaymentX = Rx(null);
  fillInOrder(FillInOrderEntity entity) {
    _fillInOrderEntity = entity;
    pageState = PageState.hasData;
    HttpUtil.fetchApiStore().getPaymentSettings().apiCallback((data) {
      if (data is List<PaymentSetting>) {
        paymentSettingsX.assignAll(data);
        selectPaymentX.value = paymentSettingsX.first;
      }
    }, (errorMsg) {
      XUtils.showError(errorMsg);
    });
    HttpUtil.fetchApiStore().getAddressList().then((response) {
      if (response.data != null) {
        for (AddressEntity entity in response.data!) {
          if (entity.isMain == true) {
            if (entity.addressType == "shipping") {
              _shippingAddress = entity;
            } else {
              _billingAddress = entity;
            }
            if (_shippingAddress != null && _billingAddress != null) {
              break;
            }
          }
        }
      }
      notifyListeners();
    }, onError: (error) {
      notifyListeners();
    });
  }

  updateAddress(var address, bool shipping) {
    if (address != null) {
      if (shipping) {
        _shippingAddress = address;
      } else {
        _billingAddress = address;
      }
      notifyListeners();
    }
  }

  Future<bool> submitOrder() async {
    if (shippingAddress == null) {
      return false;
    }

    if (selectPaymentX.value == null) {
      XUtils.showToast(
          "${AppStrings.COMMON_CHOOSE_HINT.translated}${AppStrings.PAYMENT_METHOD.translated}");
      return false;
    }
    PaymentSetting paymentSetting = selectPaymentX.value!;
    bool succussRes = false;
    var parameters = {
      "PaymentMethod": paymentSetting.nameKey,
      "Id": "",
      "OrderNumber": "",
      "BuyerId": "",
      "BuyerType": "",
      "PriceCurrency": "",
      "CouponCode": "",
      "CouponSellerId": 0,
      "ReturnUrl": AppUrls.PAY_RETURN,
      "CancelUrl": AppUrls.PAY_RETURN,
      "ShippingAddress": ShippingAddress(
        ordersShipping: OrderShipping(id: shippingAddress?.id),
        ordersBilling: OrderShipping(id: billingAddress?.id),
      ),
      "OrderProducts": fillInOrderEntity?.checkedGoodsList
          ?.map((toElement) => toElement.packOrder())
          .toList()
    };
    String paymentNameKey = XUtils.textOf(paymentSetting.nameKey?.toLowerCase());
    bool appPayment = isAppPayment(paymentNameKey);
    if(appPayment) {
      parameters["PaymentType"] = "app";
    }
    EasyLoading.show();
    await HttpUtil.fetchApiStore().submitOrder(parameters).apiCallback((data) {
      succussRes = true;
      EasyLoading.dismiss();
      XRouter.setResult();
      if (data is CreateOrderResponse) {
        switch(paymentNameKey) {
          case AppStrings.PAYMENT_PAYPAL:
            payWithPaypal(data);
            break;
          case AppStrings.PAYMENT_ALIPAY:
            payWithAlipay(data);
            break;
          case AppStrings.PAYMENT_WECHAT:
            payWithWeixin(data);
            break;
        }
      }
    }, (errorMsg) {
      EasyLoading.dismiss();
      XUtils.showToast(errorMsg);
    });
    return succussRes;
  }

  void payWithPaypal(CreateOrderResponse data) {
    List<Links> links = data.paymentOrder?.links ?? [];
    String paypalUrl = XUtils.textOf(
        links.where((test) => test.rel == "approve").firstOrNull?.href);
    Get.toNamed(XRouterPath.webView, parameters: {
      AppParameters.URL: paypalUrl,
    })?.then((onValue) {
      gotoOrderPageOrDetail(data);
    });
  }

  void payWithAlipay(CreateOrderResponse data) async{
    final isInstall = await AlipayKitPlatform.instance.isInstalled();
    if (!isInstall) {
      XUtils.showToast("Alipay is not installed");
    } else {
      String orderInfo = XUtils.textOf(data.paymentOrder?.orderInfo);
      AlipayKitPlatform.instance.payResp().listen((resp){
        if(resp.isSuccessful) {
          gotoOrderPageOrDetail(data);
        } else {
          XUtils.showToast(resp.result);
        }
      });
      AlipayKitPlatform.instance.pay(orderInfo: orderInfo);
    }
  }

  void gotoOrderPageOrDetail(CreateOrderResponse data) {
    if(data.orderIds?.length == 1) {
      gotoOrderDetail(data.orderIds!.first);
    } else {
      gotoOrderList();
    }
  }

  void gotoOrderList() {
    Get.offNamedUntil(XRouterPath.orderPage, ModalRoute.withName(XRouterPath.home));
  }

  void gotoOrderDetail(String id) {
    Get.offNamedUntil(XRouterPath.orderDetailPage,
        ModalRoute.withName(XRouterPath.home), parameters: {
          AppParameters.ORDER_ID: id,
        });
  }

  void payWithWeixin(CreateOrderResponse data) {

  }

  bool isAppPayment(String? nameKey) {
    var lowerNameKey = nameKey?.toLowerCase();
    return lowerNameKey == "alipay" || lowerNameKey == "wechatpay";
  }
}
