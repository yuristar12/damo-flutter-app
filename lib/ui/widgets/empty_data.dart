import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyDataView extends StatelessWidget {

  EmptyDataView();

  @override
  Widget build(BuildContext context) {

    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                AppImages.NO_DATA,
                height: ScreenUtil().setWidth(AppDimens.DIMENS_200),
                width: ScreenUtil().setWidth(AppDimens.DIMENS_200),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(AppDimens.DIMENS_20)),
              ),
              Text(
                "No data",
                style: XTextStyle.color_primary_size_42
              )
            ],
          ),
        ),
    );
  }
}
