import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/event/tab_select_event.dart';
import 'package:dealful_mall/ui/widgets/currency_selector_popop.dart';
import 'package:dealful_mall/ui/widgets/icon_text_arrow_widget.dart';
import 'package:dealful_mall/ui/widgets/language_selector_popop.dart';
import 'package:dealful_mall/ui/widgets/select_location_dialog.dart';
import 'package:dealful_mall/ui/widgets/text_row_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/cart_view_model.dart';
import 'package:dealful_mall/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.SETTINGS.translated),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(AppDimens.DIMENS_20.w),
          child: Column(
            children: [
              _otherWidget(),
              Padding(
                padding: EdgeInsets.only(top: AppDimens.DIMENS_30.h),
                child: _actionWidget(),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppDimens.DIMENS_30.h),
                child: _logoutWidget(),
              ),
            ],
          ),
        ));
  }

  Widget _otherWidget() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppDimens.DIMENS_10))),
      child: Column(
        children: [
          TextRowView(
              AppStrings.LOCATION.translated,
              child: Text(
                XUtils.textOf(XLocalization.obtainLocationStr()),
                style: XTextStyle.color_333333_size_42,
              ), callback: () {
            showDialog(
                context: context,
                builder: (_) => BottomSheet(
                    backgroundColor: Colors.white,
                    onClosing: () {},
                    builder: (sheetContext) {
                      return SelectLocationDialog(saveFunc: (countryEntity, stateEntity, cityEntity) {
                        XLocalization.saveLocation(
                            countryEntity, stateEntity, cityEntity);
                      },
                      );
                    })).then((onValue) {
              setState(() {});
            });
          }),
          TextRowView(
            AppStrings.CURRENCY.translated, child: CurrencySelectorPopop(),),
          TextRowView(
              AppStrings.LANGUAGE.translated, child: LanguageSelectorPopop()),
        ],
      ),
    );
  }

  Widget _actionWidget() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.DIMENS_10)),
      child: Column(
        children: [
          IconTextArrowView(AppImages.DELETE_ACCOUNT,
            AppStrings.DELETE_ACCOUNT.translated, (){
              BrnMiddleInputDialog(
                  title: AppStrings.DELETE_ACCOUNT.translated,
                  message: AppStrings.DELETE_ACCOUNT_EXP.translated,
                  hintText: AppStrings.PASSWORD_PLACEHOLDER.translated,
                  cancelText: AppStrings.CANCEL.translated,
                  confirmText: AppStrings.OK.translated,
                  dismissOnActionsTap: false,
                  autoFocus: true,
                  maxLines: 1,
                  maxLength: 50,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  onConfirm: (value) {
                    HttpUtil.fetchApiStore().deleteMyAccount(value)
                        .then((onValue) {
                      if(onValue.isSuccess == true) {
                        Navigator.pop(context);
                        XUtils.showToast(onValue.msg);
                        clearUserData();
                        Get.back();
                      } else {
                        XUtils.showError(onValue.msg);
                      }
                    },onError: (error) {
                       XUtils.showError(XUtils.textOf(error));
                    });
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  }).show(context);
            },),
        ],
      ),
    );
  }


  Widget _logoutWidget() {
    return SizedBox(
        width: double.infinity,
        height: AppDimens.DIMENS_120.h,
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.DIMENS_30)))),
          onPressed: () => _logout(),
          child: Text(AppStrings.LOGOUT.translated,
              style: XTextStyle.color_ffffff_size_48),
        ));
  }

  _logout() {
    BrnDialogManager.showConfirmDialog(context,
        message: AppStrings.CONFIRM_ACTION.translated,
        cancel: AppStrings.CANCEL.translated,
        confirm: AppStrings.OK.translated, onCancel: () {
          Navigator.pop(context);
        }, onConfirm: () {
          Navigator.pop(context);
          clearUserData();
          Get.back();
        });
  }

  void clearUserData() {
    SharedPreferencesUtil.getInstance()
        .remove(AppStrings.TOKEN)
        .then((value) {
      XLocalization.clear();
      if (value) {
        UserViewModel userViewModel = Get.find();
        userViewModel.refreshData();
        CartViewModel cartViewModel = Get.find();
        cartViewModel.cartNum.value = 0;
        tabSelectBus.fire(TabSelectEvent(0));
      }
    });
  }
}
