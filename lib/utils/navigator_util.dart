import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/model/fill_in_order_entity.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'dart:convert';

import 'package:get/get.dart';

class NavigatorUtil {
  static goMallMainPage(BuildContext context) {
    Get.toNamed(XRouterPath.home);
  }

  static goCategoryGoodsListPage(
      BuildContext context, CategoryEntity categoryEntity) {
    goCategoryProductListPage(categoryEntity.id, categoryEntity.name);
  }

  static goGoodsDetails(BuildContext context, String goodsId) {
    Get.toNamed(XRouterPath.goodsDetail, parameters: {
      AppParameters.GOODS_ID: goodsId,
    });
  }

  static goRegister(BuildContext context) {
    Get.toNamed(XRouterPath.register);
  }

  static goLogin(BuildContext context) {
    Get.toNamed(XRouterPath.login);
  }

  static Future? goFillInOrder(BuildContext context, FillInOrderEntity fillInOrderEntity) {
    return Get.toNamed(XRouterPath.fillInOrder, arguments: fillInOrderEntity);
  }

  /// [isSelectType] 0->点击以后不返回 1->点击以后返回数据
  static Future? goAddress(BuildContext context, int isSelectType) {
    return Get.toNamed(XRouterPath.address, parameters: {
      AppParameters.TYPE: isSelectType.toString(),
    });
  }

  static Future? goAddressEdit(BuildContext context, String addressId) {
    return Get.toNamed(XRouterPath.editAddress, parameters: {
      AppParameters.ADDRESS_ID: XUtils.textOf(addressId),
    });
  }

  static Future? goCoupon(BuildContext context) {
    return Get.toNamed(XRouterPath.coupon);
  }

  static goCategoryProductListPage(String? id, String? name) {
    goSearchGoods(Get.context, categoryId: XUtils.textOf(id), categoryName: XUtils.textOf(name));
  }

  static goSearchGoods(BuildContext? context, {String keyword = "", String brandId = "", String categoryId = "",String categoryName = "", String type = "", String title = "", String supplierId = ""}) {
    Get.toNamed(XRouterPath.searchGoods, parameters: {
      AppParameters.KEYWORD: keyword,
      AppParameters.BRAND_ID: brandId,
      AppParameters.CATEGORY_ID: categoryId,
      AppParameters.CATEGORY_NAME: categoryName,
      AppParameters.TYPE: type,
      AppParameters.TITLE: title,
      AppParameters.SUPPLIER_ID: supplierId,
    });
  }

  static goWebView(String? url) {
    Get.toNamed(XRouterPath.webView, parameters: {
      AppParameters.URL: XUtils.textOf(url),
    });
  }

  static goProjectSelectionDetailView(BuildContext context, int? id) {
    Get.toNamed(XRouterPath.projectSelectionDetail, parameters: {
      "id": id.toString(),
    });
  }

  static goCollect(BuildContext context) {
    Get.toNamed(XRouterPath.collect);
  }

  static goAboutUs(BuildContext context) {
    Get.toNamed(XRouterPath.aboutUs);
  }

  static goFeedBack(BuildContext context) {
    Get.toNamed(XRouterPath.feedBack);
  }

  static goFootPrint(BuildContext context) {
    Get.toNamed(XRouterPath.footPrint);
  }

  static goSubmitSuccess(BuildContext context) {
    Get.offNamed(XRouterPath.submitSuccess);
  }

  static goHomeAndClear(BuildContext context) {
    Get.offAndToNamed(XRouterPath.home);
  }

  static goHomeCategoryGoodsPage(BuildContext context, String? title, String? id) {

  }

  static goOrderPage(BuildContext context, int initIndex) {
    Get.toNamed(XRouterPath.orderPage, parameters: {
      "initIndex": initIndex.toString(),
    });
  }

  static goOrderDetailPage(BuildContext context, String? orderId) {
    Get.toNamed(XRouterPath.orderDetailPage, parameters: {
      AppParameters.ORDER_ID: orderId.toString(),
    });
  }
}
