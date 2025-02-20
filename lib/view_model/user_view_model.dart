import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/homepage_data.dart';
import 'package:dealful_mall/model/location_entity.dart';
import 'package:dealful_mall/model/order_detail_entity.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/user_info.dart';
import 'package:dealful_mall/service/mine_service.dart';
import 'package:dealful_mall/ui/widgets/waterfull_product_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class UserViewModel extends BaseViewModel {
  final RxList<ProductEntity> productEntitiesX = RxList();
  MineService _mineService = MineService();
  bool _showTitle = false;
  String? _pictureUrl;
  String? _userName;
  int? _collectionNumber = 0;
  int? _footPrintfNumber = 0;
  int? _couponNumber = 0;
  int _page = 1;
  int _limit = 20;
  bool _isFirst=true;
  static UserInfo? _userInfo;

  bool get showTitle => _showTitle;
  static UserInfo? get userInfo => _userInfo;

  String? get pictureUrl => _pictureUrl;

  String? get userName => _userName;
  String? get email => _userInfo?.email;
  String? get points => _userInfo?.points;
  String? get coupon => _userInfo?.coupon;
  String? get balance => _userInfo?.balance;
  bool? get carVehicleSelection => _userInfo?.carVehicleSelection;
  bool? get supplierSearch => _userInfo?.supplierSearch;
  Map<String, dynamic>? get userMember => _userInfo?.userMember;
  int? get footPrintfNumber => _footPrintfNumber;

  int? get couponNumber => _couponNumber;

  int? get collectionNumber => _collectionNumber;
  String? text;

  bool get isFirst => _isFirst;

  refreshData() async {
    String? token;
    await SharedPreferencesUtil.getInstance()
        .getString(AppStrings.TOKEN)
        .then((value) => token = value);
    if (token != null && token!.isNotEmpty) {
      HttpUtil.fetchApiStore().getOperatorInfo()
        .then((onValue) {
          print('onValueonValueonValue$onValue');
         if(onValue.data != null) {
           _userInfo = onValue.data!;
           _userName = _userInfo?.username ?? "";
           _pictureUrl = _userInfo?.avatar ?? '';
           notifyListeners();
         }
      });
      // await _queryCoupon();
      // await _queryFootPrint();
      // await _queryCollection();
      notifyListeners();
      HttpUtil.fetchApiStore().getProductsListByUser().apiCallback(
          (successData){
            if(successData is List<ProductEntity>) {
              productEntitiesX.assignAll(successData);
            }
          }
      ,(error){
            productEntitiesX.clear();
      });
    }
  }

  Widget buildRecommendWidget() {
    UserViewModel model = this;
    return Obx(() {
      if (model.productEntitiesX.isNotEmpty) {
        double space = ScreenUtil().screenWidth - AppDimens.DIMENS_30.w * 3;
        double cardWidth = space / 2;
        return MasonryGridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: AppDimens.DIMENS_6.h),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: AppDimens.DIMENS_20.h,
          itemCount: model.productEntitiesX.length,
          crossAxisSpacing: AppDimens.DIMENS_30.w,
          itemBuilder: (context, index) {
            ProductEntity entity = model.productEntitiesX[index];
            return WaterfullProductWidget(entity, (value) {
              NavigatorUtil.goGoodsDetails(context, value);
            }, cardWidth);
          },
        );
      }
      return SizedBox.shrink();
    });
  }

  _queryCoupon() async {
    var couponParameters = {
      AppParameters.PAGE: _page,
      AppParameters.LIMIT: _limit
    };
    await _mineService
        .queryCoupon(couponParameters)
        .then((value) => _couponNumber = value.data!.total);
  }

  _queryCollection() async {
    var collectionParameters = {
      AppParameters.TYPE: 0,
      AppParameters.PAGE: 1,
      AppParameters.LIMIT: 1000
    };

    await _mineService
        .queryCollect(collectionParameters)
        .then((value) => _collectionNumber = value.data!.total);
  }

  _queryFootPrint() async {
    var footPrintParameters = {
      AppParameters.PAGE: _page,
      AppParameters.LIMIT: _limit
    };
    await _mineService
        .queryFootPrint(footPrintParameters)
        .then((value) => _footPrintfNumber = value.data.total);
  }

  collectionDataChange() {
    // _queryCollection();
    notifyListeners();
  }

  footPrintDataChange() {
    _queryFootPrint();
  }

  setShowTitle(bool value) {
    _showTitle = value;
    notifyListeners();
  }

  setPersonInformation(String? pictureUrl, String? userName) {
    _pictureUrl = pictureUrl;
    _userName = userName;
  }
}
