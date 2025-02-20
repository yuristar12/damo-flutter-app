import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/event/order_refresh_event.dart';
import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/order_detail_entity.dart';
import 'package:dealful_mall/model/order_product.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/divider_line.dart';
import 'package:dealful_mall/ui/widgets/item_text.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/order_detail_view_model.dart';
import 'package:dealful_mall/view_model/order_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage();

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailViewModel _orderDetailViewModel = OrderDetailViewModel();
  OrderViewModel _orderViewModel = OrderViewModel();
  String? orderId;
  String paymentUrl = "";

  @override
  void initState() {
    super.initState();
    orderId = Get.parameters[AppParameters.ORDER_ID];
    paymentUrl = XUtils.textOf(Get.parameters[AppParameters.PAY_URL]);
    refresh();
  }

  void refresh() {
    _orderDetailViewModel.queryOrderDetail(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.MINE_ORDER_DETAIL.translated),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (_) => _orderDetailViewModel,
        child: Consumer<OrderDetailViewModel>(builder: (context, model, child) {
          return _initView(model);
        }),
      ),
    );
  }

  Widget _initView(OrderDetailViewModel orderDetailViewModel) {
    if (orderDetailViewModel.pageState == PageState.hasData) {
      return _contentView(orderDetailViewModel);
    }
    return ViewModelStateWidget.stateWidget(orderDetailViewModel);
  }

  Widget _contentView(OrderDetailViewModel orderDetailViewModel) {
    OrderDetailEntity orderDetailEntity =
        orderDetailViewModel.orderDetailEntity!;
    List<OrderAddress> orderAddressList = orderDetailEntity.ordersAddress ?? [];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...List.generate(orderAddressList.length,
                  (index) => _addressWidget(orderAddressList[index])),
              DividerLineView(),
              _orderGoodsWidget(orderDetailEntity),
              DividerLineView(),
              _goodsPriceMessage(orderDetailEntity),
              _billNoMessage(orderDetailEntity)
            ]),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: _orderDetailViewModel.canDelete(),
              child: Container(
                  width: ScreenUtil().setWidth(AppDimens.DIMENS_480),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: TextButton(
                    child: Text(
                      AppStrings.DELETE.translated,
                      style: XTextStyle.color_333333_size_42,
                    ),
                    onPressed: () =>
                        _showDialog(2, XUtils.textOf(orderDetailEntity.id)),
                  )),
            ),
            Visibility(
              visible: _orderDetailViewModel.canCancel(),
              child: Container(
                  width: ScreenUtil().setWidth(AppDimens.DIMENS_480),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: TextButton(
                    child: Text(
                      AppStrings.CANCEL.translated,
                      style: XTextStyle.color_333333_size_42,
                    ),
                    onPressed: () =>
                        _showDialog(1, XUtils.textOf(orderDetailEntity.id)),
                  )),
            ),
            Visibility(
              visible: false,
              child: Container(
                  width: ScreenUtil().setWidth(AppDimens.DIMENS_480),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.primaryColor),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.DIMENS_30))))),
                    child: Text(
                      AppStrings.PAY.translated,
                      style: XTextStyle.color_333333_size_42,
                    ),
                    onPressed: () {
                      Get.toNamed(XRouterPath.webView, parameters: {
                        AppParameters.URL: paymentUrl,
                      })?.then((onValue) {
                        refresh();
                      });
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _addressWidget(OrderAddress? orderAddress) {
    AddressEntity? addressEntity = orderAddress?.addresses;
    if (orderAddress == null || addressEntity == null) {
      return SizedBox.shrink();
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(XUtils.textOf(orderAddress.title),
                style: XTextStyle.color_000000_size_45_bold),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(XUtils.textOf(addressEntity.name),
                    style: XTextStyle.color_333333_size_42),
                Padding(
                  padding: EdgeInsets.only(
                    left: AppDimens.DIMENS_30.w,
                  ),
                  child: Text(XUtils.textOf(addressEntity.phoneNumber),
                      style: XTextStyle.color_666666_size_42),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: AppDimens.DIMENS_10.h),
              child: Text(
                  "${XUtils.textOf(
                    addressEntity.country,
                  )} ${XUtils.textOf(addressEntity.state)} ${XUtils.textOf(addressEntity.city)}${XUtils.textOf(addressEntity.address)}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: XTextStyle.color_333333_size_42),
            ),
          ],
        ));
  }

  Widget _orderGoodsWidget(OrderDetailEntity orderDetailEntity) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      padding: EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: AppDimens.DIMENS_80.h,
                child: Text(
                  AppStrings.STATUS.translated,
                  style: XTextStyle.color_333333_size_42,
                ),
              ),
              Expanded(
                  child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  _orderDetailViewModel.getOrderStatusText().translated,
                  style: XTextStyle.color_primary_size_42,
                ),
              )),
            ],
          ),
          BrnIconButton(
            name: XUtils.textOf(orderDetailEntity.store?.storeName),
            iconWidget: Icon(Icons.chevron_right),
            onTap: () {
              String id = XUtils.textOf(orderDetailEntity.store?.id);
              if (id.isNotEmpty) {
                Get.toNamed(XRouterPath.supplierDetail,
                    parameters: {AppParameters.ID: id});
              }
            },
            style: XTextStyle.color_black_size_42,
            direction: Direction.right,
            widgetWidth: double.infinity,
            widgetHeight: AppDimens.DIMENS_80.r,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orderDetailEntity.orderProducts?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return _goodItemView(orderDetailEntity.orderProducts?[index],
                  index == orderDetailEntity.orderProducts?.length);
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: AppDimens.DIMENS_10.h,
            ),
          )
        ],
      ),
    );
  }

  Widget _goodItemView(OrderProduct? product, bool showLine) {
    return Container(
        child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CachedImageView(
                AppDimens.DIMENS_300.r, AppDimens.DIMENS_300.r, product?.image),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(XUtils.textOf(product?.productTitle),
                        style: XTextStyle.color_333333_size_42),
                    Padding(
                        padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h)),
                    Text(
                      XUtils.textOf(product?.variationOptionIds),
                      style: XTextStyle.color_999999_size_42,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h)),
                    Row(
                      children: [
                        Text(
                          XUtils.textOf(product?.productUnitPrice),
                          style: XTextStyle.color_333333_size_42_bold,
                        ),
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "x${product?.productQuantity}",
                            style: XTextStyle.color_666666_size_38,
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Offstage(
          offstage: showLine,
          child: Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
            child: DividerLineView(),
          ),
        )
      ],
    ));
  }

  Widget _goodsPriceMessage(OrderDetailEntity orderDetailEntity) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      child: Column(
        children: [
          ItemTextView(AppStrings.TOTAL_AMOUNT.translated,
              "${orderDetailEntity.priceTotal}"),
          DividerLineView(),
          ItemTextView(AppStrings.SHIPPING_COST.translated,
              "${orderDetailEntity.priceShipping}"),
        ],
      ),
    );
  }

  Widget _billNoMessage(OrderDetailEntity orderDetailEntity) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      margin: EdgeInsets.only(top: AppDimens.DIMENS_30.h),
      child: Column(
        children: [
          ItemTextView(AppStrings.ORDER_NUMBER.translated,
              XUtils.textOf(orderDetailEntity.orderNumber)),
        ],
      ),
    );
  }

  _showDialog(int action, String orderId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppStrings.TIPS,
              style: XTextStyle.color_333333_size_48,
            ),
            content: Text(
              action == 1
                  ? AppStrings.MINE_ORDER_CANCEL_TIPS
                  : AppStrings.MINE_ORDER_DELETE_TIPS,
              style: XTextStyle.color_333333_size_42,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppStrings.CANCEL,
                    style: XTextStyle.color_primary_size_42,
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (action == 1) {
                      _cancelOrder(orderId);
                    } else {
                      _deleteOrder(orderId);
                    }
                  },
                  child: Text(
                    AppStrings.CONFIRM,
                    style: XTextStyle.color_333333_size_42,
                  )),
            ],
          );
        });
  }

  _deleteOrder(String orderId) {
    _orderViewModel.deleteOrder(orderId).then((value) {
      if (value!) {
        orderEventBus.fire(OrderRefreshEvent());
        Navigator.pop(context);
      }
    });
  }

  _cancelOrder(String orderId) {
    _orderViewModel.cancelOrder(orderId).then((value) {
      if (value!) {
        orderEventBus.fire(OrderRefreshEvent());
        Navigator.pop(context);
      }
    });
  }
}
