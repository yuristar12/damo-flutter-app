import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/store_entity.dart';
import 'package:dealful_mall/model/supplier_entity.dart';
import 'package:dealful_mall/ui/page/home/tab_mine_page.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/ui/widgets/loading_dialog.dart';
import 'package:dealful_mall/ui/widgets/network_error.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/api_store.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/category_goods_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FollowStorePage extends StatefulWidget {
  const FollowStorePage({super.key});

  @override
  State<FollowStorePage> createState() => _FollowStorePageState();
}

class _FollowStorePageState extends State<FollowStorePage> {
  PageState pageState = PageState.loading;
  int _pageIndex = 1;
  final RefreshController _refreshController = RefreshController();

  List<StoreEntity> _storeList = [];    
  final RxList<SupplierEntity> supplierEntitiesX = RxList();
  final PageInfo pageInfo = PageInfo(10);
  @override
  void initState() {
    super.initState();
    getMyFollowCompanyList();
  }

  Future<void> getMyFollowCompanyList() async {
    HttpUtil.fetchApiStore().getMyFollowCompanyList({
      "PageIndex": pageInfo.pageIndex,
      "PageSize": pageInfo.pageSize,
    }).apiCallback((data) {
      print('data: $data');
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
    });
  }

  Future<void> _onRefresh() async {
    pageInfo.reset();
    await getMyFollowCompanyList();
    _refreshController.refreshCompleted();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(XUtils.textOf(AppStrings.FOLLOWING.translated)),
        centerTitle: true,
      ),
      body: SmartRefresher(
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primaryColor,
        ),
        controller: _refreshController,
        onRefresh: () => _onRefresh(),
        child: showView()
      ),
    );
  }

  Widget showView () {
    if (pageState == PageState.loading) return LoadingDialog();
    else if (pageState == PageState.error) return  NetWorkErrorView('', callback: () {});
    else {
      if (supplierEntitiesX.isNotEmpty) return followList();
      if (supplierEntitiesX.isEmpty) return EmptyDataView();
    }
    return SizedBox.shrink();
  }

  Widget followList () {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
      itemBuilder: (BuildContext context, int index) {
        SupplierEntity entity = supplierEntitiesX[index];
        List<ProductEntity> productList = entity.productList ?? [];
        double cardWidth = (ScreenUtil().screenWidth -
                AppDimens.DIMENS_30.w * 5 -
                AppDimens.DIMENS_120.r) /
            3;
        return Slidable(
          key: ValueKey(entity.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              CustomSlidableAction(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onPressed: (context) => _onUnfollow(entity),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      XUtils.textOf(AppStrings.UNFOLLOW.translated),
                      style: TextStyle(fontSize: 36.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Get.toNamed(XRouterPath.supplierDetail,
                  parameters: {AppParameters.ID: XUtils.textOf(entity.id)})!.then((value) {
                if (value == true) {
                  pageInfo.reset();
                  getMyFollowCompanyList();
                }
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.COLOR_FFFFFF,
                borderRadius: BorderRadius.circular(AppDimens.DIMENS_20.r),
              ),
              child: Column(children: [
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedImageView(AppDimens.DIMENS_120.r,
                            AppDimens.DIMENS_120.r, XUtils.textOf(entity.avatar))),
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
                                      style: XTextStyle.color_666666_size_38)),
                              Visibility(
                                  visible: entity.categoryName?.isNotEmpty == true,
                                  child: Text(
                                      " · " + XUtils.textOf(entity.categoryName),
                                      style: XTextStyle.color_666666_size_38)),
                              SizedBox(width: AppDimens.DIMENS_30.w,),
                               Text(XUtils.textOf(entity.countryName),
                                      style: XTextStyle.color_999999_size_36),
                                  SizedBox(
                                    width: AppDimens.DIMENS_30.w,
                                  ),
                                  Visibility(
                                      visible: entity.market?.isNotEmpty == true,
                                      child: Text(AppStrings.EXPORT_MARKETS.translated+": " + XUtils.textOf(entity.market),
                                          style: XTextStyle.color_999999_size_36)),
                            ],
                          ),
                          ),
                        ],
                      ))
                ],
              ),
              Visibility(
                              visible: productList.isNotEmpty,
                              child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: AppDimens.DIMENS_10.h),
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
                                  ))
                                  )
              ],)
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: AppDimens.DIMENS_10.h),
      itemCount: supplierEntitiesX.length,
    );
  }

  Widget _buildStoreItem(StoreEntity store) {
    print('store avatar: ${store.avatar}');
    print('store storeName: ${store.storeName}');
    print('store businessType: ${store.businessType}');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 店铺图片
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              topRight: Radius.circular(8.r),
            ),
            child: CachedImageView(
              double.infinity,
              300.h,
              store.avatar,
              fit: BoxFit.fitHeight,
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 店铺名称
                Text(
                  store.storeName ?? '',
                  style: TextStyle(
                    fontSize: 46.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 4.h),
                
                // 店铺描述
                if (store.businessType != null)
                  Text(
                    store.businessType!,
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
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

  Future<void> _onUnfollow(SupplierEntity entity) async {
    HttpUtil.fetchApiStore().changeSupplierFollow(entity.id!)
        .apiCallback((data){
       pageInfo.reset();
        getMyFollowCompanyList();
    });
  }
}