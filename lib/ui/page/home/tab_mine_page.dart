import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/divider_line.dart';
import 'package:dealful_mall/ui/widgets/icon_text_arrow_widget.dart';
import 'package:dealful_mall/ui/widgets/waterfull_product_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/cart_view_model.dart';
import 'package:dealful_mall/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TabMinePage extends StatefulWidget {
  @override
  _TabMinePageState createState() => _TabMinePageState();
}

class _TabMinePageState extends State<TabMinePage> {

  TextStyle numStyle = TextStyle(color: AppColors.COLOR_333333, fontSize: 22, fontWeight: FontWeight.bold);
  TextStyle textStyle = TextStyle(color: AppColors.COLOR_333333, fontSize: 14, fontWeight: FontWeight.bold);
  @override
  void initState() {
    super.initState();
    UserViewModel userViewModel = Get.find();
    userViewModel.refreshData();
    XLocalization.listen((data) {
      UserViewModel userViewModel = Get.find();
      userViewModel.refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _contentWidget();
  }

  Widget _contentWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>.value(value: Get.find()),
        ChangeNotifierProvider<CartViewModel>.value(value: Get.find())
      ],
      child: Consumer<UserViewModel>(
          builder: (BuildContext context, UserViewModel model, Widget? child) {
        return SingleChildScrollView(
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.only(left: 30.w, right: 30.w, top: MediaQuery.of(context).padding.top, bottom: 20.h),
                    decoration:  BoxDecoration(
                      // color: Color(0xFFD33400),
                      image: DecorationImage(
                        image: ExactAssetImage('images/person_nav_bg.jpg'),
                        
                        // NetworkImage('http://dingfoxweb.oss-cn-hangzhou.aliyuncs.com/1353057/DOC/2024/12/1874040229181112320.jpg'),
                        fit: BoxFit.fill,
                      )
                    ),
                    child: Column(
                      children: [
                        _settingWidget(),
                         _headWidget(model),
                        Container(
                          margin: EdgeInsets.only(top: 40.h),
                          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                             
                              _accountWidget(model),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h,),
                        _orderWidget(),
                      ],
                    )
                  ),
                  // _userDataWidget(model),
                 
                  // _otherWidget(),
                  //       _recommendWidget(model),
                  Padding(
                    padding: EdgeInsets.symmetric(
                    vertical: AppDimens.DIMENS_30.h,
                    horizontal: AppDimens.DIMENS_30.w),
                    child: Column(
                      children: [
                        _otherWidget(),
                        _recommendWidget(model),
                      ],
                    ),
                  )
                ]));
      }),
    );
  }

  Widget _accountWidget (UserViewModel model) {
    return Container(
      // margin: EdgeInsets.only(top: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(XUtils.textOf(model.points), style: numStyle,),
                Text(XUtils.textOf(AppStrings.POINTS.translated), style: textStyle,)
              ],
            )
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(XUtils.textOf(model.coupon), style: numStyle,),
                Text(XUtils.textOf(AppStrings.MY_COUPONS.translated), style: textStyle,)
              ],
            )
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(XUtils.textOf(model.balance), style: numStyle,),
                Text(XUtils.textOf(AppStrings.WALLET_BALANCE.translated), style: textStyle,)
              ],
            )
          )
        ],
      ),
    );
  }

  Widget _settingWidget() {
    return         Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 70.h,
              padding: EdgeInsets.only(right: 10.h, left: 30.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
              ),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(XRouterPath.settings);
                },
                child: Row(
                  children: [
                    CachedImageView(
                      AppDimens.DIMENS_60.r,
                      AppDimens.DIMENS_60.r,
                      XLocalization.getLanguageEntity()?.flagPath,
                      fit: BoxFit.fitWidth,
                    ),
                    Obx(() => Visibility(
                        visible:
                            XLocalization.currencyEntity?.showCode?.isNotEmpty ==
                                true,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          color: Colors.black,
                          width: AppDimens.DIMENS_3.r,
                          height: AppDimens.DIMENS_42.r,
                        ))),
                    Obx(() => Text(
                        XUtils.textOf(XLocalization.currencyEntity?.showCode),
                        style: XTextStyle.color_black_size_42)),
                    Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Image.asset(
                          AppImages.ICON_SETTING,
                          fit: BoxFit.fitHeight,
                          color: Colors.black,
                          height: AppDimens.DIMENS_60.r,
                        ))
                  ],
                ),
              ),
            ),
          ],
        );
  }

  Widget _headWidget(UserViewModel model) {
    return Column(
      children: [
        SizedBox(height: 10.h,),
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: AppDimens.DIMENS_180.w,
            height: AppDimens.DIMENS_180.w,
            margin: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
            child: model.pictureUrl?.isNotEmpty == true ? CircleAvatar(
              radius: AppDimens.DIMENS_90.w,
              backgroundImage: buildImage(model.pictureUrl),
            ):ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.DIMENS_90.w),
              child: Image.asset('images/default_avatar.png'),
            ),
          ),
          SizedBox(
              height: AppDimens.DIMENS_180.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.userName ?? "--",
                      style: TextStyle(
                         color: AppColors.COLOR_FFFFFF,
                         fontWeight: FontWeight.bold,
                        fontSize: 20
                      )),
                  // Text(
                  //   model.email ?? "--",
                  //   style: TextStyle(
                  //      color: AppColors.COLOR_333333,
                  //       fontSize: ScreenUtil().setSp(AppDimens.DIMENS_36)
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30.w)
                    ),
                    child: Row(
                      children: [
                        model.userMember?['MemberImageUrl'] != null ? Container(
                          margin: EdgeInsets.only(right: 10.w),
                          width: AppDimens.DIMENS_40.w,
                          height: AppDimens.DIMENS_40.w,
                          child: CachedImageView(
                            AppDimens.DIMENS_40.w,
                            AppDimens.DIMENS_40.w,
                            model.userMember?['MemberImageUrl'],
                            fit: BoxFit.fitWidth,
                          ),
                        ) : SizedBox.shrink(),
                        Text(
                          model.userMember?['MemberName'] ?? "--",
                          style: TextStyle(
                            color: AppColors.COLOR_FFFFFF,
                            fontSize: ScreenUtil().setSp(AppDimens.DIMENS_34) 
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
          Spacer(),
        ])
      ],
    );
  }

  Widget _orderWidget() {
    return Container(
      // margin: EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_10)),
      child: Container(
         decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
        
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: AppDimens.DIMENS_60.w, right: AppDimens.DIMENS_60.w),
              alignment: Alignment.centerLeft,
              height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
              child: Row(
                children: [
                  Text(AppStrings.ORDERS.translated,
                      style: XTextStyle.color_333333_size_42),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            splashColor: AppColors.COLOR_FFFFFF,
                            highlightColor: AppColors.COLOR_FFFFFF,
                            onTap: () => _goOrderPage(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(AppStrings.VIEW_ALL.translated,
                                    style: XTextStyle.color_999999_size_36),
                                Image.asset(
                                  AppImages.ARROW_RIGHT,
                                  width: ScreenUtil()
                                      .setWidth(AppDimens.DIMENS_30),
                                  height: ScreenUtil()
                                      .setWidth(AppDimens.DIMENS_30),
                                ),
                              ],
                            ),
                          )))
                ],
              ),
            ),
            DividerLineView(),
            Container(
              margin: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_20.h),
              height: ScreenUtil().setHeight(AppDimens.DIMENS_190),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => _goOrderPage(1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.TO_BE_PAID,
                              width:
                                  ScreenUtil().setWidth(AppDimens.DIMENS_100),
                              height:
                                  ScreenUtil().setWidth(AppDimens.DIMENS_100),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil()
                                        .setHeight(AppDimens.DIMENS_20))),
                            Text(AppStrings.AWAITING_PAYMENT.translated,
                                textAlign: TextAlign.center,
                                style: XTextStyle.color_333333_size_36),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => _goOrderPage(2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.RECEIVED,
                              width:
                                  ScreenUtil().setWidth(AppDimens.DIMENS_100),
                              height:
                                  ScreenUtil().setWidth(AppDimens.DIMENS_100),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil()
                                        .setHeight(AppDimens.DIMENS_20))),
                            Text(AppStrings.TO_BE_RECEIVED.translated,
                                textAlign: TextAlign.center,
                                style: XTextStyle.color_333333_size_36),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => _goOrderPage(3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.TO_BE_EVALUATED,
                              width:
                                  ScreenUtil().setWidth(AppDimens.DIMENS_100),
                              height:
                                  ScreenUtil().setWidth(AppDimens.DIMENS_100),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil()
                                        .setHeight(AppDimens.DIMENS_20))),
                            Text(AppStrings.COMPLETED.translated,
                                textAlign: TextAlign.center,
                                style: XTextStyle.color_333333_size_36),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => _goOrderPage(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.RETURN_GOOD,
                              width:
                                  ScreenUtil().setWidth(AppDimens.DIMENS_100),
                              height:
                                  ScreenUtil().setWidth(AppDimens.DIMENS_100),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil()
                                        .setHeight(AppDimens.DIMENS_20))),
                            Text(AppStrings.REFUND.translated,
                                textAlign: TextAlign.center,
                                style: XTextStyle.color_333333_size_36),
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _otherWidget() {
    return Container(
        // margin: EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_10)),
        child: Container(
             decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
            child: Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(AppDimens.DIMENS_20),
                  right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
              child: Column(
                children: [
                  IconTextArrowView(
                      AppImages.LOCATION,
                      AppStrings.SHIPPING_ADDRESS.translated,
                      () => NavigatorUtil.goAddress(context, 0)),
                  DividerLineView(),
                  IconTextArrowView(
                      AppImages.WISHLIST, AppStrings.WISHLIST.translated, () {
                    Get.toNamed(XRouterPath.wishlist);
                  }),
                  DividerLineView(),
                  IconTextArrowView(
                      AppImages.INQUIRY, AppStrings.QUOTE_REQUESTS.translated,
                      () {
                    Get.toNamed(XRouterPath.quoteRequests);
                    ;
                  }),
                  DividerLineView(),
                   IconTextArrowView(
                      AppImages.ICON_STORE, AppStrings.FOLLOWING.translated,
                      () {
                    Get.toNamed(XRouterPath.followStore);
                    ;
                  }),
                  DividerLineView(),
                  IconTextArrowView(
                      AppImages.BE_SUPPLIER, AppStrings.ADD_SUPPLIER.translated,
                          () {
                        Get.toNamed(XRouterPath.beSupplier);
                      }),
                  DividerLineView(),
                  IconTextArrowView(AppImages.HELP_CENTER,
                      AppStrings.HELP_CENTER.translated, () => {}),
                ],
              ),
            )));
  }

  _goOrderPage(int initIndex) {
    NavigatorUtil.goOrderPage(context, initIndex);
  }

  ImageProvider? buildImage(String? pictureUrl) {
    if (pictureUrl?.isNotEmpty == true) {
      return NetworkImage(pictureUrl!);
    }
    return AssetImage("images/default.png");
  }

  Widget _recommendWidget(UserViewModel model) {
    return Obx(() {
      if (model.productEntitiesX.isNotEmpty) {
        double space = ScreenUtil().screenWidth - AppDimens.DIMENS_30.w * 3;
        double cardWidth = space / 2;
        return Column(
          children: [
            SizedBox(height: AppDimens.DIMENS_10.h,),
            Text(AppStrings.FOR_YOU_INDEX.translated,
                style: XTextStyle.color_333333_size_52_bold),
            MasonryGridView.count(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: AppDimens.DIMENS_6.h, left: 6.h, right: 6.h),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: AppDimens.DIMENS_20.h,
              itemCount: model.productEntitiesX.length,
              crossAxisSpacing: AppDimens.DIMENS_30.w,
              itemBuilder: (context, index) {
                ProductEntity entity = model.productEntitiesX[index];
                return WaterfullProductWidget(entity,
                    (value) => _goGoodsDetail(context, value), cardWidth);
              },
            )
          ],
        );
      }
      return SizedBox.shrink();
    });
  }

  _goGoodsDetail(BuildContext context, String goodsId) {
    NavigatorUtil.goGoodsDetails(context, goodsId);
  }
}
