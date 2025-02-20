import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/ad_banner_entity.dart';
import 'package:dealful_mall/model/blog_entity.dart';
import 'package:dealful_mall/model/brand_entity.dart';
import 'package:dealful_mall/model/car_model.dart';
import 'package:dealful_mall/model/category_product_model.dart';
import 'package:dealful_mall/model/home_entity.dart';
import 'package:dealful_mall/model/homepage_data.dart';
import 'package:dealful_mall/model/homepage_setting.dart';
import 'package:dealful_mall/model/language_entity.dart';
import 'package:dealful_mall/model/simple_json_object.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:get/get.dart';

class TabHomeViewModel extends BaseViewModel {
  final HomeEntity homeModelEntity = HomeEntity();
  List<AdBannerEntity> adBannerEntities = [];
  final List<CategoryProductEntity> categoryProductModels = [];
  final List<BlogEntity> blogList = [];
  final List<BrandEntity> brandList = [];
  final RxString carmodelStrX = RxString("");

  
  void setCurrent (index) {
    print('index---${index}');
    homeModelEntity.index = index;
    notifyListeners();
  }

  void loadTabHomeData() {
    
    HttpUtil.fetchApiStore().getHomepageData().apiCallback((result) async {
      if (result is HomepageData && result.generalSetting != null) {
        await prepareLanguage(result.language);
        loadData(result.generalSetting!);
        // loadMenu();
        // loadRecommendMenu();
        XLocalization.assignCurrency(result.currency?.currencies, result.currency?.defaultCurrency);
      } else {
        pageState = PageState.empty;
        notifyListeners();
      }
    }, (errorMsg) {
      XUtils.showLog(errorMsg);
      pageState = PageState.error;
      notifyListeners();
    });
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) {
      if (value != null) {
        HttpUtil.fetchApiStore().getSelectCarVehicle().apiCallback((data) {
          if (data is List<CarModel>) {
            CarModel? defModel = data.firstWhereOrNull((test) =>
            test.obtainCarAttribute() == XLocalization.getCarAttribute());
            carmodelStrX.value = defModel?.obtainCarModelStr() ??
                AppStrings.YOUR_VEHICLES.translated;
          }
        });
      }
    });
  }

  void loadMenu() {
    HttpUtil.fetchApiStore().getHomePageMenu().then((onValue) {
      print('onValueonValue${onValue.data}');
       homeModelEntity.menu = onValue.data;
       pageState = PageState.hasData;
       notifyListeners();
    });
  } 

  void loadRecommendMenu () {
     HttpUtil.fetchApiStore().getRecommendMenu({
      "ParentId": 0,
      "recursionNum":0
    }).then((onValue) {
      print('onValueonValue${onValue.data}');
       homeModelEntity.recommendMenu = onValue.data;
       notifyListeners();
    });
  }

  void loadData(HomepageSetting homepageSetting) {
    List<Future> waits = [];
    if (homepageSetting.sliderStatus == true) {
      waits.add(HttpUtil.fetchApiStore().getBannerList().then((onValue) {
        homeModelEntity.banner = onValue.data;
      }, onError: (errorMsg) {}));
    }
    if (homepageSetting.featuredCategories == true) {
      waits
          .add(HttpUtil.fetchApiStore().getFeaturedCategories().then((onValue) {
            print('GetFeaturedCategoriesList${onValue.data}');
        homeModelEntity.channel = onValue.data;
      }, onError: (errorMsg) {}));
    }
    waits.add(HttpUtil.fetchApiStore().getHomePageMenu().then((onValue) {
      print('onValueonValuemenu${onValue.data}');
       homeModelEntity.menu = onValue.data;
    }));

    waits.add(HttpUtil.fetchApiStore().getRecommendMenu({
      "ParentId": 0,
      "recursionNum":0
    }).then((onValue) {
      print('onValueonValue${onValue.data}');
       homeModelEntity.recommendMenu = onValue.data;
    }));

    // waits.add(HttpUtil.fetchApiStore().getBackgroundBg().then((onValue) {
    //   print('onValueonValue---背景图${onValue.data}');
    //    homeModelEntity.appSetting = onValue.data;
    //    print('homeModelEntity.appSetting---背景图${homeModelEntity.appSetting}');
    // }));

    waits
        .add(HttpUtil.fetchApiStore().getSpecialOfferProducts().then((onValue) {
      homeModelEntity.specialOfferProducts = onValue.data;
    }, onError: (errorMsg) {}));
    if (homepageSetting.indexPromotedProducts == true) {
      waits.add(
          HttpUtil.fetchApiStore().getFeaturedStoreProducts().then((onValue) {
        homeModelEntity.featuredStoreProducts = onValue.data;
      }, onError: (errorMsg) {}));
    }
    if (homepageSetting.indexLatestProducts == true) {
      waits
          .add(HttpUtil.fetchApiStore().getNewArrivalProducts().then((onValue) {
        homeModelEntity.newArrivalProducts = onValue.data;
      }, onError: (errorMsg) {}));
    }
    waits.add(HttpUtil.fetchApiStore().getHomepageAdBanner().then((onValue){
      adBannerEntities = onValue.data ?? [];
    }, onError: (errorMsg) {
      XUtils.showLog(errorMsg);
    }));
    Future.wait(waits).then((onValue) {
      pageState = PageState.hasData;
      notifyListeners();
      acquireRestData(homepageSetting.indexBlogSlider == true);
    });
    if(homepageSetting.singleCountryMode == true && homepageSetting.singleCountryId?.isNotEmpty == true) {
      SharedPreferencesUtil.getInstance().setString(AppStrings.SINGLE_COUNTRY, homepageSetting.singleCountryId!);
      if(XLocalization.countryEntity?.id != homepageSetting.singleCountryId) {
        XLocalization.saveLocation(null, null, null);
      }
    } else {
      SharedPreferencesUtil.getInstance().remove(AppStrings.SINGLE_COUNTRY);
    }
  }

  Future<bool> receiveCoupon(int? couponId) async {
    return false;
  }

  prepareLanguage(Language? language) {
    if (language == null || language.languages?.isNotEmpty != true) {
      XUtils.showLog("服务端未给出语言项");
      return;
    }
    List<LanguageEntity> languageEntities = language.languages!;
    if (XLocalization.isPrepared() &&
        languageEntities.contains(XLocalization.getLanguageEntity()) ==
            true) {
      return;
    }
    LanguageEntity? selectedLanguage = language.defaultLanguages;
    if(Get.locale != null) {
      String languageKey = "${Get.locale?.languageCode}_${Get.locale?.countryCode}".toLowerCase();
      int index = languageEntities.indexWhere((test)=>test.languageCode?.toLowerCase() == languageKey);
      if(index != -1) {
        selectedLanguage = languageEntities[index];
      }
    } else {
      XUtils.showLog("获取本地语言失败");
    }
    if(selectedLanguage != null) {
      XLocalization.setLanguageEntity(selectedLanguage);
      HttpUtil.fetchApiStore().getGeneralTranslation().apiCallback((result) {
        SharedPreferencesUtil.getInstance().setObject(AppStrings.APP_LANGUAGE, selectedLanguage!);
        if (result is SimpleJsonObject) {
          XLocalization.setLanguagePack(result);
        }
        Get.forceAppUpdate();
      }, (errorMsg) {
        XUtils.showError(errorMsg);
      });
    }
  }

  /// 加载余下的数据
  void acquireRestData(bool showBlog) {
    List<Future> waits = [];
    waits.add(HttpUtil.fetchApiStore().getCategoriesProductList().then((onValue) {
      categoryProductModels.assignAll(onValue.data ?? []);
    }));
    waits.add(HttpUtil.fetchApiStore().getHomeBrandList().then((onValue) {
      brandList.assignAll(onValue.data ?? []);
    }));
    if(showBlog) {
      waits.add(HttpUtil.fetchApiStore().getHomeBlogList().then((onValue) {
        blogList.assignAll(onValue.data ?? []);
      }));
    }
    Future.wait(waits).then((onValue) {
      notifyListeners();
    });
  }
}
