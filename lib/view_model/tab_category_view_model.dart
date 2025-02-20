import 'package:dealful_mall/model/brand_entity.dart';
import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';

class TabDiscoverViewModel extends BaseViewModel {
  final String supplierId;

  TabDiscoverViewModel({this.supplierId = ""});

  var _selectCategoryIndex = 0;
  List<CategoryEntity> _parentCategories = [];
  List<CategoryEntity> _childCategories = [];
  List<BrandEntity> _parentBrandEntities = [];
  bool _parentShouldBuild = false;
  bool _childShouldBuild = false;

  get parentShouldBuild => _parentShouldBuild;

  get childShouldBuild => _childShouldBuild;

  get parentCategories => _parentCategories;

  get brandEntities => _parentBrandEntities;

  get childCategories => _childCategories;

  get selectIndex => _selectCategoryIndex;

  void getParentCategory() {
    Future future;
    if(supplierId.isNotEmpty) {
      future = HttpUtil.fetchApiStore().getSupplierCategories(supplierId);
    } else {
      future = HttpUtil.fetchApiStore().getMainCategories("0", -1);
    }
    future.apiCallback((response) {
      if (response is List<CategoryEntity>) {
        _parentCategories = response;
      } else if(response is CategoryEntity) {
        _parentCategories = response.categories ?? response.children ?? [];
      }
      if (_parentCategories.length > 0) {
        _parentShouldBuild = true;
        getSecondCategory(_parentCategories[0]);
      } else {
        pageState = PageState.empty;
      }
    }, (errorMsg) {
      XUtils.showLog("报错了：$errorMsg");
      errorNotify(errorMsg);
    });
  }

  void getSecondCategory(CategoryEntity entity) {
    if(entity.children?.isNotEmpty == true) {
      _childCategories = entity.children!;
    } else {
      _childCategories = [entity];
    }
    notifyListeners();
  }

  void setParentCategorySelect(int index) {
    _selectCategoryIndex = index;
    getSecondCategory(parentCategories[index]);
  }

  void setCategoryName (int thirdIndex, String name, { int fourthIndex = 0, bool isSetFourth = false }) {
    if (!isSetFourth) {
      _parentCategories[_selectCategoryIndex].children![thirdIndex].thirdName = name;
    } else {
      _parentCategories[_selectCategoryIndex].children![thirdIndex].children![fourthIndex].fourthName = name;
    }
    notifyListeners();
  }

  onRefreshCategory() {
    _selectCategoryIndex = 0;
    getParentCategory();
  }

  void onRefreshBrand() {
    HttpUtil.fetchApiStore().getBrandList().apiCallback((response) {
      if (response is List<BrandEntity>) {
        _parentBrandEntities = response;
      }
      if (_parentBrandEntities.length > 0) {
        notifyListeners();
      } else {
        pageState = PageState.empty;
      }
    }, (errorMsg) {
      errorNotify(errorMsg);
    });
  }

  parentRebuild() {
    _parentShouldBuild = false;
  }
}
