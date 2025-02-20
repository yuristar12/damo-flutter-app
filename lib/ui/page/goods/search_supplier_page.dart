import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/search_bean.dart';
import 'package:dealful_mall/model/search_set_model.dart';
import 'package:dealful_mall/model/supplier_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/search_set_filter_group.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchSupplierPage extends StatefulWidget {
  @override
  _SearchSupplierPageState createState() => _SearchSupplierPageState();
}

class _SearchSupplierPageState extends State<SearchSupplierPage> {
  final TextEditingController _keyController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  final FocusNode _focusNode = FocusNode();
  PageState pageState = PageState.loading;
  String errorMsg = "";
  final PageInfo pageInfo = PageInfo(10);
  final SearchSetModel searchSetModel = SearchSetModel([]);
  final RxString sortConditionX = RxString(AppStrings.DEFAULT);
  final RxList<SupplierEntity> supplierEntitiesX = RxList();
  String? curKeyword;

  @override
  void initState() {
    super.initState();
    var keyword = Get.parameters[AppParameters.KEYWORD];
    if (keyword != null && keyword.isNotEmpty) {
      _keyController.text = keyword;
    }
    Future.delayed(Duration.zero, () {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _searchWidget(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(color: Colors.white,
              height: 48,
              child: SearchSetFilterGroup(searchSetModel, sortConditionX, "CPSH", changeCallback: () {
                _onRefresh();
              })),
        ),
      ),
      body: _contentWidget(),
    );
  }

  Widget _searchWidget() {
    return Container(
      height: AppBar().preferredSize.height,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_20.w),
      child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_30.r),
          decoration: BoxDecoration(
            color: AppColors.COLOR_FFFFFF,
            border: Border.all(
                color: AppColors.COLOR_FFFFFF, width: AppDimens.DIMENS_1.w),
            borderRadius: BorderRadius.circular(
                ScreenUtil().setWidth(AppBar().preferredSize.height)),
          ),
          child: TextField(
            onEditingComplete: () {
              _focusNode.unfocus();
              if (curKeyword != _keyController.text) {
                _onRefresh();
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
                  if (curKeyword != _keyController.text) {
                    _onRefresh();
                  }
                },
                child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(
                      ScreenUtil().setWidth(AppBar().preferredSize.height)),
                ),
                margin: EdgeInsets.all(AppDimens.DIMENS_10.r),
                child: Icon(
                  Icons.search_outlined,
                  size: AppDimens.DIMENS_70.w,
                  color: Colors.white,
                ),
              )),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
              hintText: AppStrings.KEYWORD.translated,
              hintStyle: XTextStyle.color_999999_size_42,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          )),
    );
  }

  Widget _contentWidget() {
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: true,
      header: WaterDropMaterialHeader(
        backgroundColor: AppColors.primaryColor,
      ),
      controller: _refreshController,
      child: _showWidget(),
      onRefresh: _onRefresh,
      onLoading: acquireData,
    );
  }

  Widget _showWidget() {
    if (pageState == PageState.hasData) {
      return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
            itemBuilder: (BuildContext context, int index) {
              SupplierEntity entity = supplierEntitiesX[index];
              List<ProductEntity> productList = entity.productList ?? [];
              double cardWidth = (ScreenUtil().screenWidth -
                  AppDimens.DIMENS_30.w * 5 -
                  AppDimens.DIMENS_120.r) /
                  3;
              return GestureDetector(
                onTap: () {
                  Get.toNamed(XRouterPath.supplierDetail, parameters:{
                    AppParameters.ID: XUtils.textOf(entity.id)
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.COLOR_FFFFFF,
                    borderRadius: BorderRadius.circular(AppDimens.DIMENS_20.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedImageView(
                                AppDimens.DIMENS_120.r,
                                AppDimens.DIMENS_120.r, 
                                XUtils.textOf(entity.avatar)
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  XUtils.textOf(entity.storeName),
                                  style: XTextStyle.color_000000_size_48_bold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Container(
                                  height: 100.w,
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Text(getYear(entity.companyRegisterAt),
                                          style: XTextStyle.color_666666_size_38),
                                      Visibility(
                                        visible: entity.companyType?.isNotEmpty == true,
                                        child: Text(
                                          " · " + XUtils.textOf(entity.companyType),
                                          style: XTextStyle.color_666666_size_38
                                        )
                                      ),
                                      Visibility(
                                        visible: entity.categoryName?.isNotEmpty == true,
                                        child: Text(
                                          " · " + XUtils.textOf(entity.categoryName),
                                          style: XTextStyle.color_666666_size_38
                                        )
                                      ),
                                      SizedBox(width: AppDimens.DIMENS_30.w),
                                      Text(XUtils.textOf(entity.countryName),
                                          style: XTextStyle.color_999999_size_36),
                                      SizedBox(width: AppDimens.DIMENS_30.w),
                                      Visibility(
                                        visible: entity.market?.isNotEmpty == true,
                                        child: Text(
                                          AppStrings.EXPORT_MARKETS.translated + ": " + XUtils.textOf(entity.market),
                                          style: XTextStyle.color_999999_size_36
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          )
                        ],
                      ),
                      Visibility(
                        visible: productList.isNotEmpty,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_10.h),
                          child: SizedBox(
                            height: cardWidth,
                            child: Row(
                              children: List.generate(
                                productList.length > 3 ? 3 : productList.length,
                                (index) {
                                  ProductEntity entity = productList[index];
                                  return Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        right: index != (productList.length > 3 ? 2 : productList.length - 1) 
                                            ? AppDimens.DIMENS_30.w 
                                            : 0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          NavigatorUtil.goGoodsDetails(
                                              context, XUtils.textOf(entity.id));
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedImageView(
                                            double.infinity,
                                            double.infinity,
                                            XUtils.textOf(entity.image),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        )
                      )
                    ],
                  )
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: AppDimens.DIMENS_10.h,
            ),
            itemCount: supplierEntitiesX.length,
          );
    }
    return ViewModelStateWidget.pageStateWidget(
        pageState, errorMsg, _onRefresh);
  }

  _onRefresh() {
    pageInfo.reset();
    acquireData();
  }

  String getYear(String? registerAt) {
    if (registerAt == null) {
      return "";
    }
    if (registerAt.contains("-")) {
      return registerAt.split("-").first;
    }
    return registerAt;
  }

  acquireData() {
    curKeyword = _keyController.text;
    List<SearchBean> searchList = [];
    searchList.add(SearchBean(searchKey: "SearchKeyword",searchValue: curKeyword));
    searchList.addAll(searchSetModel.filterBeans);
    HttpUtil.fetchApiStore().getSupplierList({
      "PageIndex": pageInfo.pageIndex,
      "PageRows": pageInfo.pageSize,
      "Search": {
        "SearchList": searchList
      },
      "SortField": "CreatedAt",
      "SortType": "desc"
    }).apiCallback((data) {
      if (data is List<SupplierEntity>) {
        if (pageInfo.isFirstPage()) {
          supplierEntitiesX.assignAll(data);
          if (data.isEmpty) {
            setState(() {
              pageState = PageState.empty;
            });
          } else {
            _refreshController.refreshToIdle();
            setState(() {
              pageState = PageState.hasData;
            });
          }
          _refreshController.refreshCompleted();
        } else {
          if (data.isNotEmpty) {
            _refreshController.loadComplete();
            setState(() {
              supplierEntitiesX.addAll(data);
            });
          }
        }
        if (data.isNotEmpty) {
          pageInfo.nextPage();
        }
      }
    }, (error) {
      if (pageInfo.isFirstPage()) {
        if (_refreshController.isRefresh) {
          _refreshController.refreshFailed();
        }
        setState(() {
          errorMsg = error;
          pageState = PageState.error;
        });
      } else {
        XUtils.showToast(error);
        _refreshController.loadFailed();
      }
    });
  }
}
