import 'package:flutter/material.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextRowView extends StatelessWidget {
  final title;
  final Widget? child;
  final VoidCallback? callback;

  TextRowView(
    this.title, {this.child,this.callback}
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        height: AppDimens.DIMENS_120.h,
        width: double.infinity,
        child: InkWell(
          highlightColor: AppColors.COLOR_FFFFFF,
          splashColor: AppColors.COLOR_FFFFFF,
          onTap: callback,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w,),
                child: Text(
                    title,
                    style:XTextStyle.color_333333_size_42
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: child??SizedBox.shrink(),
                ),
              ),
              SizedBox(width: AppDimens.DIMENS_30.w,)
            ],
          ),
        ));
  }
}
