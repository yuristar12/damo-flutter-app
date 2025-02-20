import 'dart:math';

import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/comment_entity.dart';
import 'package:dealful_mall/model/inquiry_info_entity.dart';
import 'package:dealful_mall/model/label_entity.dart';
import 'package:dealful_mall/model/product_detail_entity.dart';
import 'package:dealful_mall/model/product_sku_entity.dart';
import 'package:dealful_mall/model/review_entity.dart';
import 'package:dealful_mall/model/tiered_pricing_entity.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:get/get.dart';

class GoodsDetailViewModel extends BaseViewModel {
  ProductDetailEntity? _productDetailEntity;
  bool _isCollection = false;
  String? _toastMessage;
  int? _specificationId;
  final RxInt numberX = RxInt(1);
  String? get toastMessage => _toastMessage;

  ProductDetailEntity? get productDetailEntity => _productDetailEntity;

  bool get isCollection => _isCollection;

  int? get specificationId => _specificationId;
  ReviewEntity? topReviewEntity;
  List<CommentEntity> commentEntities = [];
  Rx<ProductSkuEntity?> skuEntityX = Rx(null);
  RxList<TieredPricing> tieredPricingListX = RxList();
  final RxList<LabelEntity> quantityUnits = RxList();
  final Rx<LabelEntity?> quantityUnitX = Rx<LabelEntity?>(null);
  final RxString curImageUrlX = RxString("");
  void getGoodsDetail(String goodsId) async {
    await Future.wait([
      HttpUtil.fetchApiStore().getProductDetails(goodsId).then((response) {
        if (response.isSuccess == true) {
          pageState =
              response.data == null ? PageState.empty : PageState.hasData;
          _productDetailEntity = response.data;
          _isCollection = _productDetailEntity?.isWishlist == true;
          if(_productDetailEntity != null) {
            fetchSelectedVariation(_productDetailEntity!);
            acquireQuantityUnits(_productDetailEntity?.company?.id);
          }
        } else {
          _productDetailEntity = ProductDetailEntity();
          errorNotify(response.message);
        }
      }, onError: (error) {
        _productDetailEntity = ProductDetailEntity();
        errorNotify(error.toString());
      }),
      HttpUtil.fetchApiStore().getProductReviews(goodsId, 1).then((onValue) {
        topReviewEntity = onValue.data?.firstOrNull;
      }, onError: (error) {}),
      HttpUtil.fetchApiStore().getProductComments(goodsId, 1).then((onValue) {
        if (onValue.data != null) {
          List<CommentEntity> list = onValue.data!;
          commentEntities.assignAll(list.sublist(0, min(5, list.length)));
        }
      }, onError: (error) {}),
    ]).then((onValue) {
      notifyListeners();
    });
  }

  bool isOnSell() {
    return _productDetailEntity?.listingType != "inquiry";
  }

  bool isBidding() {
    return _productDetailEntity?.listingType == "bidding";
  }

  /// 添加或删除收藏
  Future<bool?> addOrDeleteCollect(String goodsId) async {
    bool result = false;
    HttpUtil.fetchApiStore().updateWishlist(goodsId).then((response) {
      result = response.isSuccess == true;
      if (response.isSuccess!) {
        _isCollection = !isCollection;
        notifyListeners();
      } else {
        XUtils.showToast(response.message);
      }
    });
    return result;
  }


  (String?, String) fetchSelectedVariation(
      ProductDetailEntity productDetailEntity) {
    String? imageUrl = null;
    List<ImageBean> imageList = productDetailEntity.imageList ?? [];
    StringBuffer labelBuffer = StringBuffer();
    List<Variations> variations = productDetailEntity.variations ?? [];
    String space = " ";
    for (Variations variation in variations) {
      String displayType =
      XUtils.textOf(variation.optionDisplayType, defValue: "text");
      List<VariationOptions> options = variation.variationOptions ?? [];
      VariationOptions? selectedOption = options.firstOrNull;
      for (VariationOptions option in options) {
        if (option.selectedX.isTrue) {
          selectedOption = option;
          break;
        }
      }
      if (selectedOption != null) {
        selectedOption.selectedX.value = true;
        String optionName = XUtils.textOf(selectedOption.optionName);
        if (labelBuffer.isNotEmpty && optionName.isNotEmpty) {
          labelBuffer.write(space);
        }
        labelBuffer.write(optionName);
        if (displayType == "image") {
          ImageBean? imageBean = imageList.firstWhereOrNull(
                  (test) => test.id == selectedOption?.colorOrImage);
          if (imageBean?.imageSmall?.isNotEmpty == true) {
            imageUrl = imageBean?.imageSmall;
          }
        }
      }
    }
    if (imageUrl == null) {
      imageUrl = productDetailEntity.imageList?.firstWhereOrNull((test) => test.fileType != "2")?.imageSmall;
    } else {
      curImageUrlX.value = imageUrl;
    }
    return (imageUrl, labelBuffer.toString());
  }

  void acquireQuantityUnits(String? supplierId) {
    if (supplierId == null) {
      return;
    }
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) {
      if(value?.isNotEmpty == true) {
        HttpUtil.fetchApiStore()
            .getInquiryInfo(supplierId)
            .apiCallback((successData) {
          if (successData is InquiryInfoEntity) {
            quantityUnits.assignAll(successData.quantityUnit ?? []);
            quantityUnitX.value = quantityUnits.firstOrNull;
          }
        });
      }
    });
  }

  /// 请求报价
  Future<bool?> requestInquiry(ProductDetailEntity productEntity, int number,
      String detailedRequirements) async {
    bool? result;
    var parameters = {
      "ProductId": productEntity.id,
      "ProductQuantity": number,
      "QuantityUnit": quantityUnitX.value?.value,
      "DetailedRequirements": detailedRequirements
    };
    await HttpUtil.fetchApiStore()
        .addInquiryRequest(parameters)
        .then((response) {
      if (response.isSuccess != true) {
        XUtils.showToast(response.message);
      } else {
        result = true;
      }
    });
    return result;
  }

  void updateProductSku() {
    if (_productDetailEntity == null) {
      return;
    }
    ProductDetailEntity productEntity = _productDetailEntity!;
    HttpUtil.fetchApiStore().getProductSku({
      "ProductId": productEntity.id,
      "List": combineVariation(productEntity.variations),
    }).apiCallback((successData) {
      if (successData is ProductSkuEntity) {
        skuEntityX.value = successData;
        var minNum = successData.minNum ?? 1;
        if(numberX < minNum) {
          numberX.value = minNum;
        }
        tieredPricingListX.assignAll(successData.tieredPricing ?? []);
      }
    });
  }

  List<String> combineVariation(List<Variations>? variations) {
    List<String> result = [];
    if (variations != null) {
      for (Variations variation in variations) {
        List<VariationOptions> variationOptions =
            variation.variationOptions ?? [];
        for (VariationOptions variationOption in variationOptions) {
          if (variationOption.selectedX.isTrue) {
            result.add(XUtils.textOf(variationOption.id));
            break;
          }
        }
      }
    }
    return result;
  }
}
