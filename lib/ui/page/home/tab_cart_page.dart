import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/fill_in_order_entity.dart';
import 'package:dealful_mall/model/simple_cart_bean.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/cart_number.dart';
import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/refresh_state_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/cart_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:dealful_mall/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TabCartPage extends StatefulWidget {
  @override
  _TabCartPageState createState() => _TabCartPageState();
}

class _TabCartPageState extends State<TabCartPage> {
  RefreshController _refreshController = RefreshController();
  late CartViewModel _cartViewModel;

  @override
  void initState() {
    super.initState();
    _cartViewModel = Get.find();
    _cartViewModel.queryCart();

    XLocalization.listen((data) {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserViewModel>.value(value: Get.find()),
          ChangeNotifierProvider<CartViewModel>.value(value: Get.find())
        ],
        child: Consumer<CartViewModel>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(AppStrings.CART.translated),
                  Obx(() => Visibility(
                      visible: model.cartNum > 0,
                      child: Text(" (${model.cartNum})", style: XTextStyle.color_666666_size_38,)))
                ],
              ),
              centerTitle: false,
            ),
            body: _contentView(model),
            bottomNavigationBar: _bottomWidget(model),
          );
        }));
  }

  Widget _bottomWidget(CartViewModel cartViewModel) {
    return cartViewModel.isShowBottomView
        ? Container(
            height: ScreenUtil().setHeight(AppDimens.DIMENS_180),
            decoration: ShapeDecoration(
                shape: Border(
                    top:
                        BorderSide(color: AppColors.COLOR_F0F0F0, width: 1.0))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                    value: cartViewModel.isAllCheck,
                    activeColor: AppColors.primaryColor,
                    onChanged: (bool) {
                      _cartViewModel.setCheckAll(bool == true);
                    }),
                Container(
                  width: ScreenUtil().setWidth(AppDimens.DIMENS_240),
                  child: Text(
                      "${AppStrings.SUBTOTAL.translated}: ${XLocalization.currencyEntity?.symbol}${cartViewModel.countMoney()}"),
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      FillInOrderEntity? entity = _cartViewModel.packOrder();
                      if (entity != null) {
                        NavigatorUtil.goFillInOrder(context, entity)
                            ?.then((onValue) {
                          if (XRouter.fetchResult() == XRouter.resultOk) {
                            _onRefresh();
                          }
                        });
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.primaryColor)),
                    child: Text(
                      AppStrings.PAY.translated,
                      style: TextStyle(
                          color: AppColors.COLOR_FFFFFF,
                          fontSize: AppDimens.DIMENS_42.sp),
                    ),
                  ),
                ))
              ],
            ),
          )
        : SizedBox.shrink();
  }

  Widget _initView(CartViewModel cartViewModel) {
    RefreshStateUtil.getInstance().stopRefreshOrLoadMore(_refreshController);
    switch (cartViewModel.pageState) {
      case PageState.hasData:
        return ListView.separated(
          itemBuilder: (context, index) {
            SimpleCartBean cartBean = cartViewModel.cartList[index];
            List<ShoppingCartProduct> cartProducts =
                cartBean.shoppingCartProduct ?? [];
            return Card(
                margin: EdgeInsets.only(
                  left: AppDimens.DIMENS_30.w,
                  right: AppDimens.DIMENS_30.w,
                ),
                color: Colors.white,
                elevation: 0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: cartBean.checked,
                            activeColor: AppColors.primaryColor,
                            hoverColor: AppColors.primaryColor,
                            onChanged: (checked) {
                              _cartViewModel.checkCartItem(cartBean, checked!);
                            }),
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(XRouterPath.supplierDetail,
                                      parameters: {
                                        AppParameters.ID:
                                            XUtils.textOf(cartBean.company?.id)
                                      });
                                },
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(AppDimens.DIMENS_12.r),
                                      child: CachedImageView(
                                        AppDimens.DIMENS_48.r,
                                        AppDimens.DIMENS_48.r,
                                        cartBean.company?.avatarUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: AppDimens.DIMENS_6.w,),
                                    Expanded(
                                        child: Text(
                                            XUtils.textOf(
                                                cartBean.company?.storeName),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: XTextStyle
                                                .color_black_size_48)),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppColors.COLOR_999999,
                                    )
                                  ],
                                )))
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, productIndex) {
                        return _cartItemView(
                            cartBean, cartProducts[productIndex], index, productIndex);
                      },
                      itemCount: cartProducts.length,
                    )
                  ],
                ));
          },
          itemCount: cartViewModel.cartList.length,
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            height: AppDimens.DIMENS_10.h,
          ),
        );
      case PageState.empty:
        UserViewModel userViewModel = Get.find();
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
          child: Column(
            children: [
              SizedBox(
                height: AppDimens.DIMENS_400.h,
                child: EmptyDataView(),
              ),
              SizedBox(
                height: AppDimens.DIMENS_10.h,
              ),
              userViewModel.buildRecommendWidget()
            ],
          ),
        );
      default:
        return ViewModelStateWidget.stateWidgetWithCallBack(
            cartViewModel, _onRefresh);
    }
  }

  Widget _contentView(CartViewModel cartViewModel) {
    return SmartRefresher(
      header: WaterDropMaterialHeader(
        backgroundColor: AppColors.primaryColor,
      ),
      controller: _refreshController,
      onRefresh: () => _onRefresh(),
      onLoading: _onLoadMore,
      child: _initView(cartViewModel),
    );
  }

  _onRefresh() async {
    await _cartViewModel.queryCart(true);
  }

  Widget _cartItemView(
      SimpleCartBean cartBean, ShoppingCartProduct cartProduct,int cartIndex, int productIndex) {
    return Padding(
      key: ValueKey(_cartViewModel.obtainKey(cartProduct)),
      padding: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_20.r),
      child: Slidable(
          child: GestureDetector(
            onTap: () {
              NavigatorUtil.goGoodsDetails(
                  context, XUtils.textOf(cartProduct.product?.id));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                    value: cartProduct.checked,
                    activeColor: AppColors.primaryColor,
                    hoverColor: AppColors.primaryColor,
                    onChanged: (checked) {
                      _cartViewModel.checkProductItem(
                          cartBean, cartProduct, checked!);
                    }),
                CachedImageView(
                  ScreenUtil().setWidth(AppDimens.DIMENS_200),
                  ScreenUtil().setWidth(AppDimens.DIMENS_200),
                  XUtils.textOf(cartProduct.product?.imageUrl),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: AppDimens.DIMENS_20.w)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(XUtils.textOf(cartProduct.product?.title),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: XTextStyle.color_333333_size_38_bold),
                      Visibility(
                          visible:
                              cartProduct.productVariations?.isNotEmpty == true,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(top: AppDimens.DIMENS_10.h),
                              child: Text(
                                  XUtils.textOf(cartProduct.productVariations),
                                  style: XTextStyle.color_999999_size_42))),
                      Padding(
                        padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                        child: Row(
                          children: [
                            Text("${cartProduct.skuInfo?.price}",
                                style: XTextStyle.color_999999_size_42),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(20.0)),
                              alignment: Alignment.centerRight,
                              child: CartNumberView(
                                cartProduct.num ?? 1,
                                (value) {
                                  _cartViewModel.updateCartItem(
                                      cartProduct, value);
                                },
                                key: ValueKey(cartProduct.num ?? 1),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (actionContext) {
                  _cartViewModel
                      .deleteCartGoods([XUtils.textOf(cartProduct.id)], cartIndex, productIndex);
                },
                label: AppStrings.DELETE.translated,
                icon: Icons.delete,
                foregroundColor: AppColors.primaryColor,
              )
            ],
          )),
    );
  }

  void _onLoadMore() {
    _cartViewModel.loadMore();
  }
}
