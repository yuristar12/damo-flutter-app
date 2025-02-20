import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/ui/widgets/fm_icon.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _introduceUserIdController = TextEditingController();
  final RxBool beSupplierX = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.COLOR_FFFFFF,
      appBar: AppBar(
        title: Text(AppStrings.REGISTER.translated),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(AppDimens.DIMENS_60),
                right: ScreenUtil().setWidth(AppDimens.DIMENS_60),
                top: ScreenUtil().setWidth(AppDimens.DIMENS_160)),
            child: Form(
                key: _registerKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.WELCOME,
                      style: XTextStyle.color_333333_size_60,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: AppDimens.DIMENS_60.h)),
                    TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validatorEmail,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: AppColors.COLOR_999999,
                          size: ScreenUtil().setWidth(AppDimens.DIMENS_80),
                        ),
                        hintText: getEmailHint(),
                        hintStyle: XTextStyle.color_999999_size_36,
                        labelStyle: XTextStyle.color_333333_size_42,
                        labelText: AppStrings.EMAIL_ADDRESS.translated,
                      ),
                      controller: _emailController,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
                    TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      validator: _validatorPassword,
                      decoration: InputDecoration(
                        icon: Icon(
                          FMICon.PASS_WORD,
                          color: AppColors.COLOR_999999,
                          size: ScreenUtil().setWidth(AppDimens.DIMENS_80),
                        ),
                        hintText: "${AppStrings.INPUT_HINT.translated}${AppStrings.PASSWORD_PLACEHOLDER.translated}",
                        hintStyle: XTextStyle.color_999999_size_36,
                        labelStyle: XTextStyle.color_333333_size_42,
                        labelText: AppStrings.PASSWORD.translated,
                      ),
                      controller: _passwordController,
                    ),
                    TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      validator: _validatorConfirmPassword,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.password_sharp,
                          color: AppColors.COLOR_999999,
                          size: ScreenUtil().setWidth(AppDimens.DIMENS_80),
                        ),
                        hintText: "${AppStrings.INPUT_HINT.translated}${AppStrings.CONFIRM_PASSWORD.translated}",
                        hintStyle: XTextStyle.color_999999_size_36,
                        labelStyle: XTextStyle.color_333333_size_42,
                        labelText: AppStrings.CONFIRM_PASSWORD.translated,
                      ),
                      controller: _confirmPasswordController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                      child: TextFormField(
                        maxLines: 1,
                        validator: _validatorNotEmpty,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.account_circle,
                            color: AppColors.COLOR_999999,
                            size: AppDimens.DIMENS_80.w,
                          ),
                          hintText: "${AppStrings.INPUT_HINT.translated}${AppStrings.FIRST_NAME.translated}",
                          hintStyle: XTextStyle.color_999999_size_36,
                          labelStyle: XTextStyle.color_333333_size_42,
                          labelText: AppStrings.FIRST_NAME.translated,
                        ),
                        controller: _firstNameController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                      child: TextFormField(
                        maxLines: 1,
                        validator: _validatorNotEmpty,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.account_circle,
                            color: AppColors.COLOR_999999,
                            size: AppDimens.DIMENS_80.w,
                          ),
                          hintText: "${AppStrings.INPUT_HINT.translated}${AppStrings.LAST_NAME.translated}",
                          hintStyle: XTextStyle.color_999999_size_36,
                          labelStyle: XTextStyle.color_333333_size_42,
                          labelText: AppStrings.LAST_NAME.translated,
                        ),
                        controller: _lastNameController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                      child: TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.vpn_key,
                            color: AppColors.COLOR_999999,
                            size: AppDimens.DIMENS_80.w,
                          ),
                          hintText: "${AppStrings.INPUT_HINT.translated}${AppStrings.INTRODUCE_USERID.translated}",
                          hintStyle: XTextStyle.color_999999_size_36,
                          labelStyle: XTextStyle.color_333333_size_42,
                          labelText: AppStrings.INTRODUCE_USERID.translated,
                        ),
                        controller: _introduceUserIdController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: AppDimens.DIMENS_80.h),
                      child: SizedBox(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColors.primaryColor.withAlpha(200)),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(AppDimens.DIMENS_30))))),
                          onPressed: () {
                            _register(context);
                          },
                          child: Text(
                            AppStrings.REGISTER.translated,
                            style: XTextStyle.color_ffffff_size_48,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
      ),
      // persistentFooterButtons: [
      //   BrnRadioInputFormItem(
      //     themeData: BrnFormItemConfig(
      //         formPadding: EdgeInsets.symmetric(vertical: AppDimens.DIMENS_30.r)
      //     ),
      //     title: AppStrings.ROLES.translated,
      //     options: [
      //       AppStrings.SELLER.translated,
      //       AppStrings.USER.translated,
      //     ],
      //     value: AppStrings.USER.translated,
      //     onChanged: (oldValue, newValue) {
      //       beSupplierX.value = newValue == AppStrings.SELLER.translated;
      //     },
      //   ),
      // ],
    );
  }

  void _register(BuildContext context) {
    if (_registerKey.currentState!.validate()) {
      EasyLoading.show();
      Map<String, dynamic> map = {
        "Email": _emailController.text,
        "Password": _passwordController.text,
        "ConfirmPassword": _confirmPasswordController.text,
        "FirstName": _firstNameController.text,
        "LastName": _lastNameController.text,
        "RoleId": "3"
      };
      if(_introduceUserIdController.text.isNotEmpty) {
        map["IntroduceUserId"] = _introduceUserIdController.text;
      }
      HttpUtil.fetchApiStore().register(map).apiCallback((successMsg) {
        EasyLoading.dismiss();
        XUtils.showToast(AppStrings.MSG_REGISTER_SUCCESS.translated);
        Get.back();
      }, (errorMsg) {
        EasyLoading.dismiss();
        EasyLoading.showError(errorMsg);
      });
    }
  }

  String? _validatorEmail(String? value) {
    if (value == null || !value.isEmail) {
      return getEmailHint();
    }
    return null;
  }

  String getEmailHint() {
    return AppStrings.ENTER_EMAIL_TIP.translated;
  }

  String? _validatorPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.ENTER_PASSWORD_TIP.translated;
    }
    return null;
  }


  String? _validatorConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.REQUIRED.translated;
    }
    if(value != _passwordController.text) {
      return AppStrings.DIFF_PASSWORD.translated;
    }
    return null;
  }

  String? _validatorNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.REQUIRED.translated;
    }
    return null;
  }
}
