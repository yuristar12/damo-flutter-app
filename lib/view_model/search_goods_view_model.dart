import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/product_search_model.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';

class SearchGoodsViewModel extends BaseViewModel {
  List<ProductEntity> _goods = [];
  bool _publishTimeConditionArrowUp = false;
  bool _priceConditionArrowUp = false;
  bool _isLoadMore = false;
  int lastUpdateRank = 0;
  var pageIndex = 1;
  final ProductSearchModel searchModel = ProductSearchModel();

  bool get isLoadMore => _isLoadMore;

  bool get publishTimeConditionArrowUp => _publishTimeConditionArrowUp;

  bool get priceConditionArrowUp => _priceConditionArrowUp;

  List<ProductEntity> get goods => _goods;

  setPublicTimeCondition(bool isUp) {
    _publishTimeConditionArrowUp = isUp;
    notifyListeners();
  }

  setPriceCondition() {
    _priceConditionArrowUp = !_priceConditionArrowUp;
    print(_priceConditionArrowUp);
    notifyListeners();
  }

  setPublishTimeCondition() {
    _publishTimeConditionArrowUp = !_publishTimeConditionArrowUp;
    notifyListeners();
  }



  Future<bool> searchGoods(int limit, String sortConditionX) async {
    var sortField;
    var orderType;
    switch (sortConditionX) {
      case AppStrings.SORT_MOST_RECENT:
        sortField = AppStrings.CREATED_AT;
        orderType = AppStrings.DESC;
        break;
      case AppStrings.DEFAULT:
        sortField = "";
        orderType = AppStrings.DESC;
        break;
      case AppStrings.SORT_LOWEST_PRICE:
        sortField = AppStrings.SORT_PRICE;
        orderType = AppStrings.ASC;
        break;
      case AppStrings.SORT_HIGHEST_PRICE:
        sortField = AppStrings.SORT_PRICE;
        orderType = AppStrings.DESC;
        break;
      case AppStrings.SORT_HIGHEST_RATING:
        sortField = AppStrings.SORT_RATING;
        orderType = AppStrings.DESC;
        break;
    }
    var parameters = {
      "PageIndex": pageIndex,
      "PageRows": limit,
      "Search": searchModel.toSearchList(),
      "SortField": sortField,
      "SortType": orderType
    };
    print('parameters${parameters}');
    await HttpUtil.fetchApiStore().getStoreProductList(parameters).then((response) {
      if (response.isSuccess == true) {
        print('response.dataresponse.data${response.data!.length}');
        if (pageIndex == 1) {
          _goods.clear();
          _goods = response.data ?? [];
        } else {
          _goods.addAll(response.data ?? []);
        }
        pageState = _goods.length == 0 ? PageState.empty : PageState.hasData;
        _isLoadMore = (response.total ?? 0) > _goods.length;
        if(response.data?.isNotEmpty == true) {
          pageIndex++;
        }
        lastUpdateRank++;
        notifyListeners();
      } else {
        if (pageIndex == 1) {
          pageState = PageState.error;
        }
        XUtils.showToast(response.message);
        lastUpdateRank++;
        notifyListeners();
      }
    });
    return true;
  }

  void clearGoods () {
    _goods.clear();
    notifyListeners();
  }

  void setSearchProp(String? categoryId, String? brandId, String ? type, {String? supplierId}) {
    searchModel.categoryId = getParamFor(categoryId);
    searchModel.addBrandId(getParamFor(brandId));
    searchModel.companyId = supplierId;
    if(type != null) {
      switch(type) {
        case AppStrings.FEATURED_STORE_PRODUCTS:
          searchModel.isPromoted = 1;
          break;
        case AppStrings.SPECIAL_OFFER_PRODUCTS:
          searchModel.isSpecialOffer = 1;
          break;
      }
    }
  }

  void setKeyword(String? keyword) {
    searchModel.searchIndex = getParamFor(keyword);
  }

  String? getCurKeyword() {
    return searchModel.searchIndex;
  }

  String? getParamFor(String? source) {
    if(source?.isNotEmpty == true) {
      return source;
    }
    return null;
  }
}
