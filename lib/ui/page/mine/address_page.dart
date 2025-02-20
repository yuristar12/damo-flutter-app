import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/refresh_state_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/address_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddressViewPage extends StatefulWidget {
  @override
  _AddressViewPageState createState() => _AddressViewPageState();
}

class _AddressViewPageState extends State<AddressViewPage> {
  AddressViewModel _addressViewModel = AddressViewModel();
  RefreshController _refreshController = RefreshController();
  int type = 0;

  @override
  void initState() {
    super.initState();
    _addressViewModel.queryAddressData();
    type =
        int.tryParse(XUtils.textOf(Get.parameters[AppParameters.TYPE])) ?? type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.ADDRESS.translated),
          centerTitle: true,
          actions: <Widget>[
            InkWell(
                child: Container(
              margin: EdgeInsets.only(right: AppDimens.DIMENS_10.w),
              alignment: Alignment.center,
              child: InkWell(
                onTap: () => _goAddressEdit(""),
                child: Text(
                  AppStrings.ADD_ADDRESS.translated,
                  style: TextStyle(color: AppColors.COLOR_000000),
                ),
              ),
            ))
          ],
        ),
        body: ChangeNotifierProvider<AddressViewModel>(
            create: (context) => _addressViewModel,
            child: Consumer<AddressViewModel>(builder: (context, model, child) {
              RefreshStateUtil.getInstance()
                  .stopRefreshOrLoadMore(_refreshController);
              return SmartRefresher(
                  header: WaterDropMaterialHeader(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(),
                  child: _initView(model));
            })));
  }

  void _onRefresh() {
    _addressViewModel.queryAddressData();
  }

  Widget _initView(AddressViewModel addressViewModel) {
    if (addressViewModel.pageState == PageState.hasData) {
      return _contentView(addressViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        addressViewModel, _onRefresh);
  }

  Widget _contentView(AddressViewModel addressViewModel) {
    return ListView.separated(
        itemCount: addressViewModel.address.length,
        separatorBuilder: (_,index) =>SizedBox(height: AppDimens.DIMENS_20.h,),
        itemBuilder: (BuildContext context, int index) {
          return _addressItemView(addressViewModel.address[index]);
        });
  }

  Widget _addressItemView(AddressEntity addressData) {
    bool shiping = addressData.addressType == "shipping";
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w, ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_30.h),
        child: InkWell(
          highlightColor: AppColors.COLOR_FFFFFF,
          splashColor: AppColors.COLOR_FFFFFF,
          onTap: () => _goFillInOrder(addressData),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: AppDimens.DIMENS_30.w,
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "${addressData.name}",
                        style: XTextStyle.color_333333_size_42,
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: AppDimens.DIMENS_30.w),
                        child: Text(
                          XUtils.textOf(addressData.phoneNumber),
                          style: XTextStyle.color_999999_size_42,
                        ),),
                      Visibility(
                          visible: addressData.isMain == true,
                          child: Container(
                            margin:
                                EdgeInsets.only(left: AppDimens.DIMENS_20.w),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(
                                    AppDimens.DIMENS_12.r)),
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.DIMENS_6.w),
                            child: Text(
                              AppStrings.DEFAULT.translated,
                              overflow: TextOverflow.ellipsis,
                              // 显示不完，就在后面显示点点
                              style: XTextStyle.color_ff5722_size_36,
                            ),
                          ))
                    ],
                  ),
                  Text(
                    "${XUtils.textOf(addressData.country)} ${XUtils.textOf(addressData.state)} ${XUtils.textOf(addressData.city)}${XUtils.textOf(addressData.address)}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
                    style: XTextStyle.color_333333_size_42,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: shiping
                                ? AppColors.COLOR_003399
                                : AppColors.COLOR_000000),
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      XUtils.textOf(addressData.showAddressType),
                      overflow: TextOverflow.ellipsis, // 显示不完，就在后面显示点点
                      style: shiping
                          ? XTextStyle.color_003399_size_36
                          : XTextStyle.color_black_size_36,
                    ),
                  )
                ],
              )),
              InkWell(
                  highlightColor: AppColors.COLOR_FFFFFF,
                  splashColor: AppColors.COLOR_FFFFFF,
                  onTap: () => _goAddressEdit(addressData.id),
                  child: Container(
                    width: AppDimens.DIMENS_180.w,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                        shape: Border(
                            left: BorderSide(
                                color: AppColors.COLOR_999999,
                                width: AppDimens.DIMENS_1.w))),
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                    child: Text(
                      AppStrings.EDIT.translated,
                      style: XTextStyle.color_999999_size_42,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _goFillInOrder(AddressEntity addressData) {
    if (type == 1) {
      Navigator.pop(context, addressData);
    }
  }

  _goAddressEdit(String? addressId) {
    if (addressId == null) {
      return;
    }
    NavigatorUtil.goAddressEdit(context, addressId)?.then((bool) {
      _addressViewModel.queryAddressData();
    });
  }
}
