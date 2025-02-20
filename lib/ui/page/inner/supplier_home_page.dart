import 'dart:async';
import 'dart:typed_data';

import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/category_product_model.dart';
import 'package:dealful_mall/model/supplier_profile.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_banner.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_brand.dart';
import 'package:dealful_mall/ui/page/home/tabhome/tab_home_products.dart';
import 'package:dealful_mall/ui/widgets/ad_banner_widget.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/custom_enhance_number_card.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:dealful_mall/view_model/supplier_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:dealful_mall/utils/analyze_background_color.dart';

class SupplierHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupplierDetailState();
}

class _SupplierDetailState extends State<SupplierHomePage> {
  late SupplierDetailModel supplierDetailModel;
  bool _showTitle = false;
  final ScrollController _scrollController = ScrollController();
  Color _textColor = Colors.white;  // 默认文字颜色
  bool _isDark = true;  // 是否是深色背景

  @override
  void initState() {
    super.initState();
    supplierDetailModel =
        SupplierDetailModel(XUtils.textOf(Get.parameters[AppParameters.ID]));
    _acquireData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _acquireData() async {
    supplierDetailModel.acquireData(onSuccess: () {
      if (supplierDetailModel.supplierProfile?.coverImageUrl != null) {
        AnalyzeBackgroundColor.analyze(
          imageUrl: supplierDetailModel.supplierProfile!.coverImageUrl!,
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

  void _onScroll() {
    if (_scrollController.offset > 100) {
      if (!_showTitle) {
        setState(() {
          _showTitle = true;
        });
      }
    } else {
      if (_showTitle) {
        setState(() {
          _showTitle = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SupplierDetailModel>(
          create: (context) => supplierDetailModel,
          child: Consumer<SupplierDetailModel>(builder: (context, _model, child) {
            if (_model.pageState != PageState.hasData) {
              return ViewModelStateWidget.stateWidgetWithCallBack(
                  supplierDetailModel, _onRefresh);
            }
            bool showHeader = _model.supplierProfile != null;
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: _textColor == Colors.white ? Brightness.light : Brightness.dark,
                  ),
                  title: _showTitle ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 店铺logo
                      Container(
                        width: 90.r,
                        height: 90.r,
                        margin: EdgeInsets.only(right: 16.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: CachedImageView(
                            90.r,
                            90.r,
                            _model.supplierProfile?.avatarUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 店铺名称
                      Container(
                        constraints: BoxConstraints(maxWidth: 0.5.sw), // 限制标题最大宽度为屏幕宽度的一半
                        child: Text(
                          XUtils.textOf(_model.supplierProfile?.storeName),
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 46.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 90.r), // 添加一个与logo相同宽度的空白，以保持整体居中
                    ],
                  ) : null,
                  iconTheme: IconThemeData(color: _textColor),
                  backgroundColor: _showTitle ? Colors.white : Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _supplierHeader(_model.supplierProfile),
                  ),
                  expandedHeight: showHeader ? AppDimens.DIMENS_310.r : null,
                  pinned: true,
                  collapsedHeight: showHeader ? kToolbarHeight : null,
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          NavigatorUtil.goSearchGoods(context,
                              supplierId: supplierDetailModel.supplierId);
                        },
                        child: Icon(Icons.search_outlined, 
                          color: _showTitle ? Colors.black : _textColor,
                        ),
                      ),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      TabHomeBanner(_model.banners),
                      TabHomeProducts(
                          AppStrings.SPECIAL_OFFER_PRODUCTS.translated,
                          _model.specialOfferProducts ?? [],
                          uiType: 1, onTapTitle: () {
                        NavigatorUtil.goSearchGoods(context,
                            type: AppStrings.SPECIAL_OFFER_PRODUCTS,
                            title:
                                AppStrings.SPECIAL_OFFER_PRODUCTS.translated);
                      }),
                      AdBannerWidget.fromList(_model.adBannerEntities,
                          AppStrings.SPECIAL_OFFER_PRODUCTS),
                      TabHomeProducts(
                        AppStrings.FEATURED_STORE_PRODUCTS.translated,
                        _model.featuredStoreProducts ?? [],
                        uiType: 1,
                        onTapTitle: () {
                          NavigatorUtil.goSearchGoods(context,
                              type: AppStrings.FEATURED_STORE_PRODUCTS,
                              title: AppStrings
                                  .FEATURED_STORE_PRODUCTS.translated);
                        },
                      ),
                      AdBannerWidget.fromList(_model.adBannerEntities,
                          AppStrings.FEATURED_STORE_PRODUCTS),
                      TabHomeProducts(
                        AppStrings.NEW_ARRIVAL_PRODUCTS.translated,
                        _model.newArrivalProducts ?? [],
                        uiType: 1,
                        onTapTitle: () {
                          NavigatorUtil.goSearchGoods(context);
                        },
                      ),
                      AdBannerWidget.fromList(_model.adBannerEntities,
                          AppStrings.NEW_ARRIVAL_PRODUCTS),
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
                                    productModel.categoryId,
                                    productModel.categoryName);
                              },
                            );
                          },
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, index) => SizedBox.shrink(),
                          itemCount: _model.categoryProductModels.length),
                      TabHomeBrand(AppStrings.SHOP_BY_BRAND.translated,
                          _model.brandList),
                      // Container(
                      //   height: 600,
                      //   color: Colors.red,
                      // )
                    ],
                  ),
                )
              ],
            );
          })),
    );
  }

  Widget _supplierHeader(SupplierProfile? supplierProfile) {
    if (supplierProfile == null) {
      return SizedBox.shrink();
    }
    bool followed = supplierProfile.isFollower == true;
    String text = followed
        ? AppStrings.FOLLOWING.translated
        : AppStrings.FOLLOW.translated;
    return Stack(
      children: [
        // 背景图
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(supplierProfile.coverImageUrl ?? ''),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // 黑色蒙版
        // Container(
        //   color: Colors.black.withOpacity(0.5),
        // ),
        // 内容
        Container(
          padding: EdgeInsets.only(
              left: AppDimens.DIMENS_30.w,
              right: AppDimens.DIMENS_30.w,
              top: MediaQuery.of(context).padding.top + kToolbarHeight/2 + 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 左侧店铺信息
              Expanded(
                child: Row(
                  children: [
                    // 店铺头像
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.DIMENS_20.r),
                      child: CachedImageView(
                        AppDimens.DIMENS_140.r,
                        AppDimens.DIMENS_140.r,
                        supplierProfile.avatarUrl,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: AppDimens.DIMENS_20.w),
                    // 店铺名称和关注数
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            XUtils.textOf(supplierProfile.storeName),
                            style: TextStyle(
                              fontSize: 52.sp,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${XUtils.textOf(supplierProfile.followers)}  ${AppStrings.FOLLOWING.translated}',
                            style: TextStyle(
                              fontSize: 38.sp,
                              color: _textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 右侧关注按钮
              Container(
                height: AppDimens.DIMENS_80.h,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      followed ? Colors.grey[200] : AppColors.primaryColor,
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_40.w),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.DIMENS_50.r),
                      ),
                    ),
                  ),
                  onPressed: () {
                    supplierDetailModel.changeFollow();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!followed) ...[
                        Icon(
                          Icons.add,
                          color: _textColor,
                          size: 32.sp,
                        ),
                        SizedBox(width: 4.w),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color:  _textColor,
                          fontSize: 38.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 刷新数据
  void _onRefresh() {
    supplierDetailModel.acquireData();
  }
}
