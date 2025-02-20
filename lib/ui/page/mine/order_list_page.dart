import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/event/order_refresh_event.dart';
import 'package:dealful_mall/model/order_entity.dart';
import 'package:dealful_mall/model/order_product.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/refresh_state_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/order_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderListPage extends StatefulWidget {
  final int showType;

  const OrderListPage(this.showType);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with AutomaticKeepAliveClientMixin {
  final OrderViewModel _orderViewModel = OrderViewModel();
  final RefreshController _refreshController = RefreshController();
  final PageInfo pageInfo = PageInfo(20);

  @override
  void initState() {
    super.initState();
    _orderViewModel.queryOrder(widget.showType, pageInfo);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    orderEventBus.on<OrderRefreshEvent>().listen((event) {
      pageInfo.reset();
      _orderViewModel.queryOrder(widget.showType, pageInfo);
    });
    return Material(
        color: Colors.transparent,
        child: ChangeNotifierProvider(
            create: (_) => _orderViewModel,
            child: Consumer<OrderViewModel>(builder: (context, model, child) {
              if (model.canLoadMore) {
                pageInfo.nextPage();
              }
              RefreshStateUtil.getInstance()
                  .stopRefreshOrLoadMore(_refreshController);
              return _initView(model);
            })));
  }

  Widget _initView(OrderViewModel orderViewModel) {
    if (orderViewModel.pageState == PageState.hasData) {
      return _contentView(orderViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        orderViewModel, _onRefresh);
  }

  Widget _contentView(OrderViewModel orderViewModel) {
    return Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
            right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
        child: SmartRefresher(
          onRefresh: () => _onRefresh(),
          onLoading: () => _onLoadMore(),
          enablePullDown: true,
          enablePullUp: orderViewModel.canLoadMore,
          header: ClassicHeader(),
          controller: _refreshController,
          child: ListView.builder(
              itemCount: orderViewModel.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return _orderItemView(orderViewModel.data![index]);
                // return Text("data");
              }),
        ));
  }

  _onRefresh() {
    pageInfo.reset();
    _orderViewModel.queryOrder(widget.showType, pageInfo);
  }

  _onLoadMore() {
    _orderViewModel.queryOrder(widget.showType, pageInfo);
  }

  Widget _orderItemView(OrderEntity order) {
    int count = 0;
    order.products?.forEach((action) {
      count += action.productQuantity ?? 0;
    });
    return Card(
        color: Colors.white,
        child: GestureDetector(
            onTap: () => NavigatorUtil.goOrderDetailPage(context, order.id),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin:
                  EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                String id = XUtils.textOf(order.store?.id);
                                if (id.isNotEmpty) {
                                  Get.toNamed(XRouterPath.supplierDetail,
                                      parameters: {AppParameters.ID: id});
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(child: Text(
                                    XUtils.textOf(order.store?.storeName) +
                                        XUtils.textOf(order.store?.storeName),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: AppColors.COLOR_333333,
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppDimens.DIMENS_38.sp),
                                  )),
                                  Icon(Icons.keyboard_arrow_right)
                                ],
                              ))),
                      Text(XUtils.textOf(order.getStatusText()),
                          style: TextStyle(color: AppColors.COLOR_666666)),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: AppDimens.DIMENS_20.w),
                      height: AppDimens.DIMENS_200.r,
                      child: Row(
                        children: [
                          Expanded(
                            child: buildOrderProduct(order.products),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${order.priceTotal}",
                                style: XTextStyle.color_black_size_42,
                                textAlign: TextAlign.end,
                              ),
                              Text("${AppStrings.TOTAL.translated}: ${count}",
                                  style: XTextStyle.color_black_size_36,
                                  textAlign: TextAlign.end),
                            ],
                          )
                        ],
                      )),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                            visible: _orderViewModel.canDelete(order),
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil()
                                        .setWidth(AppDimens.DIMENS_30),
                                    right: ScreenUtil()
                                        .setWidth(AppDimens.DIMENS_20)),
                                height:
                                    ScreenUtil().setHeight(AppDimens.DIMENS_80),
                                child: TextButton(
                                  child: Text(
                                    AppStrings.DELETE.tr,
                                    style: XTextStyle.color_333333_size_42,
                                  ),
                                  onPressed: () => _showDialog(2, order.id),
                                ))),
                        Visibility(
                            visible: _orderViewModel.canCancel(order),
                            child: Container(
                                height:
                                    ScreenUtil().setHeight(AppDimens.DIMENS_80),
                                child: TextButton(
                                  child: Text(
                                    AppStrings.CANCEL.tr,
                                    style: XTextStyle.color_333333_size_42,
                                  ),
                                  onPressed: () => _showDialog(1, order.id!),
                                )))
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  _showDialog(int action, String? orderId) {
    if (orderId == null) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppStrings.TIPS.tr,
              style: XTextStyle.color_333333_size_48,
            ),
            content: Text(
              action == 1
                  ? AppStrings.MINE_ORDER_CANCEL_TIPS.tr
                  : AppStrings.MINE_ORDER_DELETE_TIPS.tr,
              style: XTextStyle.color_333333_size_42,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppStrings.CANCEL.tr,
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
                    AppStrings.CONFIRM.tr,
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

  Widget buildOrderProduct(List<OrderProduct>? products) {
    if (products == null || products.isEmpty) {
      return SizedBox.shrink();
    }
    int length = products.length;
    if (length == 1) {
      OrderProduct product = products[0];
      return Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedImageView(
                AppDimens.DIMENS_200.r,
                AppDimens.DIMENS_200.r,
                product.image,
                fit: BoxFit.contain,
              )),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(XUtils.textOf(product.productTitle),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: XTextStyle.color_333333_size_38),
        Visibility(
            visible: product.productVariations?.isNotEmpty == true,
            child: Padding(
                padding:
                EdgeInsets.only(top: AppDimens.DIMENS_10.h),
                child: Text(
                    XUtils.textOf(product.productVariations),
                    style: XTextStyle.color_999999_size_36)))
      ],
    ))
        ],
      );
    } else
      return ListView.separated(
          itemBuilder: (_, index) {
            OrderProduct product = products[index];
            return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedImageView(
                  AppDimens.DIMENS_200.r,
                  AppDimens.DIMENS_200.r,
                  product.image,
                  fit: BoxFit.contain,
                ));
          },
          separatorBuilder: (_, index) => SizedBox(
                width: AppDimens.DIMENS_10.w,
              ),
          scrollDirection: Axis.horizontal,
          itemCount: products.length);
  }
}
