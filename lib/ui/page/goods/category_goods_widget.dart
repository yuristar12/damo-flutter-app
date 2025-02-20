import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/model/product_search_model.dart';
import 'package:dealful_mall/ui/widgets/product_sort_filter_group.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/ui/widgets/waterfull_product_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/refresh_state_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/category_goods_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryGoodsWidget extends StatefulWidget {
  final String categoryId;
  final RxString categoryNameX;
  const CategoryGoodsWidget(this.categoryId, this.categoryNameX);

  @override
  _CategoryGoodsWidgetState createState() => _CategoryGoodsWidgetState();
}

class _CategoryGoodsWidgetState extends State<CategoryGoodsWidget> {
  late ProductSearchModel _searchModel;
  final RxString sortConditionX = RxString(AppStrings.DEFAULT);
  final RxString layoutModeX = RxString(AppStrings.GRID_LAYOUT);
  final CategoryGoodsViewModel _categoryGoodsViewModel = CategoryGoodsViewModel();
  final PageInfo pageInfo = PageInfo(30);
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _searchModel = ProductSearchModel(categoryId: XUtils.textOf(widget.categoryId));
    _categoryGoodsViewModel.queryCategoryGoods(_searchModel,
        sortConditionX.value, pageInfo.pageIndex, pageInfo.pageSize);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: AppDimens.DIMENS_30.w,
        right: AppDimens.DIMENS_30.w,
      ),
      child: ChangeNotifierProvider<CategoryGoodsViewModel>(
        create: (context) => _categoryGoodsViewModel,
        child:
            Consumer<CategoryGoodsViewModel>(builder: (context, model, child) {
          if (model.canLoadMore) {
            pageInfo.nextPage();
          }
          RefreshStateUtil.getInstance()
              .stopRefreshOrLoadMore(_refreshController);
          return showWidget(model);
        }),
      ),
    );
  }

  Widget showWidget(CategoryGoodsViewModel categoryGoodsViewModel) {
    if (categoryGoodsViewModel.pageState == PageState.hasData) {
      return _contentView(categoryGoodsViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        categoryGoodsViewModel, _onRefresh);
  }

  Widget _contentView(CategoryGoodsViewModel categoryGoodsViewModel) {
    double cardWidth = (ScreenUtil().screenWidth -
            AppDimens.DIMENS_30.w * 2 -
            AppDimens.DIMENS_30.w) / 2;
    return Column(children: [
      _conditionWidget(),
      Expanded(child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: _categoryGoodsViewModel.canLoadMore,
        onRefresh: () => _onRefresh(),
        onLoading: () => _onLoadMore(),
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primaryColor,
        ),
        controller: _refreshController,
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: AppDimens.DIMENS_20.h,
          itemCount: categoryGoodsViewModel.goods!.length,
          crossAxisSpacing: AppDimens.DIMENS_30.w,
          itemBuilder: (context, index) {
            return WaterfullProductWidget(categoryGoodsViewModel.goods![index],
                (value) {
              NavigatorUtil.goGoodsDetails(context, value);
            }, cardWidth);
          },
        ),
      ))
    ]);
  }

  Widget _conditionWidget() {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
      child: ProductSortFilterGroup(sortConditionX, layoutModeX, searchModel: _searchModel,
          categoryName: widget.categoryNameX.value,
          changeCallback: () {
        _onRefresh();
      }),
    );
  }

  void _onRefresh() {
    pageInfo.reset();
    _categoryGoodsViewModel.queryCategoryGoods(_searchModel,
        sortConditionX.value, pageInfo.pageIndex, pageInfo.pageSize);
  }

  void _onLoadMore() {
    _categoryGoodsViewModel.queryCategoryGoods(_searchModel,
        sortConditionX.value, pageInfo.pageIndex, pageInfo.pageSize);
  }
}
