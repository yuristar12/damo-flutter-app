import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/ad_banner_entity.dart';
import 'package:dealful_mall/model/category_product_model.dart';
import 'package:dealful_mall/model/location_entity.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_banner.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_blog.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_brand.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_goods_category.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_menu.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_products.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_recommend_menu.dart';
import 'package:dealful_mall/ui/widgets/ad_banner_widget.dart';
import 'package:dealful_mall/ui/widgets/link_flexible_space_bar.dart';
import 'package:dealful_mall/ui/widgets/select_location_dialog.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/analyze_background_color.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:dealful_mall/view_model/tab_home_view_model.dart';
import 'package:dealful_mall/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TabHomePage extends StatefulWidget {
  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage>
    with SingleTickerProviderStateMixin {
  TabHomeViewModel _model = TabHomeViewModel();
  VoidCallback? callback;
  final TextEditingController _keyController = TextEditingController();
  late RefreshController _refreshController;
  late TabController _tabController;
  var barBgColors = [Colors.white, Colors.transparent];
  ScrollController _scrollController = ScrollController();
  bool isSticky = false;
  Map<String, dynamic>? appSetting;
  String? backgroundImage;
  Color _textColor = Colors.white;  // 默认文字颜色
  bool _isDark = true;  // 是否是深色背景
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    _tabController = TabController(length: 2, vsync: this);
    _onRefresh();
    XLocalization.listen((data) {
      _onRefresh();
      if (mounted) {
        setState(() {});
      }
    });
    Future.delayed(Duration(seconds: 1), () {
      listenerScroll();
    });
  }
  void listenerScroll () {
    _scrollController.addListener(() {
        if (_scrollController.offset > 160) {
          if (!isSticky) {
            isSticky = true;
            setState(() {
              
            });
          }
        } else {
          if (isSticky) {
            isSticky = false;
            setState(() {
              
            });
          }
          
        }

      });
  }

  Future<void> _getAppSetting() async {
    HttpUtil.fetchApiStore().getBackgroundBg().then((onValue) {
      backgroundImage = onValue.data['BackgroundImage'] ?? '';
      if (backgroundImage != null && backgroundImage!.isNotEmpty) {
        AnalyzeBackgroundColor.analyze(
          imageUrl: backgroundImage!,
          onColorChanged: (color, isDark) {
            setState(() {
              _textColor = color;
              _isDark = isDark;
            });
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(    
      //   title: _buildTopWidget(),
      // ),
      body: Column(
        children: [
          isSticky ? Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: backgroundImage != null ? NetworkImage(backgroundImage!) : AssetImage('images/nav_bg.png') as ImageProvider,
                fit: BoxFit.fitWidth,
              )
            ),
            child: Column(
              children: [
                _searchWidget(true),
                  Container(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: TabRecommendMenu(_model.homeModelEntity.recommendMenu, AppColors.COLOR_FFFFFF, false, backgroundImage),
                  )
                ],
            ),
          ):SizedBox.shrink(),
          Expanded(
            child: ChangeNotifierProvider<TabHomeViewModel>(
            create: (context) => _model,
            child: Consumer<TabHomeViewModel>(builder: (context, model, child) {
              _refreshController.refreshCompleted();
              return RefreshConfiguration(
                child: SmartRefresher(
                    header: WaterDropMaterialHeader(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    controller: _refreshController,
                    onRefresh: () => _onRefresh(),
                    child: initView(model)),
              );
            }),
          ),
          )
        ],
      ),
    );
  }

  Widget buildTab(int index, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.DIMENS_10.h),
      child: Text(title,),
    );
  }

  _onRefresh() {
    _getAppSetting();
    _model.loadTabHomeData(); //获取首页数据
  }

  Widget _buildTopWidget() {
    Widget result = MultiProvider(
      providers: [ChangeNotifierProvider<UserViewModel>.value(value: Get.find()),],
      child: Consumer<UserViewModel>(
        builder: (BuildContext context, UserViewModel model, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: backgroundImage != null ? NetworkImage(backgroundImage!) : ExactAssetImage('images/nav_bg.png') as ImageProvider,
                fit: BoxFit.fill,
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top,),
                Visibility(
                    visible: true,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => BottomSheet(
                                backgroundColor: Colors.white,
                                onClosing: () {},
                                builder: (sheetContext) {
                                  return SelectLocationDialog(saveFunc: (LocationEntity? countryEntity,
                                      LocationEntity? stateEntity,
                                      LocationEntity? cityEntity) {
                                    XLocalization.saveLocation(
                                        countryEntity, stateEntity, cityEntity);
                                  },
                                );
                              }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 66.h,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 30.r, bottom: 4.h),
                            padding: EdgeInsets.only(right: 10.r, left: 16.r),
                            decoration: BoxDecoration(
                              color: Color(0xFFD33400),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: AppDimens.DIMENS_30.r),
                                  child: Image.asset('images/icon_location.jpg', width: 20,),
                                ),
                                Text(
                                  XUtils.textOf(XLocalization.obtainLocationStr(),
                                    defValue: AppStrings.LOCATION.translated, orEmpty: true),
                                  style: TextStyle(
                                    color: AppColors.NAV_FONT_COLOR,
                                    fontSize: 42.sp,
                                  ),
                                ),
                                SizedBox(width: 20.h,)
                              ],
                            ),
                          ),
                          model.carVehicleSelection != null && model.carVehicleSelection == true ? Container(
                            height: 66.h,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(right: 30.r, left: 16.r),
                            margin: EdgeInsets.only(right: 30.h),
                            decoration: BoxDecoration(
                              color: Color(0xFFD33400),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: GestureDetector(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('images/icon_car.jpg', width: 20,),
                                  SizedBox(width: 12.h,),
                                  Obx(() => Text(
                                    _model.carmodelStrX.value,
                                    style: TextStyle(color: AppColors.NAV_FONT_COLOR),
                                  ))
                                ],
                              ),
                              onTap: () {
                                Get.toNamed(XRouterPath.yourVehicle);
                              },
                            ),
                          ):SizedBox.shrink()
                        ],
                      ),
                    )),
                model.supplierSearch != null && model.supplierSearch == true ? SizedBox(
                  height: AppDimens.DIMENS_90.h,
                  child: Row(
                    children: [
                      TabBar(
                        key: UniqueKey(),
                        isScrollable: true,
                        dividerColor: Colors.transparent,
                        controller: _tabController,
                        indicatorColor: _textColor,
                        labelColor: _textColor,
                        unselectedLabelColor: _textColor,
                        tabAlignment: TabAlignment.start,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                        tabs: [
                          buildTab(0, AppStrings.PRODUCT.translated),
                          buildTab(1, AppStrings.VENDOR.translated),
                        ],
                        onTap: (index) {
                          setState(() {
                            _tabController.index = index;
                          });
                        },
                      ),
                      Spacer(),
                    ],
                  )
                ):SizedBox.shrink(),
                _searchWidget(true),
                TabRecommendMenu(_model.homeModelEntity.recommendMenu, AppColors.COLOR_FFFFFF, false, backgroundImage),
                Container(
                        margin: EdgeInsets.only(top: 30.h),
                        // padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
                        child: TabHomeMenu(_model.homeModelEntity.menu),
                      )
              ])
            );
          }
        ));
      return result;
  }


  Widget _searchWidget(bool expanded) {
    return Container(
      height: AppBar().preferredSize.height,
      padding: EdgeInsets.only(left: AppDimens.DIMENS_30.r, right: AppDimens.DIMENS_30.r, top: AppDimens.DIMENS_20.r, bottom: AppDimens.DIMENS_30.r),
      alignment: Alignment.center,
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: expanded ? AppColors.COLOR_FFFFFF : AppColors.COLOR_F6F6F6,
            border: Border.all(
                color: expanded ? AppColors.COLOR_FFFFFF : Colors.black,
                width: AppDimens.DIMENS_3.r),
            borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
          ),
          child: TextField(
            onSubmitted: (value) {
              toSearch();
            },
            controller: _keyController,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: AppColors.COLOR_333333,
                fontSize: AppDimens.DIMENS_42.sp),
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: toSearch,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                  ),
                  margin: EdgeInsets.all(AppDimens.DIMENS_10.r),
                  child: Container(
                    width: 20.w,
                    alignment: Alignment.center,
                    child: Image.asset('images/icon_search.jpg', width: AppDimens.DIMENS_50.w,),
                  )
                  
                  // Icon(
                  //   Icons.search_outlined,
                  //   size: AppDimens.DIMENS_70.w,
                  //   color: Colors.white,
                  // ),
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
              hintText: AppStrings.KEYWORD.translated,
              hintStyle: XTextStyle.color_999999_size_42,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          )),
    );
  }

  void toSearch() {
    if (_tabController.index == 0) {
      NavigatorUtil.goSearchGoods(
        context,
        keyword: _keyController.text,
      );
    } else {
      Get.toNamed(XRouterPath.searchSupplier, parameters: {
        AppParameters.KEYWORD: _keyController.text,
      });
    }
  }

  Widget initView(TabHomeViewModel tabHomeViewModel) {
    if (tabHomeViewModel.pageState == PageState.hasData) {
      return _dataView(tabHomeViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        tabHomeViewModel, _onRefresh);
  }

  //数据显示
  Widget _dataView(TabHomeViewModel tabHomeViewModel) {
    List<AdBannerEntity> sourceEntities = tabHomeViewModel.adBannerEntities;
    return ListView(
        controller: _scrollController,
        padding: EdgeInsets.only(
          bottom: AppDimens.DIMENS_30.h,
        ),
        physics: ClampingScrollPhysics(),
        children:[ Column(
          children: [
            isSticky ?SizedBox.shrink():_buildTopWidget(),
            // Stack(
            //   clipBehavior: Clip.none,
            //   children: [
            //     isSticky ?SizedBox.shrink():_buildTopWidget(),
                
            //   ],
            // ),
            // SizedBox(height: AppDimens.DIMENS_10.h,),
            Container(
                  child: TabHomeBanner(_model.homeModelEntity.banner),
            ),
            TabHomeGoodsCategory(_model.homeModelEntity.channel),
            AdBannerWidget.fromList(
                sourceEntities, AppStrings.FEATURED_CATEGORY),
            TabHomeProducts(AppStrings.SPECIAL_OFFER_PRODUCTS.translated,
                _model.homeModelEntity.specialOfferProducts ?? [], uiType: 1,
                onTapTitle: () {
              NavigatorUtil.goSearchGoods(context,
                  type: AppStrings.SPECIAL_OFFER_PRODUCTS,
                  title: AppStrings.SPECIAL_OFFER_PRODUCTS.translated);
            }),
            AdBannerWidget.fromList(
                sourceEntities, AppStrings.SPECIAL_OFFER_PRODUCTS),
            TabHomeProducts(
              AppStrings.FEATURED_STORE_PRODUCTS.translated,
              _model.homeModelEntity.featuredStoreProducts ?? [],
              uiType: 1,
              onTapTitle: () {
                NavigatorUtil.goSearchGoods(context,
                    type: AppStrings.FEATURED_STORE_PRODUCTS,
                    title: AppStrings.FEATURED_STORE_PRODUCTS.translated);
              },
            ),
            AdBannerWidget.fromList(
                sourceEntities, AppStrings.FEATURED_STORE_PRODUCTS),
            TabHomeProducts(
              AppStrings.NEW_ARRIVAL_PRODUCTS.translated,
              _model.homeModelEntity.newArrivalProducts ?? [],
              uiType: 1,
              onTapTitle: () {
                NavigatorUtil.goSearchGoods(context);
              },
            ),
            AdBannerWidget.fromList(
                sourceEntities, AppStrings.NEW_ARRIVAL_PRODUCTS),
            ListView.separated(
                itemBuilder: (_, index) {
                  CategoryProductEntity productModel =
                      _model.categoryProductModels[index];
                  return TabHomeProducts(
                    XUtils.textOf(productModel.categoryName),
                    productModel.storeProductsVO ?? [],
                    uiType: 1,
                    onTapTitle: () {
                      NavigatorUtil.goCategoryProductListPage(
                          productModel.categoryId, productModel.categoryName);
                    },
                  );
                },
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (_, index) => SizedBox.shrink(),
                itemCount: _model.categoryProductModels.length),
            TabHomeBrand(AppStrings.SHOP_BY_BRAND.translated, _model.brandList),
            TabHomeBlog(
                AppStrings.LATEST_BLOG_POSTS.translated, _model.blogList),
          ],
        )]);
  }
}
