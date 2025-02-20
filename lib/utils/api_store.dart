import 'package:dealful_mall/model/ad_banner_entity.dart';
import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/base_response.dart';
import 'package:dealful_mall/model/blog_category.dart';
import 'package:dealful_mall/model/blog_detail_entity.dart';
import 'package:dealful_mall/model/blog_entity.dart';
import 'package:dealful_mall/model/brand_entity.dart';
import 'package:dealful_mall/model/car_model.dart';
import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/model/category_product_model.dart';
import 'package:dealful_mall/model/column_item_entity.dart';
import 'package:dealful_mall/model/comment_entity.dart';
import 'package:dealful_mall/model/comment_record.dart';
import 'package:dealful_mall/model/create_order_response.dart';
import 'package:dealful_mall/model/custom_find_entity.dart';
import 'package:dealful_mall/model/home_entity.dart';
import 'package:dealful_mall/model/homepage_data.dart';
import 'package:dealful_mall/model/inquiry_info_entity.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/model/location_entity.dart';
import 'package:dealful_mall/model/order_detail_entity.dart';
import 'package:dealful_mall/model/order_entity.dart';
import 'package:dealful_mall/model/payment_setting.dart';
import 'package:dealful_mall/model/product_detail_entity.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/product_sku_entity.dart';
import 'package:dealful_mall/model/quote_entity.dart';
import 'package:dealful_mall/model/review_entity.dart';
import 'package:dealful_mall/model/simple_banner_entity.dart';
import 'package:dealful_mall/model/simple_cart_bean.dart';
import 'package:dealful_mall/model/simple_json_object.dart';
import 'package:dealful_mall/model/store_entity.dart';
import 'package:dealful_mall/model/supplier_entity.dart';
import 'package:dealful_mall/model/supplier_profile.dart';
import 'package:dealful_mall/model/user_info.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_store.g.dart';

@RestApi()
abstract class ApiStore {
  factory ApiStore(Dio dio, String? baseUrl) {
    return _ApiStore(dio, baseUrl: baseUrl);
  }

  @POST('Base_Manage/Home/SubmitStoreLogin')
  Future<BaseResponse> loginClient(@Field("language") String lang, @Field("userName") String userName, @Field("password") String password,
      [@Field("IsAppletLogin") int appletLogin = 0]);

  @POST('Store/StoreUser/GetProfile')
  Future<BaseResponse<UserInfo>> getOperatorInfo();

  @POST('Store/Categories/GetFeaturedCategoriesList')
  Future<BaseListResponse<CategoryEntity>> getFeaturedCategories();

  /**
   * 获取分类信息，当parentId = 0时指根分类，recursionNum = -1指提取parentId下的所有分类，recursionNum=0指提取parentId下的第一级分类
   */
  @POST('Store/Categories/GetCategoriesList')
  Future<BaseListResponse<CategoryEntity>> getMainCategories(@Field("ParentId") String parentId, @Field("recursionNum") int recursionNum);

  @POST('Store/StoreProducts/GetSellStoreProductsListV2')
  Future<BaseListResponse<ProductEntity>> getStoreProductList(@Body() Map<String, dynamic> map);

  @POST('Store/StoreProducts/GetProductDetails')
  Future<BaseResponse<ProductDetailEntity>> getProductDetails(@Field("id") String productId);

  @POST('Store/ShoppingCart/GetMyShoppingCarts')
  Future<BaseListResponse<SimpleCartBean>> getCartList([@Field("PageIndex") int pageIndex = 1]);

  @POST('Store/ShoppingCart/ModifyShoppingCart')
  Future<BaseResponse> modifyCartItem(@Body() Map<String, dynamic> map);

  @POST('Store/ShoppingCart/RemoveShoppingCart')
  Future<BaseResponse> deleteCartItem(@Body() String ids);

  /// 添加购物车
  @POST('Store/ShoppingCart/AddShoppingCart')
  Future<BaseResponse> addCart(@Body() Map<String, dynamic> map);

  /// 获取地址列表
  @POST('Store/StoreUser/GetShippingAddressesList')
  Future<BaseListResponse<AddressEntity>> getAddressList();

  /// 获取地址类型
  @POST('Store/ShippingAddresses/GetShippingAddressesType')
  Future<BaseListResponse<KeyEntity>> getAddressType();

  @POST('Store/ShippingAddresses/GetTheShippingAddresses')
  Future<BaseResponse<AddressEntity>> getAddressDetail(@Field("Id") String addressId);

  /// 删除地址
  @POST('Store/ShippingAddresses/RemoveShippingAddresses')
  Future<BaseResponse> deleteAddress(@Body() String ids);

  /// 保存地址
  @POST('Store/ShippingAddresses/SaveShippingAddresses')
  Future<BaseResponse> saveAddress(@Body() Map<String, dynamic> map);

  /// 保存订单
  @POST('Store/Orders/ClientCreateOrder')
  Future<BaseResponse<CreateOrderResponse>> submitOrder(@Body() Map<String, dynamic> map);

  /// 获取订单列表
  @POST('Store/View/Orders/GetMyOrders')
  Future<BaseListResponse<OrderEntity>> getOrderList(@Body() Map<String, dynamic> map);

  /// 获取文件下载链接
  @POST('Base_Manage/Base_SaveFiled/GetFile')
  Future<BaseResponse<String>> getFile(@Field("id") String fileId);

  /// 获取Banner
  @POST('Store/HomePage/GetDisplaySliderList')
  Future<BaseListResponse<SimpleBannerEntity>> getBannerList();

  /// 注册接口
  @POST('Store/StoreUser/Register')
  Future<BaseResponse> register(@Body() Map<String, dynamic> map);

  /// 注册接口
  @GET('{url}')
  Future<BaseResponse<SimpleJsonObject>> requestUrl(@Path() String url);

  /// 获取订单详情
  @POST('Store/View/Orders/GetMyOrderDetail')
  Future<BaseResponse<OrderDetailEntity>> getOrderDetail(@Field("Id") String orderId);

  /// 获取热销产品
  @POST('Store/HomePage/GetSpecialOfferProductsList')
  Future<BaseListResponse<ProductEntity>> getSpecialOfferProducts();

  /// 获取限时抢购产品
  @POST('Store/HomePage/GetFeaturedStoreProductsList')
  Future<BaseListResponse<ProductEntity>> getFeaturedStoreProducts();

  /// 获取新到货的产品
  @POST('Store/HomePage/GetNewArrivalProductsList')
  Future<BaseListResponse<ProductEntity>> getNewArrivalProducts();

  /// 获取首页广告位
  @POST('Store/HomePage/GetHomepageBannerList')
  Future<BaseListResponse<AdBannerEntity>> getHomepageAdBanner();

  /// 获取语言包
  @POST('Store/HomePage/GetGeneralTranslation')
  Future<BaseResponse<SimpleJsonObject>> getGeneralTranslation();

  /// 获取首页数据
  @POST('Store/HomePage/GetHomePageData')
  Future<BaseResponse<HomepageData>> getHomepageData();

  /// 获取国家列表
  @POST('Store/Countries/GetCountries')
  Future<BaseListResponse<LocationEntity>> getCountries();

  /// 获取省份列表
  @POST('Store/States/GetStates')
  Future<BaseListResponse<LocationEntity>> getStates(@Field("CountryId") String countryId);

  /// 获取城市列表
  @POST('Store/Cities/GetCities')
  Future<BaseListResponse<LocationEntity>> getCities(@Field("StateId") String stateId);

  /// 获取自定义产品分类
  @POST('Store/HomePage/GetHomePageCategoriesProductList')
  Future<BaseListResponse<CategoryProductEntity>> getCategoriesProductList();

  /// 获取首页品牌列表
  @POST('Store/HomePage/GetHomePageBrandsList')
  Future<BaseListResponse<BrandEntity>> getHomeBrandList();

  /// 获取博客列表
  @POST('Store/HomePage/GetHomePageBlogList')
  Future<BaseListResponse<BlogEntity>> getHomeBlogList();

  /// 获取品牌列表
  @POST('Store/Brands/GetBrandsList')
  Future<BaseListResponse<BrandEntity>> getBrandList([@Body() Map<String, dynamic> map = const {}]);

  /// 获取商品评分列表
  @POST('Store/Reviews/GetProductsReviewsList')
  Future<BaseListResponse<ReviewEntity>> getProductReviews(@Field("Search") String productId, @Field("PageNum") int pageNum);

  /// 获取商品评论列表
  @POST('Store/Comments/GetProductsCommentsList')
  Future<BaseListResponse<CommentEntity>> getProductComments(@Field("Search") String productId, @Field("PageNum") int pageNum);

  /// 获取心愿单
  @POST('Store/WishList/GetOwnWishList')
  Future<BaseListResponse<ProductEntity>> getOwnWishlist();

  /// 添加/删除心愿单
  @POST('Store/WishList/AddRemoveWishlist')
  Future<BaseResponse> updateWishlist(@Field("ProductId") String productId);

  /// 获取支付设置
  @POST('Store/PaymentSettings/ClientGetPaymentSettings')
  Future<BaseListResponse<PaymentSetting>> getPaymentSettings();

  /// 获取博客详情
  @POST('Store/BlogPosts/GetBlogPostDetail')
  Future<BaseResponse<BlogDetailEntity>> getBlogDetail(@Field("Id") String blogId);

  /// 获取博客评论
  @POST('Store/BlogComments/GetBlogDetailCommentsList')
  Future<BaseListResponse<CommentEntity>> getBlogComments(@Body() Map<String, dynamic> map);

  /// 获取博客分类
  @POST('Store/BlogCategories/GetDisplayBlogCategories')
  Future<BaseListResponse<BlogCategory>> getBlogCategories();

  /// 获取博客列表
  @POST('Store/BlogPosts/GetDisplayBlogPostsList')
  Future<BaseListResponse<BlogEntity>> getBlogPosts(@Body() Map<String, dynamic> map);

  /// 新增博客评论
  @POST('Store/BlogComments/AddComment')
  Future<BaseResponse> addBlogComment(@Body() CommentRecord record);

  /// 请求报价
  @POST('Store/QuoteRequests/AddQuoteRequest')
  Future<BaseResponse> addQuoteRequest(@Body() Map<String, dynamic> map);

  /// 获取报价列表
  @POST('Store/QuoteRequests/GetMyQuoteRequests')
  Future<BaseListResponse<QuoteEntity>> getMyQuoteRequests(@Field("PageNum") int pageIndex);

  /// 删除一条报价
  @POST('Store/QuoteRequests/RemoveQuoteRequest')
  Future<BaseResponse> removeQuoteRequest(@Field("Id") String id);

  /// 直接购买
  @POST('Store/ShoppingCart/BuyNow')
  Future<BaseResponse<SimpleCartBean>> buyNow(@Body() Map<String, dynamic> map);

  /// 获取车种列表
  @POST('Store/CarType/GetCarTypes')
  Future<BaseListResponse<KeyEntity>> getCarTypes(@Body() Map<String, dynamic> map);

  /// 获取年份
  @POST('Store/CarYear/GetCarYear')
  Future<BaseListResponse<KeyEntity>> getCarYear(@Field("TypeId") String typeId);

  /// 获取车辆品牌列表
  @POST('Store/CarMake/GetCarMake')
  Future<BaseListResponse<KeyEntity>> getCarMake(@Field("YearId") String yearId);

  /// 获取车辆型号列表
  @POST('Store/CarModel/GetCarModel')
  Future<BaseListResponse<KeyEntity>> getCarModel(@Field("MakeId") String id);

  /// 获取车辆子型号列表
  @POST('Store/CarSubmodel/GetCarSubmodel')
  Future<BaseListResponse<KeyEntity>> getCarSubmodel(@Field("ModelId") String id);

  /// 获取引擎列表
  @POST('Store/CarEngine/GetCarEngine')
  Future<BaseListResponse<KeyEntity>> getCarEngine(@Field("SubmodelId") String id);

  /// 保存选择的车型
  @POST('Store/CarVehicle/SaveSelectCarVehicle')
  Future<BaseResponse> saveSelectCarVehicle();

  /// 获取选择的车型
  @POST('Store/CarVehicle/GetSelectCarVehicle')
  Future<BaseListResponse<CarModel>> getSelectCarVehicle();

  /// 删除选择的车型
  @POST('Store/CarVehicle/RemoveSelectedCarVehicle')
  Future<BaseResponse> removeSelectedCarVehicle(@Body() String ids);

  /// 获取自定义筛选项
  @POST('Store/CustomFields/GetSearchProductCustomFieldsList')
  Future<BaseListResponse<CustomFindEntity>> getCustomFieldsForCategory(@Field("id") String categoryId);

  /// 获取供应商列表
  @POST('Store/StoreUser/GetSupplierList')
  Future<BaseListResponse<SupplierEntity>> getSupplierList(@Body() Map<String, dynamic> map);

  /// 获取导航菜单
  @POST('/Store/HomePage/GetHomePageNavigationMenuData')
  Future<BaseListResponse<HomeModelMenu>> getHomePageMenu();

  /// 获取推精选
  @POST('/Store/Categories/GetCategoriesList')
  Future<BaseListResponse<HomeModelRecommend>> getRecommendMenu(@Body() Map<String, dynamic> map);

  /// 获取自定义背景图
  @POST('/Store/AppSettings/GetAppSetting')
  Future<BaseResponse> getBackgroundBg();
  /// 获取供应商自定义分类列表
  @POST('Store/CompanyProfile/GetCategoriesProductList')
  Future<BaseListResponse<CategoryProductEntity>> getSupplierCategoriesProductList(@Field("CompanyId") String supplierId);

  /// 获取供应商品牌列表
  @POST('Store/CompanyProfile/GetHomePageBrandsList')
  Future<BaseListResponse<BrandEntity>> getSupplierBrandList(@Field("CompanyId") String supplierId);

  /// 获取供应商Banner列表
  @POST('Store/CompanyProfile/GetSliderList')
  Future<BaseListResponse<SimpleBannerEntity>> getSupplierSliderList(@Field("CompanyId") String supplierId);

  /// 获取供应商广告位列表
  @POST('Store/CompanyProfile/GetHomepageBannerList')
  Future<BaseListResponse<AdBannerEntity>> getSupplierAdBannerList(@Field("CompanyId") String supplierId);

  /// 获取供应商新品列表
  @POST('Store/CompanyProfile/GetNewArrivalProductsList')
  Future<BaseListResponse<ProductEntity>> getSupplierNewProductList(@Field("CompanyId") String supplierId);

  /// 获取供应商热销产品列表
  @POST('Store/CompanyProfile/GetSpecialOfferProductsList')
  Future<BaseListResponse<ProductEntity>> getSupplierSpecialOfferProducts(@Field("CompanyId") String supplierId);

  /// 获取供应商限时抢购产品列表
  @POST('Store/CompanyProfile/GetFeaturedStoreProductsList')
  Future<BaseListResponse<ProductEntity>> getSupplierFeaturedStoreProducts(@Field("CompanyId") String supplierId);

  /// 获取供应商资料
  @POST('Store/Company/GetCompanyProfile')
  Future<BaseResponse<SupplierProfile>> getSupplierProfile(@Field("Id") String supplierId);

  /// 更改供应商关注
  @POST('Store/CompanyFollower/AddRemoveFollow')
  Future<BaseResponse> changeSupplierFollow(@Field("CompanyId") String supplierId);

  /// 获取个性化推荐产品列表
  @POST('Store/HomePage/GetProductsListByUser')
  Future<BaseListResponse<ProductEntity>> getProductsListByUser();

  /// 获取购物车数量
  @POST('Store/ShoppingCart/GetMyShoppingCartCount')
  Future<BaseResponse<int>> getCartCount();

  /// 获取供应商分类信息
  @POST('Store/Categories/GetSingleCompanyCategories')
  Future<BaseResponse<CategoryEntity>> getSingleSupplierCategories(@Field("Id") String id, @Field("CompanyId") String supplierId);

  /// 获取供应商分类信息
  @POST('Store/Categories/GetCompanyCategories')
  Future<BaseListResponse<CategoryEntity>> getSupplierCategories(@Field("CompanyId") String supplierId);

  /// 请求报价
  @POST('Store/InquiryRequests/AddInquiryRequest')
  Future<BaseResponse> addInquiryRequest(@Body() Map<String, dynamic> map);

  /// 获取供应商分类信息
  @POST('Store/InquiryRequests/GetInquiryInfo')
  Future<BaseResponse<InquiryInfoEntity>> getInquiryInfo(@Field("CompanyId") String supplierId);

  /// 请求报价
  @POST('Store/Variations/GetProductSkuByProduct')
  Future<BaseResponse<ProductSkuEntity>> getProductSku(@Body() Map<String, dynamic> map);

  /// 获取搜索集
  @POST('Store/ColumnSet/GetSearchColumnSetByFormNo')
  Future<BaseListResponse<ColumnItemEntity>> getSearchSetByFormNo(@Field("FormNo") String formNo);

  /// 获取关注店铺列表
  @POST('/Store/CompanyFollower/GetFollowingList')
  Future<BaseListResponse<SupplierEntity>> getMyFollowCompanyList(@Body() Map<String, dynamic> map);

  /// 删除账号
  @POST('/Store/StoreUser/DeleteMyAccount')
  Future<BaseResponse> deleteMyAccount(@Field("Password") String password);

  /// 获取注册字段集
  @POST('Store/Company/GetRegistrationFields')
  Future<BaseListResponse<ColumnItemEntity>> getRegistrationFields(@Field("FormNo") String formNo);
}
