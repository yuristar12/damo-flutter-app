import 'dart:math';

import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/fill_in_order_entity.dart';
import 'package:dealful_mall/model/label_entity.dart';
import 'package:dealful_mall/model/product_detail_entity.dart';
import 'package:dealful_mall/model/tiered_pricing_entity.dart';
import 'package:dealful_mall/ui/page/goods/goods_detail_swiper.dart';
import 'package:dealful_mall/ui/widgets/adaptive_webview.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/cart_number.dart';
import 'package:dealful_mall/ui/widgets/comment_widget.dart';
import 'package:dealful_mall/ui/widgets/custom_expandable_text.dart';
import 'package:dealful_mall/ui/widgets/keep_alive_wrapper.dart';
import 'package:dealful_mall/ui/widgets/link_flexible_space_bar.dart';
import 'package:dealful_mall/ui/widgets/review_widget.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/ui/widgets/x_text.dart';
import 'package:dealful_mall/utils/common_widget_creater.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/cart_view_model.dart';
import 'package:dealful_mall/view_model/goods_detail_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GoodsDetailPage extends StatefulWidget {
  const GoodsDetailPage();

  @override
  _GoodsDetailPageState createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends State<GoodsDetailPage>
    with TickerProviderStateMixin {
  late String _goodsId;
  final GoodsDetailViewModel _goodsDetailViewModel = GoodsDetailViewModel();
  late CartViewModel _cartViewModel;
  late TabController _tabController;
  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> globalKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  final RxBool expandX = RxBool(true);
  @override
  void initState() {
    super.initState();
    _goodsId = XUtils.textOf(Get.parameters[AppParameters.GOODS_ID]);
    _goodsDetailViewModel.getGoodsDetail(_goodsId);
    _cartViewModel = Get.find();
    _cartViewModel.freshCartNum();
    _tabController = TabController(length: 3, vsync: this);
    scrollController.addListener(() {
      onScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoodsDetailViewModel>(
      create: (context) => _goodsDetailViewModel,
      child: Selector<GoodsDetailViewModel, ProductDetailEntity?>(
        builder: (BuildContext context, ProductDetailEntity? goodsDetailEntity,
            Widget? child) {
          if (_goodsDetailViewModel.pageState != PageState.hasData) {
            return Scaffold(
                appBar: AppBar(),
                body: ViewModelStateWidget.stateWidgetWithCallBack(
                    _goodsDetailViewModel,
                    () => _goodsDetailViewModel.getGoodsDetail(_goodsId)));
          }
          String htmlBody = XUtils.textOf(_goodsDetailViewModel
              .productDetailEntity?.descriptionTab?.description);
          var screenWidth = ScreenUtil().screenWidth;
          return Scaffold(
            body: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  key: globalKeys[0],
                ),
                SliverAppBar(
                  key: ValueKey(XUtils.textOf(goodsDetailEntity?.id)),
                  pinned: true,
                  expandedHeight: screenWidth * 0.8,
                  collapsedHeight: kToolbarHeight,
                  flexibleSpace: LinkFlexibleSpaceBar(
                    background: KeepAliveWrapper(
                        child: GoodsDetailSwiper(
                      _goodsDetailViewModel.productDetailEntity?.imageList,
                            _goodsDetailViewModel.curImageUrlX
                    )),
                    childBuilder: (_, expanded) => _buildTopWidget(expanded),
                  ),
                  leading: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Obx(() => Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: expandX.isTrue
                                ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.8))
                                : null,
                            padding: EdgeInsets.all(2),
                            child: Icon(
                              Icons.arrow_back,
                              color: expandX.isTrue ? Colors.white : Colors.black,
                            ),
                          ))),
                  leadingWidth: 40,
                ),
                SliverToBoxAdapter(
                  child: showWidget(_goodsDetailViewModel),
                ),
                SliverVisibility(
                    visible: _goodsDetailViewModel
                            .productDetailEntity?.shippingLocationTab !=
                        null,
                    sliver: SliverToBoxAdapter(
                      child: _buildShippingLocationPart(_goodsDetailViewModel
                          .productDetailEntity?.shippingLocationTab),
                    )),
                SliverToBoxAdapter(
                  key: globalKeys[1],
                  child: _buildReviewPart(),
                ),
                SliverVisibility(
                  visible: htmlBody.isNotEmpty,
                  sliver: SliverToBoxAdapter(
                      key: globalKeys[2],
                      child: _buildDescriptionPart(_goodsDetailViewModel
                          .productDetailEntity?.descriptionTab)),
                )
              ],
            ),
            bottomNavigationBar: Selector<GoodsDetailViewModel, String>(
                builder: (BuildContext context, String data, Widget? child) {
              return bottomView();
            }, selector: (BuildContext context, GoodsDetailViewModel model) {
              return "${model.productDetailEntity?.id}${model.isCollection}";
            }),
          );
        },
        selector: (BuildContext context, GoodsDetailViewModel model) {
          return model.productDetailEntity;
        },
      ),
    );
  }

  Widget bottomView() {
    if (_goodsDetailViewModel.productDetailEntity == null) {
      return SizedBox.shrink();
    }
    return BottomAppBar(
      height: AppDimens.DIMENS_150.h,
      color: Colors.white,
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
                width: AppDimens.DIMENS_120.w,
                child: GestureDetector(
                  onTap: () {
                    var supplierId =
                        _goodsDetailViewModel.productDetailEntity?.company?.id;
                    if (supplierId != null) {
                      Get.toNamed(XRouterPath.supplierDetail, parameters: {
                        AppParameters.ID: XUtils.textOf(supplierId)
                      });
                    }
                  },
                  child: Icon(
                    Icons.storefront,
                    color: AppColors.COLOR_333333,
                    size: AppDimens.DIMENS_80.r,
                  ),
                )),
            Container(
                width: AppDimens.DIMENS_120.w,
                child: GestureDetector(
                  onTap: () => _collection(),
                  child: Icon(
                    Icons.favorite_border,
                    color: _goodsDetailViewModel.isCollection
                        ? AppColors.primaryColor
                        : AppColors.COLOR_333333,
                    size: AppDimens.DIMENS_80.r,
                  ),
                )),
            Container(
                width: AppDimens.DIMENS_120.w,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(XRouterPath.cartPage);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Icon(
                          Icons.shopping_cart,
                          color: AppColors.COLOR_333333,
                          size: AppDimens.DIMENS_80.r,
                        )),
                        Positioned(
                            left: 16,
                            child: Obx(() => Visibility(
                                visible: _cartViewModel.cartNum > 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primaryColor,
                                  ),
                                  height: 20,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                  child: XText(
                                    _cartViewModel.cartNum.toString(),
                                    color: AppColors.COLOR_FFFFFF,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ))))
                      ],
                    ),
                  ),
                )),
            Spacer(),
            Visibility(
              visible: _goodsDetailViewModel.isOnSell(),
              replacement: TextButton(
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                        horizontal: AppDimens.DIMENS_30.w)),
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.primaryColor),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppDimens.DIMENS_6))))),
                onPressed: () => openBottomSheet(
                    context, _goodsDetailViewModel.productDetailEntity!, 4),
                child: Text(AppStrings.REQUEST_QUOTE.translated,
                    style: XTextStyle.color_white_size_42),
              ),
              child: TextButton(
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                        horizontal: AppDimens.DIMENS_30.w)),
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.primaryColor),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimens.DIMENS_6)))),
                onPressed: () => openBottomSheet(
                    context, _goodsDetailViewModel.productDetailEntity!, 1),
                child: Text(AppStrings.ADD_TO_CART.translated,
                    style: XTextStyle.color_white_size_42),
              ),
            ),
            Visibility(
                visible: _goodsDetailViewModel.isOnSell(),
                child: Padding(
                    padding: EdgeInsets.only(left: AppDimens.DIMENS_30.w),
                    child: TextButton(
                      style: ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                              horizontal: AppDimens.DIMENS_30.w)),
                          backgroundColor:
                              WidgetStatePropertyAll(AppColors.primaryColor),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.DIMENS_6)))),
                      onPressed: () => openBottomSheet(context,
                          _goodsDetailViewModel.productDetailEntity!, 2),
                      child: Text(AppStrings.BUY_NOW.translated,
                          style: XTextStyle.color_white_size_42),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget showWidget(GoodsDetailViewModel categoryGoodsViewModel) {
    return _dataView(categoryGoodsViewModel);
  }

  Widget _dataView(GoodsDetailViewModel goodsDetailViewModel) {
    double ratingValue = double.tryParse(
            XUtils.textOf(goodsDetailViewModel.productDetailEntity?.rating)) ??
        0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: AppColors.COLOR_EDEEF2,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimens.DIMENS_30.r),
                  bottomRight: Radius.circular(AppDimens.DIMENS_30.r))),
          padding: EdgeInsets.only(
            top: AppDimens.DIMENS_10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    width: AppDimens.DIMENS_30.w,
                  ),
                  Obx(() => Visibility(
                      visible: _goodsDetailViewModel.tieredPricingListX.isEmpty,
                      child: Row(
                        children: [
                          Text(
                              XUtils.textOf(
                                  goodsDetailViewModel
                                      .productDetailEntity?.priceDiscounted,
                                  defValue: goodsDetailViewModel.isOnSell()
                                      ? ""
                                      : AppStrings.REQUEST_INQUIRY.translated),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: XTextStyle.color_primary_size_72_bold),
                          Visibility(
                              visible: goodsDetailViewModel
                                      .productDetailEntity?.price?.isNotEmpty ==
                                  true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: AppDimens.DIMENS_10.w),
                                  child: Text(
                                      XUtils.textOf(goodsDetailViewModel
                                          .productDetailEntity?.price),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: XTextStyle
                                          .color_primary_size_36_lineThrough))),
                          Visibility(
                              visible: goodsDetailViewModel.productDetailEntity
                                      ?.discountRate?.isNotEmpty ==
                                  true,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: AppDimens.DIMENS_20.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppDimens.DIMENS_20.w),
                                  decoration: BoxDecoration(
                                      color: AppColors.COLOR_FFF0F0,
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.DIMENS_15.r)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.discount,
                                        color: Colors.red,
                                        size: AppDimens.DIMENS_36.r,
                                      ),
                                      Text(
                                          XUtils.textOf(goodsDetailViewModel
                                              .productDetailEntity
                                              ?.discountRate),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: XTextStyle.color_black_size_36)
                                    ],
                                  ))),
                        ],
                      ))),
                  Spacer(),
                  Visibility(
                      visible: _goodsDetailViewModel.isBidding(),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimens.DIMENS_10.w),
                          child: InkWell(
                            onTap: () => openBottomSheet(context,
                                _goodsDetailViewModel.productDetailEntity!, 3),
                            child: Text(AppStrings.LABEL_BARGAIN.translated,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: XTextStyle.color_black_size_42),
                          ))),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: AppDimens.DIMENS_30.w),
                  child: _buildSkuObx()),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.COLOR_FFFFFF,
                ),
                margin: EdgeInsets.all(1),
                padding: EdgeInsets.all(AppDimens.DIMENS_20.r),
                child: Column(
                  children: [
                    CustomExpandableText(
                      text: XUtils.textOf(
                          goodsDetailViewModel.productDetailEntity?.name),
                      maxLines: 2,
                      expandText: AppStrings.MORE.translated,
                      collapseText: AppStrings.COLLAPSE.translated,
                      textStyle: XTextStyle.color_333333_size_52_bold,
                    ),
                    Stack(
                      children: [
                        _buildLabelList(goodsDetailViewModel
                            .productDetailEntity?.productInfos),
                        Positioned(
                          right: 0,
                          top: ratingValue > 0 ? AppDimens.DIMENS_20.h : 0,
                          child: Visibility(
                              visible: ratingValue > 0,
                              child: BrnRatingStar(
                                selectedCount: ratingValue,
                                space: 0.5,
                                canRatingZero: true,
                              )),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        openBottomSheet(
                            context,
                            _goodsDetailViewModel.productDetailEntity!,
                            _goodsDetailViewModel.isOnSell() ? 0 : 4);
                      },
                      child: ListView.builder(
                        padding: goodsDetailViewModel.productDetailEntity
                                    ?.variations?.isNotEmpty ==
                                true
                            ? EdgeInsets.only(top: AppDimens.DIMENS_20.h)
                            : EdgeInsets.zero,
                        itemBuilder: (_, index) {
                          Variations? variations = goodsDetailViewModel
                              .productDetailEntity?.variations?[index];
                          return _buildVariation(variations);
                        },
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: goodsDetailViewModel
                                .productDetailEntity?.variations?.length ??
                            0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewPart() {
    if (_goodsDetailViewModel.productDetailEntity == null) {
      return SizedBox.shrink();
    }
    bool hasReview = _goodsDetailViewModel.topReviewEntity != null ||
        _goodsDetailViewModel.commentEntities.isNotEmpty;
    double width = ScreenUtil().screenWidth * 0.6;
    return GestureDetector(
        onTap: () {
          Get.toNamed(XRouterPath.review, parameters: {
            AppParameters.SHOW_TYPE: AppStrings.REVIEW,
            AppParameters.GOODS_ID: _goodsId,
          });
        },
        behavior: HitTestBehavior.opaque,
        child: _buildPart(
            AppStrings.REVIEW.translated,
            hasReview
                ? Column(
                    children: [
                      ReviewWidget(_goodsDetailViewModel.topReviewEntity),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(XRouterPath.review, parameters: {
                              AppParameters.SHOW_TYPE: AppStrings.COMMENT,
                              AppParameters.GOODS_ID: _goodsId,
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            height: AppDimens.DIMENS_300.r,
                            child: ListView.separated(
                              padding: EdgeInsets.all(AppDimens.DIMENS_20.r),
                              itemBuilder: (_, index) => Container(
                                  width: width,
                                  padding:
                                      EdgeInsets.all(AppDimens.DIMENS_30.r),
                                  decoration: BoxDecoration(
                                      color: AppColors.COLOR_F7F7F9,
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.DIMENS_20.r)),
                                  child: CommentWidget(
                                    _goodsDetailViewModel
                                        .commentEntities[index],
                                  )),
                              separatorBuilder: (_, index) => SizedBox(
                                width: AppDimens.DIMENS_20.w,
                              ),
                              itemCount:
                                  _goodsDetailViewModel.commentEntities.length,
                              scrollDirection: Axis.horizontal,
                            ),
                          ))
                    ],
                  )
                : Text(AppStrings.NO_REVIEWS_FOUND.translated)));
  }

  Widget _buildShippingLocationPart(ShippingLocationTab? shippingLocationTab) {
    if (shippingLocationTab?.shipping?.isNotEmpty == true) {
      return _buildPart(shippingLocationTab?.shippingTabName,
          _buildLabelList(shippingLocationTab?.shipping));
    }
    return SizedBox.shrink();
  }

  Widget _buildDescriptionPart(DescriptionTab? descriptionTab) {
    if (descriptionTab == null) {
      return SizedBox.shrink();
    } else {
      return _buildPart(
          descriptionTab.descriptionTabName,
          AdaptiveWebView(
            htmlString: descriptionTab.description,
          ));
    }
  }

  Widget _buildPart(String? tabName, Widget child) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      padding: EdgeInsets.all(AppDimens.DIMENS_20.r),
      margin: EdgeInsets.only(top: AppDimens.DIMENS_30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            XUtils.textOf(tabName),
            style: XTextStyle.color_333333_size_42_bold,
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildLabelList(List<LabelEntity>? labelEntities) {
    return ListView.separated(
      padding: labelEntities?.isNotEmpty == true
          ? EdgeInsets.only(top: AppDimens.DIMENS_20.h)
          : EdgeInsets.zero,
      itemBuilder: (_, index) {
        LabelEntity? labelEntity = labelEntities?[index];
        return _buildLabelRow(labelEntity);
      },
      separatorBuilder: (_, index) => SizedBox(
        height: AppDimens.DIMENS_10.h,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: labelEntities?.length ?? 0,
    );
  }

  Widget _buildVariation(Variations? variations,
      {bool canTap = false, VoidCallback? onTapCallback}) {
    if (variations == null ||
        variations.variationOptions == null ||
        variations.variationOptions!.isEmpty) {
      return SizedBox.shrink();
    }
    String displayType = variations.optionDisplayType ?? "text";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_10.h),
            child: Text(
              XUtils.textOf(variations.labelName),
              style: XTextStyle.color_333333_size_42_bold,
            )),
        SizedBox(
          height: displayType == "text"
              ? AppDimens.DIMENS_90.r
              : AppDimens.DIMENS_126.r,
          child: ListView.separated(
            separatorBuilder: (_, index) => SizedBox(
              width: AppDimens.DIMENS_20.w,
            ),
            itemBuilder: (BuildContext context, int index) {
              VariationOptions variationOption =
                  variations.variationOptions![index];
              return GestureDetector(
                  onTap: canTap
                      ? () {
                          if (variationOption.selectedX.isFalse) {
                            variations.clearSelect();
                            variationOption.selectedX.value = true;
                            onTapCallback?.call();
                          }
                        }
                      : null,
                  child: Obx(() => Container(
                        padding: displayType != "text"
                            ? EdgeInsets.all(AppDimens.DIMENS_6.r)
                            : EdgeInsets.symmetric(
                                vertical: AppDimens.DIMENS_10.r,
                                horizontal: AppDimens.DIMENS_20.r),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: variationOption.selectedX.value
                                ? Border.all(color: AppColors.COLOR_333333)
                                : null,
                            color: AppColors.COLOR_F4F4F4),
                        clipBehavior: Clip.antiAlias,
                        child: buildVariationOption(
                            displayType,
                            variationOption,
                            _goodsDetailViewModel
                                .productDetailEntity?.imageList),
                      )));
            },
            scrollDirection: Axis.horizontal,
            itemCount: variations.variationOptions!.length,
          ),
        )
      ],
    );
  }

  Widget _buildLabelRow(LabelEntity? labelEntity) {
    if (labelEntity == null) {
      return SizedBox.shrink();
    }
    return Row(
      children: [
        Text(
          "${labelEntity.label}: ",
          style: XTextStyle.color_333333_size_36,
        ),
        Expanded(child: Text(
          XUtils.textOf(labelEntity.value),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: XTextStyle.color_999999_size_36,
        ))
      ],
    );
  }

  /// 打开购买面板 [showType]: 0-> 加入购物车、立即购买都显示 1->加入购物车 2-> 立即购买, 3-> 请求报价且同时显示加入购物车、立即购买按钮 4->询价
  openBottomSheet(BuildContext context, ProductDetailEntity productDetailEntity,
      int showType) {
    bool showCart = showType == 0 || showType == 1;
    bool showBuy = showType == 0 || showType == 2;
    bool showQuoteRequest = showType == 3;
    bool showInquiryRequest = showType == 4;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        )),
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, stateSetter) {
              (String?, String) result = _goodsDetailViewModel
                  .fetchSelectedVariation(productDetailEntity);
              String? imageUrl = result.$1;
              String selectLabel = result.$2;
              return Padding(
                  padding: EdgeInsets.all(AppDimens.DIMENS_30.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: ListView(
                        padding: EdgeInsets.only(bottom: AppDimens.DIMENS_10.h),
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.DIMENS_18.r),
                                  child: CachedImageView(
                                      AppDimens.DIMENS_180.r,
                                      AppDimens.DIMENS_180.r,
                                      XUtils.textOf(imageUrl)),
                                ),
                                SizedBox(
                                  width: AppDimens.DIMENS_20.w,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        XUtils.textOf(productDetailEntity
                                            .priceDiscounted),
                                        style: XTextStyle.color_333333_size_42),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil()
                                              .setHeight(AppDimens.DIMENS_20)),
                                    ),
                                    XText(
                                        "${AppStrings.SELECT.translated}: ${selectLabel}",
                                        maxLines: 2,
                                        color: AppColors.COLOR_333333,
                                        fontSize: AppDimens.DIMENS_42.sp),
                                  ],
                                )),
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Image.asset(
                                    AppImages.CLOSE,
                                    width: AppDimens.DIMENS_60.r,
                                    height: AppDimens.DIMENS_60.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildSkuObx(),
                          ListView.builder(
                            padding: productDetailEntity
                                        .variations?.isNotEmpty ==
                                    true
                                ? EdgeInsets.only(top: AppDimens.DIMENS_10.h)
                                : EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              Variations? variations =
                                  productDetailEntity.variations?[index];
                              return _buildVariation(variations, canTap: true,
                                  onTapCallback: () {
                                _goodsDetailViewModel.updateProductSku();
                                stateSetter.call(() {});
                              });
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                productDetailEntity.variations?.length ?? 0,
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                              child: Row(
                                children: [
                                  Text(AppStrings.QUANTITY.translated,
                                      style: XTextStyle.color_333333_size_42),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.all(ScreenUtil()
                                        .setWidth(AppDimens.DIMENS_30)),
                                    child: CartNumberView(
                                        _goodsDetailViewModel.numberX.value,
                                        (number) {
                                      _goodsDetailViewModel.numberX.value =
                                          number;
                                    }),
                                  ),
                                  Visibility(
                                      visible: showInquiryRequest,
                                      child: Obx(() =>
                                          DropdownButton<LabelEntity>(
                                              value: _goodsDetailViewModel
                                                  .quantityUnitX.value,
                                              underline:
                                                  const SizedBox.shrink(),
                                              dropdownColor: Colors.white,
                                              onChanged: (entity) {
                                                if (entity != null &&
                                                    entity !=
                                                        _goodsDetailViewModel
                                                            .quantityUnitX
                                                            .value) {
                                                  _goodsDetailViewModel
                                                      .quantityUnitX
                                                      .value = entity;
                                                }
                                              },
                                              items: CommonWidgetCreater
                                                  .buildLabelMenus(
                                                      _goodsDetailViewModel
                                                          .quantityUnits))))
                                ],
                              )),
                          Padding(
                              padding:
                                  EdgeInsets.only(top: AppDimens.DIMENS_10.h),
                              child: Row(
                                children: [
                                  Text(AppStrings.STOCK.translated,
                                      style: XTextStyle.color_333333_size_42),
                                  Spacer(),
                                  Text(XUtils.textOf(productDetailEntity.stock),
                                      style: XTextStyle.color_333333_size_42),
                                ],
                              )),
                        ],
                      )),
                      Row(
                        children: [
                          Visibility(
                              visible: showCart,
                              child: Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        showType == 0
                                            ? AppColors.COLOR_FFFFFF
                                            : AppColors.primaryColor),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          side: showType == 0
                                              ? BorderSide(color: Colors.black)
                                              : BorderSide.none,
                                          borderRadius: BorderRadius.circular(
                                              AppDimens.DIMENS_30)),
                                    )),
                                onPressed: () => _addCart(),
                                child: Text(AppStrings.ADD_TO_CART.translated,
                                    style: showType == 0
                                        ? XTextStyle.color_black_size_42
                                        : XTextStyle.color_white_size_42),
                              ))),
                          Visibility(
                              visible: showBuy,
                              child: SizedBox(
                                width: AppDimens.DIMENS_10.w,
                              )),
                          Visibility(
                              visible: showBuy,
                              child: Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.primaryColor),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimens.DIMENS_30)),
                                    )),
                                onPressed: () => _buy(),
                                child: Text(AppStrings.BUY_NOW.translated,
                                    style: XTextStyle.color_white_size_42),
                              ))),
                          Visibility(
                              visible: showInquiryRequest,
                              child: Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.primaryColor),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimens.DIMENS_30)),
                                    )),
                                onPressed: () => _requestInquiry(),
                                child: Text(
                                    AppStrings.REQUEST_INQUIRY.translated,
                                    style: XTextStyle.color_white_size_42),
                              ))),
                          Visibility(
                              visible: showQuoteRequest,
                              child: Expanded(
                                  child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.primaryColor),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimens.DIMENS_30)),
                                    )),
                                onPressed: () => _requestQuote(),
                                child: Text(AppStrings.LABEL_BARGAIN.translated,
                                    style: XTextStyle.color_white_size_42),
                              ))),
                        ],
                      )
                    ],
                  ));
            }));
  }

  _addCart() {
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) {
      if (value != null) {
        _cartViewModel
            .addCart(_goodsDetailViewModel.productDetailEntity!,
                _goodsDetailViewModel.numberX.value)
            .then((response) {
          if (response == true) {
            Navigator.of(context).pop(); //隐藏弹出框
          }
        });
      } else {
        NavigatorUtil.goLogin(context);
      }
    });
  }

  _buy() {
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) async {
      if (value != null) {
        FillInOrderEntity? entity = await _cartViewModel.packBuyOrder(
            _goodsDetailViewModel.productDetailEntity,
            _goodsDetailViewModel.numberX.value);
        if (entity != null) {
          Navigator.of(context).pop();
          NavigatorUtil.goFillInOrder(context, entity);
        }
      } else {
        NavigatorUtil.goLogin(context);
      }
    });
  }

  /// 请求报价
  _requestQuote() {
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) {
      if (value != null) {
        BrnMiddleInputDialog(
            title: AppStrings.LABEL_BARGAIN.translated,
            hintText: AppStrings.PRODUCT_PRICE.translated,
            cancelText: AppStrings.CANCEL.translated,
            confirmText: AppStrings.OK.translated,
            dismissOnActionsTap: false,
            autoFocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onConfirm: (value) {
              double? inputPrice = double.tryParse(value);
              if (inputPrice == null) {
                XUtils.showToast(AppStrings.LABLE_PRICE_REQUIRED.translated);
                return;
              }
              _cartViewModel
                  .requestQuote(_goodsDetailViewModel.productDetailEntity!,
                      _goodsDetailViewModel.numberX.value, inputPrice)
                  .then((response) {
                if (response == true) {
                  Navigator.of(context).pop(); //隐藏弹出框
                }
              });
            },
            onCancel: () {
              Navigator.pop(context);
            }).show(context);
      } else {
        NavigatorUtil.goLogin(context);
      }
    });
  }

  /// 询价
  _requestInquiry() {
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) {
      if (value != null) {
        BrnMiddleInputDialog(
            title: AppStrings.REQUEST_INQUIRY.translated,
            hintText: AppStrings.SHORT_DESCRIPTION.translated,
            cancelText: AppStrings.CANCEL.translated,
            confirmText: AppStrings.OK.translated,
            dismissOnActionsTap: false,
            autoFocus: true,
            onConfirm: (value) {
              if (value.isEmpty) {
                XUtils.showToast(AppStrings.INPUT_HINT.translated);
                return;
              }
              _goodsDetailViewModel
                  .requestInquiry(_goodsDetailViewModel.productDetailEntity!,
                      _goodsDetailViewModel.numberX.value, value)
                  .then((response) {
                if (response == true) {
                  Navigator.of(context).pop();
                }
              });
            },
            onCancel: () {
              Navigator.pop(context);
            }).show(context);
      } else {
        NavigatorUtil.goLogin(context);
      }
    });
  }

  _collection() {
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) {
      if (value == null) {
        NavigatorUtil.goLogin(context);
      } else {
        _goodsDetailViewModel.addOrDeleteCollect(_goodsId);
      }
    });
  }

  Widget _buildTopWidget(bool expanded) {
    if(expanded != expandX.value) {
      Future.delayed(Duration.zero).then((onValue){
        expandX.value = expanded;
      });
    }
    if (expanded) {
      return SizedBox.shrink();
    } else {
      return SizedBox(
        height: kToolbarHeight,
        child: TabBar(
            isScrollable: true,
            dividerColor: Colors.transparent,
            indicatorColor: AppColors.primaryColor,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.black,
            padding: EdgeInsets.zero,
            tabAlignment: TabAlignment.center,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            controller: _tabController,
            onTap: (index) {
              GlobalKey targetKey = globalKeys[index];
              BuildContext? buildContext = targetKey.currentContext;
              if (buildContext != null) {
                Scrollable.ensureVisible(
                  buildContext,
                );
              }
            },
            tabs: [
              Text(AppStrings.PRODUCT.translated),
              Text(AppStrings.REVIEW.translated),
              Text(AppStrings.DETAILS.translated),
            ]),
      );
    }
  }

  void onScroll() {
    int i = 0;
    for (; i < globalKeys.length; i++) {
      final keyRenderObject = globalKeys[i].currentContext?.findRenderObject();
      if (keyRenderObject != null) {
        final offsetY = (keyRenderObject.parentData as SliverPhysicalParentData)
            .paintOffset
            .dy;
        if (offsetY > 80) {
          break;
        }
      }
    }
    final newIndex = min(i, _tabController.length - 1);
    if (newIndex != _tabController.index) {
      _tabController.animateTo(newIndex);
    }
  }

  Widget buildVariationOption(String displayType,
      VariationOptions variationOption, List<ImageBean>? imageList) {
    switch (displayType) {
      case "image":
        String? imageUrl = imageList
            ?.firstWhereOrNull(
                (test) => test.id == variationOption.colorOrImage)
            ?.imageSmall;
        return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedImageView(
              AppDimens.DIMENS_116.r,
              AppDimens.DIMENS_120.r,
              imageUrl,
              fit: BoxFit.fill,
            ));
      case "color":
        return ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: AppDimens.DIMENS_120.r,
              height: AppDimens.DIMENS_120.r,
              color: variationOption.colorOrImage.toColor(),
            ));
      default:
        return Text(XUtils.textOf(variationOption.optionName),
            style: XTextStyle.color_333333_size_38);
    }
  }

  Widget buildTieredPricingItem(
      TieredPricing tieredPricingEntity, bool checked) {
    Color color = checked ? AppColors.primaryColor : AppColors.COLOR_333333;
    String numStr =
        "${tieredPricingEntity.minNum}-${tieredPricingEntity.maxNum}";
    if (tieredPricingEntity.maxNum == null) {
      numStr = "≥${tieredPricingEntity.minNum}";
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            XUtils.textOf(
              tieredPricingEntity.priceDiscounted,
            ),
            style: TextStyle(
                color: color,
                fontWeight: checked ? FontWeight.bold : FontWeight.normal,
                fontSize: AppDimens.DIMENS_42.sp),
          ),
          Text(
            "$numStr pieces",
            style: TextStyle(
                color: color,
                fontWeight: checked ? FontWeight.bold : FontWeight.normal,
                fontSize: AppDimens.DIMENS_36.sp),
          )
        ],
      ),
    );
  }

  _buildSkuObx() => Obx(() {
        return Visibility(
            visible: _goodsDetailViewModel.tieredPricingListX.isNotEmpty,
            child: Container(
                height: AppDimens.DIMENS_100.h,
                margin: EdgeInsets.only(top: AppDimens.DIMENS_26.h),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    width: AppDimens.DIMENS_20.w,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((_, index) => Obx(() {
                        TieredPricing item =
                            _goodsDetailViewModel.tieredPricingListX[index];
                        bool checked = _goodsDetailViewModel.numberX >=
                                (item.minNum ?? 0) &&
                            _goodsDetailViewModel.numberX <= (item.maxNum ?? 0);
                        return buildTieredPricingItem(item, checked);
                      })),
                  itemCount: _goodsDetailViewModel.tieredPricingListX.length,
                )));
      });
}
