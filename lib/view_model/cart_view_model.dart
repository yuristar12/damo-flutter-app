import 'dart:convert';

import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/base_response.dart';
import 'package:dealful_mall/model/cart_bean.dart';
import 'package:dealful_mall/model/fill_in_order_entity.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/model/product_detail_entity.dart';
import 'package:dealful_mall/model/simple_cart_bean.dart';
import 'package:dealful_mall/service/cart_service.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:get/get.dart';

class CartViewModel extends BaseViewModel {
  CartService _cartService = CartService();
  bool _isAllCheck = false;
  bool _isShowBottomView = false;
  bool loading = false;
  bool get isShowBottomView => _isShowBottomView;

  List<SimpleCartBean>? _cartList;

  List<SimpleCartBean> get cartList => _cartList ?? [];

  bool get isAllCheck => _isAllCheck;
  final PageInfo pageInfo = PageInfo(50);
  RxInt cartNum = RxInt(0);

  Future<bool?> addCart(ProductDetailEntity productEntity, int number) async {
    bool? result;
    List<Map<String, dynamic>> combined =
        combineCartVariation(productEntity.variations);
    var parameters = {
      "ProductId": productEntity.id,
      "Num": number,
      "ProductVariations": combined
    };
    await HttpUtil.fetchApiStore().addCart(parameters).then((response) {
      if (response.isSuccess != true) {
        XUtils.showToast(response.message);
      } else {
        queryCart(true);
        result = true;
      }
    });
    return result;
  }

  /// [negotiatePrice]: 买家意愿的价格
  Future<bool?> requestQuote(ProductDetailEntity productEntity, int number,
      double negotiatePrice) async {
    bool? result;
    List<Map<String, dynamic>> combined =
        combineQuoteVariation(productEntity.variations);
    var parameters = {
      "ProductId": productEntity.id,
      "ProductName": productEntity.name,
      "SellerId": productEntity.userId,
      "ProductQuantity": number,
      "ProductVariations": combined,
      "NegotiatePrice": negotiatePrice
    };
    await HttpUtil.fetchApiStore().addQuoteRequest(parameters).then((response) {
      if (response.isSuccess != true) {
        XUtils.showToast(response.message);
      } else {
        result = true;
      }
    });
    return result;
  }

  List<Map<String, dynamic>> combineCartVariation(
      List<Variations>? variations) {
    List<Map<String, dynamic>> result = [];
    if (variations != null) {
      for (Variations variation in variations) {
        String key = XUtils.textOf(variation.labelName);
        String variationId = XUtils.textOf(variation.id);
        String value = "";
        String optionId = "";
        List<VariationOptions> variationOptions =
            variation.variationOptions ?? [];
        for (VariationOptions variationOption in variationOptions) {
          if (variationOption.selectedX.isTrue) {
            value = XUtils.textOf(variationOption.optionName);
            optionId = XUtils.textOf(variationOption.id);
            break;
          }
        }
        result.add({
          "VariationId": variationId,
          "VariationOptionId": optionId,
          "Key": key,
          "Value": value
        });
      }
    }
    return result;
  }

  /// 组成报价变体
  List<Map<String, dynamic>> combineQuoteVariation(
      List<Variations>? variations) {
    List<Map<String, dynamic>> result = [];
    if (variations != null) {
      for (Variations variation in variations) {
        List<VariationOptions> variationOptions =
            variation.variationOptions ?? [];
        Map<String, dynamic>? map = null;
        for (VariationOptions variationOption in variationOptions) {
          if (variationOption.selectedX.isTrue) {
            map = {
              "Id": variationOption.id,
              "OptionName": variationOption.optionName,
            };
            break;
          }
        }
        if (map != null) {
          result.add({
            "Id": variation.id,
            "Name": variation.labelName,
            "VariationOptions": map
          });
        }
      }
    }
    return result;
  }

  queryCart([bool refresh = false]) {
    if(loading) {
      return;
    }
    loading = true;
    if (refresh) {
      pageInfo.reset();
    }
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        _cartService.queryCart(pageInfo).apiCallback((successData) {
          loading = false;
          if (successData is List<SimpleCartBean>) {
            if (pageInfo.isFirstPage()) {
              _cartList = successData;
              if (_cartList?.isNotEmpty == true) {
                setCheckAll(true);
              }
            } else {
              if (successData.isNotEmpty) {
                _cartList?.addAll(successData);
              }
            }
            refreshViewWhenDataChanged();
            if (successData.isNotEmpty) {
              pageInfo.nextPage();
            }
          }
        }, (error) {
          loading = false;
          if(_cartList == null || _cartList?.isEmpty == true) {
            pageState = PageState.error;
          }
          notifyListeners();
        });
      }
    });
    freshCartNum();
  }

  void freshCartNum() {
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) {
      if (value == null || value.isEmpty) {
        return;
      }
      HttpUtil.fetchApiStore().getCartCount().then((onValue) {
        if (onValue.success == true) {
          cartNum.value = onValue.data ?? 0;
        }
      }, onError: (error) {});
    });
  }

  void refreshViewWhenDataChanged() {
    _isAllCheck = _checkedAll();
    if (_cartList?.isNotEmpty == true) {
      pageState = PageState.hasData;
      _isShowBottomView = true;
    } else {
      pageState = PageState.empty;
      _isShowBottomView = false;
    }
    notifyListeners();
  }

  bool _checkedAll() {
    if (_cartList == null) {
      return false;
    }
    for (int i = 0; i < _cartList!.length; i++) {
      if (!_cartList![i].checked) {
        return false;
      }
    }
    return true;
  }

  void deleteCartGoods(List<String> ids, int cartIndex, int productIndex) {
    HttpUtil.fetchApiStore().deleteCartItem(json.encode(ids)).apiCallback(
        (data) {
      _cartList?[cartIndex].shoppingCartProduct?.removeAt(productIndex);
      if (_cartList?[cartIndex].shoppingCartProduct?.isEmpty == true) {
        _cartList?.removeAt(cartIndex);
      }
      freshCartNum();
      refreshViewWhenDataChanged();
    }, (errorMsg) {
      XUtils.showToast(errorMsg);
    });
  }

  updateCartItem(ShoppingCartProduct cartbean, int num) {
    var map = {"Id": cartbean.id, "Num": num};
    HttpUtil.fetchApiStore().modifyCartItem(map).apiCallback((data) {
      cartbean.num = num;
      notifyListeners();
    }, (errorMessage) {
      cartbean.changeTag++;
      notifyListeners();
    });
  }

  checkCartItem(SimpleCartBean cartBean, bool isCheck) {
    cartBean.checked = isCheck;
    List<ShoppingCartProduct> cartProducts = cartBean.shoppingCartProduct ?? [];
    for (ShoppingCartProduct cartProduct in cartProducts) {
      cartProduct.checked = isCheck;
    }
    _isAllCheck = _checkedAll();
    notifyListeners();
  }

  checkProductItem(
      SimpleCartBean cartBean, ShoppingCartProduct productBean, bool isCheck) {
    productBean.checked = isCheck;
    List<ShoppingCartProduct> cartProducts = cartBean.shoppingCartProduct ?? [];
    bool cartChecked = true;
    for (ShoppingCartProduct cartProduct in cartProducts) {
      cartChecked &= cartProduct.checked;
    }
    cartBean.checked = cartChecked;
    _isAllCheck = _checkedAll();
    notifyListeners();
  }

  /// 计算总价
  double countMoney() {
    int result = 0;
    if (_cartList != null) {
      for (SimpleCartBean item in cartList) {
        List<ShoppingCartProduct> cartProducts = item.shoppingCartProduct ?? [];
        for (ShoppingCartProduct cartProduct in cartProducts) {
          if (cartProduct.checked) {
            result += (cartProduct.unitPrice ?? 0) * (cartProduct.num ?? 0);
          }
        }
      }
    }
    return result.toDouble() / 100;
  }

  void setCheckAll(bool checked) {
    _isAllCheck = checked;
    if (_cartList != null) {
      for (SimpleCartBean item in _cartList!) {
        item.checked = checked;
        List<ShoppingCartProduct> cartProducts = item.shoppingCartProduct ?? [];
        for (ShoppingCartProduct cartProduct in cartProducts) {
          cartProduct.checked = checked;
        }
      }
      notifyListeners();
    }
  }

  FillInOrderEntity? packOrder() {
    List<CartBean> checkedGoods = [];
    int sum = 0;
    bool hasChecked = false;
    if (_cartList != null) {
      for (SimpleCartBean item in cartList) {
        List<ShoppingCartProduct> cartProducts = item.shoppingCartProduct ?? [];
        for (ShoppingCartProduct cartProduct in cartProducts) {
          if (cartProduct.checked) {
            hasChecked = true;
            sum += (cartProduct.unitPrice ?? 0) * (cartProduct.num ?? 0);
            checkedGoods.add(convertCartBean(item, cartProduct));
          }
        }
      }
    }
    double result = sum.toDouble() / 100;
    return hasChecked
        ? FillInOrderEntity(
            actualPrice: result,
            orderTotalPrice: result,
            goodsTotalPrice: result,
            checkedGoodsList: checkedGoods)
        : null;
  }

  /// 立即购买
  Future<FillInOrderEntity?> packBuyOrder(
      ProductDetailEntity? productEntity, int number) async {
    List<Map<String, dynamic>> combined =
        combineCartVariation(productEntity?.variations);
    var map = {
      "ProductId": productEntity?.id,
      "Num": number,
      "ProductVariations": combined
    };
    try {
      BaseResponse<SimpleCartBean> response =
          await HttpUtil.fetchApiStore().buyNow(map);
      SimpleCartBean? item = response.data;
      if (item != null && item.shoppingCartProduct?.isNotEmpty == true) {
        CartBean cartBean =
            convertCartBean(item, item.shoppingCartProduct!.first);
        List<CartBean> checkedGoods = [cartBean];
        int totalPrice = (cartBean.unitPrice ?? 0) * number;
        double result = totalPrice.toDouble() / 100;
        return FillInOrderEntity(
            actualPrice: result,
            orderTotalPrice: result,
            goodsTotalPrice: result,
            checkedGoodsList: checkedGoods);
      } else {
        XUtils.showError(response.message);
      }
    } catch (e) {
      XUtils.showError(e.toString());
    }

    return null;
  }

  void loadMore() {
    queryCart();
  }

  String obtainKey(ShoppingCartProduct cartBean) {
    return "${cartBean.id}_${cartBean.num}_${cartBean.changeTag}";
  }

  CartBean convertCartBean(
      SimpleCartBean item, ShoppingCartProduct cartProduct) {
    Product? product = cartProduct.product;
    SkuInfo? skuInfo = cartProduct.skuInfo;
    return CartBean(
        id: cartProduct.id,
        productId: cartProduct.product?.id,
        productName: product?.title,
        productImage: product?.imageUrl,
        productVariations: cartProduct.productVariations,
        userId: item.company?.id,
        unitPrice: skuInfo?.unitPrice,
        showUnitPrice: skuInfo?.price,
        num: cartProduct.num,
        company: item.company,
        variationOptionIds: cartProduct.variationOptionIds);
  }
}
