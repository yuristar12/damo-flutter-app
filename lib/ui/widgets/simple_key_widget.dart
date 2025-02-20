import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimpleKeyWidget extends StatelessWidget{
  final KeyEntity? keyEntity;

  SimpleKeyWidget(this.keyEntity);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.COLOR_FFFFFF,
      padding: EdgeInsets.all(AppDimens.DIMENS_30.r),
      child: Text(XUtils.textOf(keyEntity?.title), style: XTextStyle.color_333333_size_48,),
    );
  }

}