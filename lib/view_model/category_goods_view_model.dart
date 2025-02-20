import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/category_title_entity.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/product_search_model.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';

class CategoryGoodsViewModel extends BaseViewModel {
  CategoryTitleEntity? _categoryTitleEntity;
  bool _canLoadMore = false;
  List<ProductEntity> _goods = [];

  List<ProductEntity>? get goods => _goods;

  CategoryTitleEntity? get categoryTitleEntity => _categoryTitleEntity;

  bool get canLoadMore => _canLoadMore;

  void queryCategoryGoods(ProductSearchModel searchModel,String sortCondition, int pageIndex, int limit) {
    var sortField;
    var orderType;
    switch (sortCondition) {
      case AppStrings.SORT_MOST_RECENT:
        sortField = AppStrings.CREATED_AT;
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
    HttpUtil.fetchApiStore().getStoreProductList(parameters).then((response) {
      if (response.isSuccess!) {
        if (pageIndex == 1) {
          _goods.clear();
          _goods = response.data!;
        } else {
          _goods.addAll(response.data!);
        }
        pageState = _goods.length == 0 ? PageState.empty : PageState.hasData;
        _canLoadMore = response.total! > _goods.length;
        notifyListeners();
      } else {
        errorNotify(response.message);
      }
    });
  }

  void queryCategoryName(int categoryId) {
  }
}
