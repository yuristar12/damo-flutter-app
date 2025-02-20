import 'package:dealful_mall/utils/x_router.dart';
import 'package:flutter/material.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SubmitSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.SUBMIT_SUCCESS.tr),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.COLOR_FFFFFF,
        alignment: Alignment.center,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_200))),
            Image.asset(
              AppImages.SUCCESS,
              width: ScreenUtil().setWidth(AppDimens.DIMENS_300),
              height: ScreenUtil().setWidth(AppDimens.DIMENS_300),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_60))),
            Text(
              AppStrings.SUBMIT_SUCCESS.tr,
              style: XTextStyle.color_333333_size_42,
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_200))),
            Row(
              children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                            right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColors.COLOR_FFFFFF),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: AppColors.COLOR_DBDBDB),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                              AppDimens.DIMENS_30))))),
                          child: Text(
                            AppStrings.BACK_HOME.tr,
                            style: XTextStyle.color_333333_size_42,
                          ),
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                              context, XRouterPath.home, (route) => false),
                        ))),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                            right: ScreenUtil().setWidth(AppDimens.DIMENS_20)),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              backgroundColor: WidgetStatePropertyAll(
                                  AppColors.COLOR_FFFFFF),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: AppColors.COLOR_DBDBDB),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                              AppDimens.DIMENS_30))))),
                          child: Text(
                            AppStrings.CHECK_BILL.tr,
                            style: XTextStyle.color_333333_size_42,
                          ),
                          onPressed: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(XRouterPath.orderPage,
                                  ModalRoute.withName(XRouterPath.home)),
                        )))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
