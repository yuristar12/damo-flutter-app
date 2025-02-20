import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/ui/widgets/fm_icon.dart';
import 'package:dealful_mall/ui/widgets/language_selector_popop.dart';
import 'package:dealful_mall/ui/widgets/x_text.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final RxBool agreedX = RxBool(false);
  @override
  void initState() {
    super.initState();
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.USERNAME)
        .then((result) {
      if (result?.isNotEmpty == true) {
        setState(() {
          _accountController.text = result!;
        });
      }
    });
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.PASSWORD)
        .then((result) {
      if (result?.isNotEmpty == true) {
        setState(() {
          _passWordController.text = result!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.LOGIN.translated),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(AppDimens.DIMENS_60),
                right: ScreenUtil().setWidth(AppDimens.DIMENS_60),
                top: ScreenUtil().setWidth(AppDimens.DIMENS_160)),
            child: Form(
                key: _loginKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.WELCOME,
                      style: XTextStyle.color_333333_size_60,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
                    Text(
                      "",
                      style: XTextStyle.color_999999_size_36,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(AppDimens.DIMENS_100))),
                    TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validatorAccount,
                      decoration: InputDecoration(
                        icon: Icon(
                          FMICon.ACCOUNT,
                          color: AppColors.primaryColor,
                          size: ScreenUtil().setWidth(AppDimens.DIMENS_80),
                        ),
                        hintStyle: XTextStyle.color_999999_size_36,
                        labelStyle: XTextStyle.color_333333_size_42,
                        labelText: AppStrings.USERNAME.translated,
                      ),
                      controller: _accountController,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
                    TextFormField(
                      maxLines: 1,
                      obscureText: true,
                      validator: _validatorPassWord,
                      decoration: InputDecoration(
                        icon: Icon(
                          FMICon.PASS_WORD,
                          color: AppColors.primaryColor,
                          size: AppDimens.DIMENS_80.w,
                        ),
                        hintStyle: XTextStyle.color_999999_size_36,
                        labelStyle: XTextStyle.color_333333_size_42,
                        labelText: AppStrings.PASSWORD.translated,
                      ),
                      controller: _passWordController,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: AppDimens.DIMENS_30.h,
                          left: AppDimens.DIMENS_40.w,
                          bottom: AppDimens.DIMENS_20.h),
                      child: LanguageSelectorPopop(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: AppDimens.DIMENS_40.h,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Obx(() => Checkbox(
                              value: agreedX.value,
                              activeColor: AppColors.primaryColor,
                              onChanged: (value) {
                                agreedX.value = value == true;
                              })),
                          Text(AppStrings.READ_AGREE_TO.translated,
                              style: XTextStyle.color_333333_size_36),
                          GestureDetector(
                            onTap: () {
                              NavigatorUtil.goWebView(
                                  "https://simator.com/infomation/terms-conditions?Id=15");
                            },
                            child: Text(" ${AppStrings.TERMS_CONDITIONS.translated}",
                                style: XTextStyle.color_blue_size_36),
                          ),
                          Text(
                            " , ",
                            style: XTextStyle.color_333333_size_36,
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigatorUtil.goWebView(
                                  "https://simator.com/infomation/Privacy-Policy?Id=6");
                            },
                            child: Text(AppStrings.PRIVACY_POLICY.translated,
                                style: XTextStyle.color_blue_size_36),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: AppDimens.DIMENS_120.h,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                AppColors.primaryColor.withAlpha(220)),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimens.DIMENS_30))))),
                        onPressed: () {
                          _login(context);
                        },
                        child: XText(
                          AppStrings.LOGIN.translated,
                          color: Colors.white,
                          fontSize: 50.sp,
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(
                            top: AppDimens.DIMENS_42.h,
                            right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
                        child: InkWell(
                          onTap: () {
                            NavigatorUtil.goRegister(context);
                          },
                          child: Text(
                            AppStrings.REGISTER.translated,
                            style: XTextStyle.color_333333_size_42,
                          ),
                        ))
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    FocusScope.of(context).unfocus();
    if(agreedX.isFalse) {
      XUtils.showToast(AppStrings.AGREE_POLICY.translated);
      return;
    }
    if (_loginKey.currentState!.validate()) {
      EasyLoading.show();
      String lang = Get.locale!.languageCode == "en" ? "en" : "Cn";
      String account = _accountController.text;
      String password = _passWordController.text;
      HttpUtil.fetchApiStore().loginClient(lang, account, password).apiCallback(
          (token) {
        EasyLoading.dismiss();
        SharedPreferencesUtil.getInstance()
            .setString(AppStrings.TOKEN, token as String);
        SharedPreferencesUtil.getInstance()
            .setString(AppStrings.USERNAME, account);
        SharedPreferencesUtil.getInstance()
            .setString(AppStrings.PASSWORD, password);
        UserViewModel userViewModel = Get.find();
        userViewModel.refreshData();
        Get.offAllNamed(XRouterPath.home);
      }, (errorMsg) {
        EasyLoading.dismiss();
        EasyLoading.showError(errorMsg);
      });
    }
  }

  String? _validatorAccount(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.ENTER_EMAIL_TIP.translated;
    }
    return null;
  }

  String? _validatorPassWord(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.ENTER_PASSWORD_TIP.translated;
    }
    return null;
  }
}
