import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnNumberChange(int number);

class CartNumberView extends StatefulWidget {
  final OnNumberChange onNumberChange;
  final int _number;

  CartNumberView(this._number, this.onNumberChange, {super.key});

  @override
  _CartNumberViewState createState() => _CartNumberViewState();
}

class _CartNumberViewState extends State<CartNumberView> {
  late int number;


  @override
  void initState() {
    super.initState();
    number = widget._number;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(AppDimens.DIMENS_300),
      height: ScreenUtil().setWidth(AppDimens.DIMENS_80),
      child: Row(
        children: <Widget>[
          InkWell(
              onTap: () => _reduce(),
              child: Container(
                width: ScreenUtil().setWidth(AppDimens.DIMENS_80),
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "-",
                  style: number > 1 ? XTextStyle.color_333333_size_42 : XTextStyle.color_999999_size_42
                ),
              )),
          Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: AppDimens.DIMENS_120.w,
            decoration: BoxDecoration(
              color: AppColors.COLOR_F0F0F0,
              borderRadius: BorderRadius.circular(AppDimens.DIMENS_20.r)
            ),
            child: Text(XUtils.textOf(number),
              style: XTextStyle.color_black_size_42
            ),
          ),
          InkWell(
              onTap: () => _add(),
              child: Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(AppDimens.DIMENS_80),
                height: double.infinity,
                child: Text(
                  "+",
                  style: XTextStyle.color_333333_size_42
                ),
              )),
        ],
      ),
    );
  }

  _reduce() {
    if (number > 1) {
      setState(() {
        number--;
      });
      widget.onNumberChange(number);
    }
  }

  _add() {
    setState(() {
      number++;
    });
    widget.onNumberChange(number);
  }
}
