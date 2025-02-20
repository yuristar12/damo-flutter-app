import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/event/tab_select_event.dart';
import 'package:dealful_mall/model/home_entity.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/ui/page/goods/search_goods_page.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_recommend_menu.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/ui/widgets/loading_dialog.dart';
import 'package:dealful_mall/ui/widgets/product_sort_filter_group.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/ui/widgets/waterfull_product_widget.dart';
import 'package:dealful_mall/ui/widgets/x_text.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/refresh_state_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:dealful_mall/view_model/search_goods_view_model.dart';
import 'package:dealful_mall/view_model/tab_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:dealful_mall/utils/analyze_background_color.dart';

class TabBestGoodsCategoryPage extends StatefulWidget {
  final String? backgroundImage;
  const TabBestGoodsCategoryPage({this.backgroundImage});

  @override
  State<TabBestGoodsCategoryPage> createState() => _TabBestGoodsCategoryPageState();
}

class _TabBestGoodsCategoryPageState extends State<TabBestGoodsCategoryPage> {
  final SearchGoodsViewModel _searchGoodsViewModel = SearchGoodsViewModel();
  String? categoryName;
  final RxString sortConditionX = RxString(AppStrings.DEFAULT);
  final RxString layoutModeX = RxString(AppStrings.GRID_LAYOUT);
  final RefreshController _refreshController = RefreshController();
  var _pageIndex = 1;
  int _pageSize = 20;
  TabHomeViewModel _model = TabHomeViewModel();
  ScrollController _controller = ScrollController();
  bool isSticky = false;
  final TextEditingController _keyController = TextEditingController();
  String title = '';

  List<HomeModelRecommend> menuData = [];
  List<HomeModelRecommend> bestMenuData = [];
  List<HomeModelRecommend> drawMenuData = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
      final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey();
  final GlobalKey _menuKey =  GlobalKey();
  int current = 0;
  double _menuHeight = 0;
  String? backgroundImage;
  Color _textColor = Colors.white;  // 默认文字颜色
  bool _isDark = true;  // 是否是深色背景

  @override
  void initState() {
    super.initState();
    current = Get.arguments['current'];
    menuData = Get.arguments['menuData'];
    backgroundImage = Get.arguments['backgroundImage'];
    
    if (backgroundImage != null) {
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
    // _scrollController!.animateTo(current*20, duration: Duration(microseconds: 1000), curve: Curves.bounceIn);

    getBestMenu();
    getDrawMenu();
    Future.delayed(Duration(seconds: 1), () {
      itemScrollController.scrollTo(
      index: current,
      duration: const Duration(milliseconds: 200),
    );
      _controller.addListener(() {
        print('Scroll offset: ${_controller.offset}');
        // print('Scroll offset: ${_controller.offset > 370}');
        if (_controller.position.pixels ==
            _controller.position.maxScrollExtent) {
          /// 触发上拉加载更多机制
          _onLoadMore();
        }
        if (_controller.offset > _menuHeight) {
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
    });
    
    Future.delayed(Duration.zero, () {
      _sort();
    });
    layoutModeX.listen((onData) {
      if (mounted) {
        setState(() {});
      }
    });
    
  }

  Future<void> getBestMenu ({String menuId = ''}) async {
    isSticky = false;
        // _searchGoodsViewModel.
        _searchGoodsViewModel.setSearchProp(
        menuId.isNotEmpty ? menuId : menuData[current].Id,
        '',
        'title');
        // _onRefresh();
     HttpUtil.fetchApiStore().getRecommendMenu({
       "ParentId": menuId.isNotEmpty ? menuId : menuData[current].Id,
      "recursionNum":-1,
      "IsFeatured" : 1,
      "MergeDisplay" : true
    }).then((onValue) {
      print('onValueonValue${onValue.data}');
      bestMenuData = onValue.data!;
      // if (bestMenuData.length == 0) isSticky = true;
   
      setState(() {
        
      });
     
    });
  }

  //获取垂直分类
  Future<void> getDrawMenu () async {
    HttpUtil.fetchApiStore().getRecommendMenu({
      "ParentId": menuData[current].Id,
      "recursionNum":-1
      }).then((onValue) {
        print('垂直分类${onValue.data}');
        drawMenuData = onValue.data!;
        setState(() {
          
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _searchGoodsViewModel,
        child: Selector<SearchGoodsViewModel, int>(
          builder: (context, provider, child) {
            if (_searchGoodsViewModel.isLoadMore) {
              _pageIndex++;
            }
            RefreshStateUtil.getInstance()
                .stopRefreshOrLoadMore(_refreshController);
            return Scaffold(
              key: _scaffoldKey,
              body: Container(
                child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                        decoration:  BoxDecoration(
                          image: DecorationImage(
                            image: backgroundImage != null ? NetworkImage(backgroundImage!) : ExactAssetImage('images/nav_bg.png') as ImageProvider,
                            
                            // NetworkImage('http://dingfoxweb.oss-cn-hangzhou.aliyuncs.com/1353057/DOC/2024/12/1874040229181112320.jpg'),
                            fit: BoxFit.fitWidth,
                          )
                        ),
                        child: Column(
                          children: [
                            _searchWidget(),
                            tabMenu(),
                          ],
                        ),
                      ),
                     
                      isSticky ? _conditionWidget():SizedBox.shrink(),
                      Expanded(
                        child: ListView(
                          controller: _controller,
                          padding: EdgeInsets.only(top: 0),
                          children: [
                            // bestWidget(context),
                            bestMenuData.isNotEmpty ? bestWidget(context):SizedBox.shrink(),
                            // isSticky ? SizedBox.shrink():_conditionWidget(),
                            _searchGoodsViewModel.goods.isNotEmpty ?  _showWidget(_searchGoodsViewModel):Container(height: 500,child: EmptyDataView(),)
                            // Expanded(child: )
                          ],
                        )
                      )
                    ],
                  ),
              ),
              endDrawer: Drawer(
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: Color.fromRGBO(245, 245, 245, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(XUtils.textOf(menuData[current].Name), style: TextStyle(color: AppColors.primaryColor),),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: drawMenuData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.COLOR_FFFFFF,
                                borderRadius: BorderRadius.circular(20.w)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              margin: EdgeInsets.only(bottom: 40.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _scaffoldKey.currentState!.closeEndDrawer();
                                      getBestMenu(menuId: drawMenuData[index].Id.toString());
                                    },
                                    child: Text(XUtils.textOf(drawMenuData[index].Name!)),
                                  ),
                                  SizedBox(height: 10.h,),
                                  GridView.builder(
                                    padding: EdgeInsets.only(
                                      right: 20.w,
                                      top: 0,
                                      bottom: 0
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    //禁止滚动
                                    shrinkWrap: true,
                                    itemCount: drawMenuData[index].categoriesVOList?.length ?? 0,
                                    itemBuilder: (BuildContext context, int idx) {
                                      //  return _getGridViewItem(categoryList[index]);
                                      if (drawMenuData[index].categoriesVOList == null) {
                                        return SizedBox.shrink();
                                      }
                                      return Container(
                                        child: InkWell(
                                          onTap: () {
                                            _scaffoldKey.currentState!.closeEndDrawer();
                                            getBestMenu(menuId: drawMenuData[index].categoriesVOList![idx]['Id'].toString());
                                            
                                            // Get.toNamed(XRouterPath.searchGoods, parameters: {
                                            //       AppParameters.KEYWORD: '',
                                            //       AppParameters.BRAND_ID: '',
                                            //       AppParameters.CATEGORY_ID: drawMenuData[index].categoriesVOList![idx]['Id'].toString(),
                                            //       AppParameters.CATEGORY_NAME: drawMenuData[index].categoriesVOList![idx]['Name'] ?? '',
                                            //       AppParameters.TYPE: '',
                                            //       AppParameters.TITLE: '',
                                            //     })
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(AppDimens.DIMENS_6.r),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(3),
                                                  child: CachedImageView(ScreenUtil().setWidth(AppDimens.DIMENS_140),
                                                    ScreenUtil().setWidth(AppDimens.DIMENS_140), drawMenuData[index].categoriesVOList![idx]['Image']),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: AppDimens.DIMENS_10.h),
                                                    child: Text(
                                                      XUtils.textOf( drawMenuData[index].categoriesVOList![idx]['Name']),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppColors.COLOR_333333,
                                                          height: 1,
                                                          fontSize: ScreenUtil().setSp(AppDimens.DIMENS_38)),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7,
                                      //单个子Widget的水平最大宽度
                                      crossAxisCount: 4,
                                      //水平单个子Widget之间间距
                                      mainAxisSpacing: 0,
                                      //垂直单个子Widget之间间距
                                      crossAxisSpacing: ScreenUtil().setWidth(AppDimens.DIMENS_40),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          selector: (context, provider) => provider.lastUpdateRank,
        ));

  }

  Widget tabMenu () {
    return Container(
            height: 60.h,
            margin: EdgeInsets.only(bottom: 26.h),
            // color: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back(result: 0);
                  },
                  child: Text(XUtils.textOf(AppStrings.For_You_index.translated), style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Container(

                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      scrollDirection: Axis.horizontal,
                      itemCount: menuData.length > 0 ? menuData.length:0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            current = index;
                            _searchGoodsViewModel.clearGoods();
                            itemScrollController.scrollTo(
                              index: current,
                              duration: const Duration(milliseconds: 100),);
                          getBestMenu();
                          getDrawMenu();
                          _pageIndex = 1;
                          _onRefresh();
                            // tabSelectBus.fire(TabSelectEvent(1, innerTabIndex: 0, menuIndex: index));
                          },
                          child: Container(
                            height: 60.h,
                            margin: EdgeInsets.only(right: 40.h),
                            padding: EdgeInsets.symmetric(horizontal: 30.h),
                            alignment: Alignment.center,
                            decoration: current == index ? BoxDecoration(
                              borderRadius: BorderRadius.circular(30.h),
                              border: Border.all(color: _textColor, width: 4.h)
                            ):BoxDecoration(),
                            child: Text(
                                textAlign: TextAlign.center,
                                  XUtils.textOf('${menuData[index].Name}'),
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _textColor
                                    ),
                          ),
                          ),
                        );
                      }
                    ),
                  )
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    tabSelectBus.fire(TabSelectEvent(1, innerTabIndex: 0,));
                  },
                  child: Image.asset(_isDark ? 'images/icon_menu_w.png' : 'images/icon_menu_b.png', width: 20,),
                )
              ],
            ),
    );
  } 

  Widget buttonMore () {
    return Container(
      child: InkWell(
        onTap: () => {
           _scaffoldKey.currentState!.openEndDrawer()
        },
        child: Column(
          children: <Widget>[
            Container(
              width: 122.h,
              height: 122.h,
              margin: EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(61.h),
                color: Color(0xFFE5E6E9),
              ),
              alignment: Alignment.center,
              child: Image.asset('images/icon_more.png',  width: AppDimens.DIMENS_140, height: AppDimens.DIMENS_20,),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: AppDimens.DIMENS_10.h),
                  child: Text(
                     XUtils.textOf(AppStrings.MORE.translated),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.COLOR_333333,
                        height: 1,
                        fontSize: ScreenUtil().setSp(AppDimens.DIMENS_38)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget bestWidget (BuildContext parentContext) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Future.delayed(Duration(microseconds: 100), () async {
         _menuHeight = _menuKey.currentContext!.findRenderObject()!.semanticBounds.size.height;
      });
        return Container(
          key: _menuKey,
          margin: EdgeInsets.only(top: 30.h),
          child: GridView.builder(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 0,
              bottom: 0
            ),
            physics: NeverScrollableScrollPhysics(),
            //禁止滚动
            shrinkWrap: true,
            itemCount: bestMenuData.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < bestMenuData.length) {
                return _getGridViewItem(parentContext, bestMenuData[index], index);
                
              } else return buttonMore();
              
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              //单个子Widget的水平最大宽度
              crossAxisCount: 5,
              //水平单个子Widget之间间距
              mainAxisSpacing: 0,
              //垂直单个子Widget之间间距
              crossAxisSpacing: ScreenUtil().setWidth(AppDimens.DIMENS_40),
            ),
          ),
        );
      }
    );
  }

  Widget _getGridViewItem(BuildContext context, HomeModelRecommend channel, int index, { bool isDraw = false  }) {
    return Container(
      child: InkWell(
        onTap: () => {
          Get.toNamed(XRouterPath.searchGoods, parameters: {
            AppParameters.KEYWORD: '',
            AppParameters.BRAND_ID: '',
            AppParameters.CATEGORY_ID: channel!.Id.toString(),
            AppParameters.CATEGORY_NAME: channel.Name ?? '',
            AppParameters.TYPE: '',
            AppParameters.TITLE: '',
          })
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(AppDimens.DIMENS_6.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: CachedImageView(ScreenUtil().setWidth(AppDimens.DIMENS_140),
                  ScreenUtil().setWidth(AppDimens.DIMENS_140), channel!.ImageUrl),
              ),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: AppDimens.DIMENS_10.h),
                  child: Text(
                     XUtils.textOf( channel.Name),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.COLOR_333333,
                        height: 1,
                        fontSize: ScreenUtil().setSp(AppDimens.DIMENS_38)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _contentWidget() {
    return SmartRefresher(
      enablePullUp: _searchGoodsViewModel.isLoadMore,
      enablePullDown: true,
      header: WaterDropMaterialHeader(
        backgroundColor: AppColors.primaryColor,
      ),
      controller: _refreshController,
      child: _showWidget(_searchGoodsViewModel),
      onRefresh: _onRefresh,
      onLoading: _onLoadMore,
    );
  }

  Widget _goodsWidget() {
    if (layoutModeX.value == AppStrings.GRID_LAYOUT) {
      double cardWidth = (ScreenUtil().screenWidth -
              AppDimens.DIMENS_30.w * 2 -
              AppDimens.DIMENS_30.w) /
          2;
      return MasonryGridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.all(AppDimens.DIMENS_30.w),
        crossAxisCount: 2,
        primary: false,
        mainAxisSpacing: AppDimens.DIMENS_20.h,
        itemCount: _searchGoodsViewModel.goods.length,
        crossAxisSpacing: AppDimens.DIMENS_30.w,
        itemBuilder: (context, index) {
          return WaterfullProductWidget(_searchGoodsViewModel.goods[index],
              (value) {
            NavigatorUtil.goGoodsDetails(context, value);
          }, cardWidth);
        },
      );
    } else {
      double imageWidth = ScreenUtil().screenWidth/3.8;
      return ColoredBox(
          color: Colors.white,
          child: ListView.separated(
            shrinkWrap: true,
            primary: false,
              padding: EdgeInsets.only(
                  right: AppDimens.DIMENS_30.w,
                  left: AppDimens.DIMENS_30.w,
                  top: AppDimens.DIMENS_10.h),
              itemBuilder: (context, index) =>
                  _goodItem(_searchGoodsViewModel.goods[index], imageWidth),
              separatorBuilder: (_, index) => SizedBox(
                    height: AppDimens.DIMENS_20.h,
                  ),
              itemCount: _searchGoodsViewModel.goods.length));
    }
  }

  Widget _goodItem(ProductEntity productEntity, double imageSize) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.goGoodsDetails(context, XUtils.textOf(productEntity.id));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedImageView(
                imageSize,
                imageSize,
                XUtils.textOf(productEntity.image),
                fit: BoxFit.fill,
              )),
          SizedBox(
            width: AppDimens.DIMENS_20.w,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: AppDimens.DIMENS_10.r,
                ),
                child: Text(
                    Characters(XUtils.textOf(productEntity.name))
                        .join('\u{200B}'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.COLOR_333333,
                        height: 1,
                        fontSize: AppDimens.DIMENS_42.sp)),
              ),
              Visibility(
                  visible: productEntity.username?.isNotEmpty == true,
                  child: Padding(
                    padding: EdgeInsets.only(top: AppDimens.DIMENS_10.r),
                    child: Text(XUtils.textOf(productEntity.username),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: XTextStyle.color_333333_size_38),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: AppDimens.DIMENS_10.r),
                  child: Row(
                    children: [
                      Text(XUtils.textOf(productEntity.priceDiscounted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: XTextStyle.color_primary_size_48_bold),
                      Visibility(
                          visible: productEntity.price?.isNotEmpty == true,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(left: AppDimens.DIMENS_10.r),
                              child: Text(XUtils.textOf(productEntity.price),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: XTextStyle
                                      .color_999999_size_36_lineThrough)))
                    ],
                  )),
            ],
          ))
        ],
      ),
    );
  }

  Widget _showWidget(SearchGoodsViewModel searchGoodsViewModel) {
    print('searchGoodsViewModel.pageState ${searchGoodsViewModel.pageState }');
    if (searchGoodsViewModel.pageState == PageState.hasData) {
      return _goodsWidget();
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        searchGoodsViewModel, _onRefresh);
  }

  void toSearch() {
    NavigatorUtil.goSearchGoods(
      context,
      keyword: _keyController.text,
    );
  }

  Widget _searchWidget() {
    return Container(
      height: AppBar().preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back),
          ),
          Visibility(
              visible: title.isNotEmpty,
              child: Expanded(
                  child: XText(title,
                      color: Colors.black, fontSize: AppDimens.DIMENS_54.sp))),
          Expanded(
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_30.r),
                  decoration: BoxDecoration(
                    color: AppColors.COLOR_FFFFFF,
                    border: Border.all(
                        color: AppColors.COLOR_FFFFFF,
                        width: AppDimens.DIMENS_1.w),
                    borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(AppBar().preferredSize.height)),
                  ),
                  child: TextField(
                    onEditingComplete: () {
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
                          onTap: () {
                            if (_keyController.text !=
                                _searchGoodsViewModel.getCurKeyword()) {
                              toSearch();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(ScreenUtil()
                                  .setWidth(AppBar().preferredSize.height)),
                            ),
                            margin: EdgeInsets.all(AppDimens.DIMENS_10.r),
                            child: Container(
                              width: 20.w,
                              alignment: Alignment.center,
                              child: Image.asset('images/icon_search.jpg', width: AppDimens.DIMENS_50.w,),
                            ),
                          )),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: AppDimens.DIMENS_30.w),
                      hintText: AppStrings.KEYWORD.translated,
                      hintStyle: XTextStyle.color_999999_size_42,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ))),
        ],
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoadingDialog(
            title: AppStrings.LOGINING,
            textColor: AppColors.COLOR_999999,
            titleSize: AppDimens.DIMENS_42,
            indicatorRadius: AppDimens.DIMENS_60,
          );
        });
  }

   _onRefresh() {
    // _pageIndex = 1;
    _searchGoodsViewModel.pageIndex = 1;
    _searchGoodsViewModel.searchGoods( _pageSize, sortConditionX.value);
  }

  _onLoadMore() async {
    _searchGoodsViewModel.searchGoods( _pageSize, sortConditionX.value);
  }

  _sort() {
    _pageIndex = 1;
    _showDialog(context);
    _searchGoodsViewModel
        .searchGoods(_pageSize, sortConditionX.value)
        .then((value) => Navigator.pop(context));
  }

  Widget _conditionWidget() {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
      child: ProductSortFilterGroup(sortConditionX, layoutModeX,
          searchModel: _searchGoodsViewModel.searchModel,
          categoryName: categoryName, changeCallback: () {
        _onRefresh();
      }),
    );
  }
}