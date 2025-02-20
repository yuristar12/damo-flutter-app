import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/loading_dialog.dart';
import 'package:dealful_mall/ui/widgets/product_sort_filter_group.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/ui/widgets/waterfull_product_widget.dart';
import 'package:dealful_mall/ui/widgets/x_text.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/refresh_state_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:dealful_mall/view_model/search_goods_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchGoodsPage extends StatefulWidget {
  @override
  _SearchGoodsPageState createState() => _SearchGoodsPageState();
}

class _SearchGoodsPageState extends State<SearchGoodsPage> {
  final TextEditingController _keyController = TextEditingController();
  final SearchGoodsViewModel _searchGoodsViewModel = SearchGoodsViewModel();
  final RefreshController _refreshController = RefreshController();
  final FocusNode _focusNode = FocusNode();
  final RxString sortConditionX = RxString(AppStrings.DEFAULT);
  final RxString layoutModeX = RxString(AppStrings.GRID_LAYOUT);
  late String supplierId;
  String? categoryName;
  var _pageSize = 20;
  var title = "";

  @override
  void initState() {
    super.initState();
    _searchGoodsViewModel.pageState = PageState.empty;
    var keyword = Get.parameters[AppParameters.KEYWORD];
    supplierId = XUtils.textOf(Get.parameters[AppParameters.SUPPLIER_ID]);
    if (keyword != null && keyword.isNotEmpty) {
      _keyController.text = keyword;
    }
    _searchGoodsViewModel.setSearchProp(
        Get.parameters[AppParameters.CATEGORY_ID],
        Get.parameters[AppParameters.BRAND_ID],
        Get.parameters[AppParameters.TYPE],
        supplierId: supplierId
    );
    categoryName = Get.parameters[AppParameters.CATEGORY_NAME];
    title = Get.parameters[AppParameters.TITLE] ?? title;
    Future.delayed(Duration.zero, () {
      _sort();
    });
    layoutModeX.listen((onData) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _searchGoodsViewModel,
        child: Selector<SearchGoodsViewModel, int>(
          builder: (context, provider, child) {
            RefreshStateUtil.getInstance()
                .stopRefreshOrLoadMore(_refreshController);
            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                leading: SizedBox.shrink(),
                leadingWidth: 0,
                titleSpacing: 0,
                title: _searchWidget(),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child: _conditionWidget(),
                ),
              ),
              backgroundColor: Colors.white,
              body: _contentWidget(),
            );
          },
          selector: (context, provider) => provider.lastUpdateRank,
        ));
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
                      if (_keyController.text !=
                          _searchGoodsViewModel.getCurKeyword()) {
                        _sort();
                      }
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
                              _sort();
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

  Widget _conditionWidget() {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      child: ProductSortFilterGroup(sortConditionX, layoutModeX,
          searchModel: _searchGoodsViewModel.searchModel,
          categoryName: categoryName, changeCallback: () {
        _onRefresh();
      }),
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

  Widget _showWidget(SearchGoodsViewModel searchGoodsViewModel) {
    if (searchGoodsViewModel.pageState == PageState.hasData) {
      return _goodsWidget();
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        searchGoodsViewModel, _onRefresh);
  }

  Widget _goodsWidget() {
    if (layoutModeX.value == AppStrings.GRID_LAYOUT) {
      double cardWidth = (ScreenUtil().screenWidth -
              AppDimens.DIMENS_30.w * 2 -
              AppDimens.DIMENS_30.w) /
          2;
      return MasonryGridView.count(
        padding: EdgeInsets.all(AppDimens.DIMENS_30.w),
        crossAxisCount: 2,
        mainAxisSpacing: AppDimens.DIMENS_20.h,
        itemCount: _searchGoodsViewModel.goods.length,
        crossAxisSpacing: AppDimens.DIMENS_30.w,
        itemBuilder: (context, index) {
          return WaterfullProductWidget(_searchGoodsViewModel.goods[index],
              (value) {
            NavigatorUtil.goGoodsDetails(context, value);
          }, cardWidth, isWhite: true,);
        },
      );
    } else {
      double imageWidth = ScreenUtil().screenWidth/3.8;
      return ListView.separated(
              padding: EdgeInsets.only(
                  right: AppDimens.DIMENS_30.w,
                  left: AppDimens.DIMENS_30.w,
                  top: AppDimens.DIMENS_10.h,
                bottom: AppDimens.DIMENS_10.h
              ),
              itemBuilder: (context, index) =>
                  _goodItem(_searchGoodsViewModel.goods[index], imageWidth),
              separatorBuilder: (_, index) => SizedBox(
                    height: AppDimens.DIMENS_20.h,
                  ),
              itemCount: _searchGoodsViewModel.goods.length);
    }
  }

  _onRefresh() {
    _searchGoodsViewModel.pageIndex = 1;
    _searchGoodsViewModel.searchGoods(
        _pageSize, sortConditionX.value);
  }

  _onLoadMore() async {
    _searchGoodsViewModel.searchGoods(
         _pageSize, sortConditionX.value);
  }

  _sort() {
    _focusNode.unfocus();
    _searchGoodsViewModel.pageIndex = 1;
    _showDialog(context);
    _searchGoodsViewModel.setKeyword(_keyController.text);
    _searchGoodsViewModel
        .searchGoods(_pageSize, sortConditionX.value)
        .then((value) => Navigator.pop(context));
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
}
