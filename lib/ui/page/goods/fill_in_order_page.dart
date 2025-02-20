import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/cart_bean.dart';
import 'package:dealful_mall/model/fill_in_order_entity.dart';
import 'package:dealful_mall/model/payment_setting.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/divider_line.dart';
import 'package:dealful_mall/ui/widgets/item_text.dart';
import 'package:dealful_mall/ui/widgets/right_arrow.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/fill_in_order_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FillInOrderPage extends StatefulWidget {
  const FillInOrderPage();

  @override
  _FillInOrderPageState createState() => _FillInOrderPageState();
}

class _FillInOrderPageState extends State<FillInOrderPage> {
  FillInOrderViewModel _fillInOrderViewModel = FillInOrderViewModel();
  TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FillInOrderEntity entity = Get.arguments;
    _fillInOrderViewModel.fillInOrder(entity);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FillInOrderViewModel>(
      create: (context) => _fillInOrderViewModel,
      child: Selector<FillInOrderViewModel, FillInOrderEntity?>(
          selector: (BuildContext context, FillInOrderViewModel model) {
        return model.fillInOrderEntity;
      }, builder: (context, data, child) {
        return showWidget(_fillInOrderViewModel);
      }),
    );
  }

  Widget showWidget(FillInOrderViewModel fillInOrderViewModel) {
    if (fillInOrderViewModel.pageState == PageState.hasData) {
      return _dataView(fillInOrderViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        fillInOrderViewModel, () {});
  }

  Widget _dataView(FillInOrderViewModel model) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.ORDER_INFORMATION.translated),
          centerTitle: true,
        ),
        body: _contentView(model),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          margin:
              EdgeInsets.only(left: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
          height: ScreenUtil().setHeight(AppDimens.DIMENS_150),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "${AppStrings.TOTAL_AMOUNT.translated}${XLocalization.currencyEntity?.symbol}${model.fillInOrderEntity!.orderTotalPrice}",
                style: XTextStyle.color_333333_size_42,
              )),
              Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(AppDimens.DIMENS_300),
                height: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primaryColor),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppDimens.DIMENS_30))))),
                  onPressed: () => _submitOrder(),
                  child: Text(
                    AppStrings.SUBMIT.translated,
                    style: XTextStyle.color_ffffff_size_42,
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  Widget _contentView(FillInOrderViewModel model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _addressWidget(model, true),
          DividerLineView(height: AppDimens.DIMENS_20),
          _addressWidget(model, false),
          DividerLineView(height: AppDimens.DIMENS_20),
          Column(
            children: _goodsItems(model.fillInOrderEntity!.checkedGoodsList!),
          ),
          DividerLineView(height: AppDimens.DIMENS_20),
          // _remarkWidget(),
          ..._totalPricePart(model),
          DividerLineView(),
          ItemTextView(AppStrings.PAYMENT_METHOD.translated, ""),
          ColoredBox(
              color: Colors.white,
              child: Obx(() => ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      PaymentSetting paymentSetting =
                          model.paymentSettingsX[index];
                      return Row(
                        children: [
                          Image.asset(
                            "images/icon_payment_${paymentSetting.nameKey}.png",
                            height: AppDimens.DIMENS_48.r,
                          ),
                          SizedBox(
                            width: AppDimens.DIMENS_10.w,
                          ),
                          Expanded(
                              child: Text(XUtils.textOf(paymentSetting.name),
                                  style: XTextStyle.color_333333_size_36)),
                          Obx(() => BrnCheckbox(
                              radioIndex: index,
                              isSelected:
                                  model.selectPaymentX.value == paymentSetting,
                              onValueChangedAtIndex: (index, checkd) {
                                model.selectPaymentX.value = paymentSetting;
                              }))
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: AppDimens.DIMENS_10.h,
                    ),
                    itemCount: model.paymentSettingsX.length,
                  )))
        ],
      ),
    );
  }

  List<Widget> _totalPricePart(FillInOrderViewModel model) {
    if ((model.fillInOrderEntity?.goodsTotalPrice ?? 0) > 0) {
      return [
        DividerLineView(height: AppDimens.DIMENS_20),
        ItemTextView(AppStrings.PRODUCT_PRICE.translated,
            "${XLocalization.currencyEntity?.symbol}${model.fillInOrderEntity!.goodsTotalPrice}"),
        DividerLineView(),
        ItemTextView(AppStrings.SHIPPING_COST.translated,
            "${XLocalization.currencyEntity?.symbol}${model.fillInOrderEntity!.freightPrice ?? 0}"),
        DividerLineView(),
        ItemTextView(AppStrings.DISCOUNT.translated,
            "${XLocalization.currencyEntity?.symbol}${model.fillInOrderEntity!.couponPrice ?? 0}"),
      ];
    }
    return [];
  }

  List<Widget> _goodsItems(List<CartBean> goods) {
    List<Widget> widgets = [];
    for (int i = 0; i < goods.length; i++) {
      widgets.add(_goodsItem(goods[i]));
      if (i != goods.length - 1) {
        widgets.add(DividerLineView());
      }
    }
    return widgets;
  }

  Widget _goodsItem(CartBean checkedGoods) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
          right: ScreenUtil().setWidth(AppDimens.DIMENS_30),
          top: ScreenUtil().setHeight(AppDimens.DIMENS_20),
          bottom: ScreenUtil().setHeight(AppDimens.DIMENS_20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CachedImageView(
              ScreenUtil().setWidth(AppDimens.DIMENS_240),
              ScreenUtil().setWidth(AppDimens.DIMENS_240),
              checkedGoods.productImage),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        XUtils.textOf(checkedGoods.productName),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: XTextStyle.color_333333_size_42,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top:
                                  ScreenUtil().setHeight(AppDimens.DIMENS_10))),
                      Text(
                        XUtils.textOf(checkedGoods.productVariations),
                        style: XTextStyle.color_999999_size_42,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top:
                                  ScreenUtil().setHeight(AppDimens.DIMENS_20))),
                      Text(
                        "${checkedGoods.showUnitPrice}",
                        style: XTextStyle.color_primary_size_42,
                      )
                    ],
                  ))),
          Text("${AppStrings.GOODS_NUMBER}${checkedGoods.num}")
        ],
      ),
    );
  }

  /// 地址控件 [model]是数据模型 [shipping]为true时指运送地址,反之是账单地址
  Widget _addressWidget(FillInOrderViewModel model, bool shipping) {
    return ChangeNotifierProvider.value(
      value: _fillInOrderViewModel,
      child: Selector<FillInOrderViewModel, AddressEntity?>(builder:
          (context, data, child) {
        AddressEntity? addressEntity =
            shipping ? model.shippingAddress : model.billingAddress;
        bool validAddress = addressEntity != null && addressEntity.id != 0;
        return Container(
          color: AppColors.COLOR_FFFFFF,
          padding: EdgeInsets.symmetric(
              horizontal: AppDimens.DIMENS_30.w,
              vertical: AppDimens.DIMENS_10.h),
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () {
              NavigatorUtil.goAddress(context, 1)
                  ?.then((value) => model.updateAddress(value, shipping));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        shipping
                            ? AppStrings.SHIPPING_ADDRESS.translated
                            : AppStrings.BILLING_ADDRESS.translated,
                        style: XTextStyle.color_000000_size_45_bold),
                    Visibility(
                        visible: validAddress,
                        replacement: Padding(
                            padding:
                                EdgeInsets.only(bottom: AppDimens.DIMENS_20.r),
                            child: Text(
                                AppStrings.COMMON_CHOOSE_HINT.translated,
                                style: XTextStyle.color_999999_size_42)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(XUtils.textOf(addressEntity?.name),
                                style: XTextStyle.color_333333_size_42),
                            Padding(
                              padding: EdgeInsets.only(
                                left: AppDimens.DIMENS_30.w,
                              ),
                              child: Text(
                                  XUtils.textOf(addressEntity?.phoneNumber),
                                  style: XTextStyle.color_666666_size_42),
                            ),
                          ],
                        )),
                    Visibility(
                        visible: validAddress,
                        child: Padding(
                          padding: EdgeInsets.only(top: AppDimens.DIMENS_10.h),
                          child: Text(
                              "${XUtils.textOf(addressEntity?.country)} ${XUtils.textOf(addressEntity?.state)} ${XUtils.textOf(addressEntity?.city)}${XUtils.textOf(addressEntity?.address)}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: XTextStyle.color_333333_size_42),
                        )),
                  ],
                )),
                RightArrow()
              ],
            ),
          ),
        );
      }, selector:
          (BuildContext context, FillInOrderViewModel fillInOrderViewModel) {
        if (shipping) {
          return fillInOrderViewModel.shippingAddress;
        } else {
          return fillInOrderViewModel.billingAddress;
        }
      }),
    );
  }

  _submitOrder() {
    if (_fillInOrderViewModel.shippingAddress == null ||
        _fillInOrderViewModel.shippingAddress?.id == 0) {
      XUtils.showToast(AppStrings.MSG_CART_SHIPPING.translated);
      return;
    }
    _fillInOrderViewModel.submitOrder();
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }
}
