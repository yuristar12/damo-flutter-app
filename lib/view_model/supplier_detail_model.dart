import 'package:dealful_mall/model/ad_banner_entity.dart';
import 'package:dealful_mall/model/brand_entity.dart';
import 'package:dealful_mall/model/category_product_model.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/simple_banner_entity.dart';
import 'package:dealful_mall/model/supplier_profile.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:get/get.dart';

class SupplierDetailModel extends BaseViewModel {
  final String supplierId;
  SupplierProfile? supplierProfile;
  List<ProductEntity>? specialOfferProducts;
  List<ProductEntity>? featuredStoreProducts;
  List<ProductEntity>? newArrivalProducts;
  List<SimpleBannerEntity>? banners;
  List<AdBannerEntity> adBannerEntities = [];
  final List<CategoryProductEntity> categoryProductModels = [];
  final List<BrandEntity> brandList = [];

  SupplierDetailModel(this.supplierId);

  void acquireData({Function()? onSuccess}) {
    List<Future> waits = [];
    waits.add(
        HttpUtil.fetchApiStore().getSupplierProfile(supplierId).then((onValue) {
      supplierProfile = onValue.data;
      onSuccess?.call();
    }, onError: (errorMsg) {}));
    waits.add(HttpUtil.fetchApiStore().getSupplierSliderList(supplierId).then(
        (onValue) {
      banners = onValue.data;
    }, onError: (errorMsg) {}));
    waits.add(HttpUtil.fetchApiStore()
        .getSupplierSpecialOfferProducts(supplierId)
        .then((onValue) {
      specialOfferProducts = onValue.data;
    }, onError: (errorMsg) {}));
    waits.add(HttpUtil.fetchApiStore()
        .getSupplierFeaturedStoreProducts(supplierId)
        .then((onValue) {
      featuredStoreProducts = onValue.data;
    }, onError: (errorMsg) {}));
    waits.add(HttpUtil.fetchApiStore()
        .getSupplierNewProductList(supplierId)
        .then((onValue) {
      newArrivalProducts = onValue.data;
    }, onError: (errorMsg) {}));
    Future.wait(waits).then((onValue) {
      pageState = PageState.hasData;
      notifyListeners();
      acquireRestData();
    });
  }

  /// 加载余下的数据
  void acquireRestData() {
    List<Future> waits = [];
    waits.add(HttpUtil.fetchApiStore()
        .getSupplierCategoriesProductList(supplierId)
        .then((onValue) {
      categoryProductModels.assignAll(onValue.data ?? []);
    }));
    waits.add(HttpUtil.fetchApiStore().getSupplierAdBannerList(supplierId).then(
        (onValue) {
      adBannerEntities = onValue.data ?? [];
    }, onError: (errorMsg) {
      XUtils.showLog(errorMsg);
    }));
    waits.add(HttpUtil.fetchApiStore()
        .getSupplierBrandList(supplierId)
        .then((onValue) {
      brandList.assignAll(onValue.data ?? []);
    }));
    Future.wait(waits).then((onValue) {
      notifyListeners();
    });
  }

  void changeFollow() {
    HttpUtil.fetchApiStore().changeSupplierFollow(supplierId)
        .apiCallback((data){
      HttpUtil.fetchApiStore().getSupplierProfile(supplierId).then((onValue) {
        supplierProfile = onValue.data;
        notifyListeners();
      }, onError: (errorMsg) {});
    });
  }
}
