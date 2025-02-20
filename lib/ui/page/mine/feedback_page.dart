import 'package:dealful_mall/utils/x_localization.dart';
import 'package:flutter/material.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/ui/widgets/divider_line.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/feed_back_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FeedBackPage extends StatefulWidget {
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  TextEditingController _contentController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  FeedBackViewModel _feedBackModel = FeedBackViewModel();
  var feedBackType;

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.HELP_CENTER),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            color: AppColors.COLOR_FFFFFF,
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
                  child: InkWell(
                    onTap: () => _showBottomDialog(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppStrings.PROBLEM_TYPE,
                          style: XTextStyle.color_333333_size_42,
                        ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      child: ChangeNotifierProvider(
                                        create: (_) => _feedBackModel,
                                        child: Consumer<FeedBackViewModel>(
                                            builder: (context, model, child) {
                                          return Text(
                                            model.feedBackType,
                                            style:  XTextStyle.color_333333_size_42,
                                          );
                                        }),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(
                                                AppDimens.DIMENS_20))),
                                    Icon(
                                      Icons.navigate_next,
                                      color: AppColors.COLOR_999999,
                                    )
                                  ],
                                )))
                      ],
                    ),
                  ),
                ),
                DividerLineView(),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_20)),
                  width: double.infinity,
                  height: ScreenUtil().setHeight(AppDimens.DIMENS_400),
                  child: TextField(
                    controller: _contentController,
                    maxLines: 10,
                    textAlignVertical: TextAlignVertical.top,
                    scrollPadding: EdgeInsets.all(0),
                    style:  XTextStyle.color_333333_size_42,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(AppDimens.DIMENS_10),
                      hintText: AppStrings.FEEDBACK_HINT_TEXT,
                      hintStyle: TextStyle(
                          color: AppColors.COLOR_999999,
                          fontSize: ScreenUtil().setSp(AppDimens.DIMENS_42)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.COLOR_999999,
                            width: ScreenUtil().setWidth(AppDimens.DIMENS_1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.COLOR_999999,
                            width: ScreenUtil().setWidth(AppDimens.DIMENS_1)),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
                      child: Text(AppStrings.FEEDBACK_PHONE_NUMBER,
                          style: TextStyle(
                              color: AppColors.COLOR_333333,
                              fontSize:
                                  ScreenUtil().setSp(AppDimens.DIMENS_42))),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        style:  XTextStyle.color_333333_size_42,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          hintText: AppStrings.FEEDBACK_PHONE_NUMBER_HINT_TEXT,
                          hintStyle:  XTextStyle.color_999999_size_42,
                        ),
                      ),
                    )
                  ],
                ),
                DividerLineView(),
                Container(
                  height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_180)),
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppDimens.DIMENS_30))),
                    color: AppColors.primaryColor,
                    splashColor: AppColors.primaryColor,
                    minWidth: double.infinity,
                    onPressed: () => _submit(),
                    child: Text(
                      AppStrings.SUBMIT.translated,
                      style:  XTextStyle.color_ffffff_size_42,
                    ),
                  ),
                )
              ],
            ),
          ),
        )));
  }

  _submit() {
    if (_feedBackModel.feedBackType.isEmpty ||
        _feedBackModel.feedBackType == AppStrings.PLEASE_SELECT_FEEDBACK_TYPE) {
      XUtils.showToast(AppStrings.PLEASE_SELECT_FEEDBACK_TYPE);
      return;
    }
    if (_contentController.text.isEmpty) {
      XUtils.showToast(AppStrings.FEEDBACK_HINT_TEXT);
      return;
    }
    if (_phoneController.text.isEmpty) {
      XUtils.showToast(AppStrings.FEEDBACK_PHONE_NUMBER_HINT_TEXT);
      return;
    }
    _feedBackModel
        .submitFeedBack(_feedBackModel.feedBackType, _contentController.text,
            _phoneController.text)
        .then((value) => {
              if (value!)
                {
                  XUtils.showToast(AppStrings.FEEDBACK_SUCCESS),
                  Navigator.pop(context)
                }
            });
  }

  _showBottomDialog() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.DIMENS_20),
                topRight: Radius.circular(AppDimens.DIMENS_20))),
        builder: (context) {
          return Container(
            height: ScreenUtil().setHeight(AppDimens.DIMENS_513),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(AppDimens.DIMENS_150),
                  child: Text(
                    AppStrings.PLEASE_SELECT_FEEDBACK_TYPE,
                    style: TextStyle(
                        color: AppColors.COLOR_333333,
                        fontSize: ScreenUtil().setSp(AppDimens.DIMENS_42)),
                  ),
                ),
                DividerLineView(),
                InkWell(
                    highlightColor: AppColors.COLOR_FFFFFF,
                    splashColor: AppColors.COLOR_FFFFFF,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
                      height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppStrings.FEEDBACK_DYSFUNCTION,
                        style: TextStyle(
                            color: AppColors.COLOR_333333,
                            fontSize: ScreenUtil().setSp(AppDimens.DIMENS_42)),
                      ),
                    ),
                    onTap: () => {
                          _feedBackModel
                              .setFeedBackType(AppStrings.FEEDBACK_DYSFUNCTION),
                          Navigator.pop(context)
                        }),
                DividerLineView(),
                InkWell(
                    highlightColor: AppColors.COLOR_FFFFFF,
                    splashColor: AppColors.COLOR_FFFFFF,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
                      alignment: Alignment.centerLeft,
                      height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
                      child: Text(
                        AppStrings.FEEDBACK_SUGGESTIONS_OPTIMIZATION,
                        style: TextStyle(
                            color: AppColors.COLOR_333333,
                            fontSize: ScreenUtil().setSp(AppDimens.DIMENS_42)),
                      ),
                    ),
                    onTap: () => {
                          _feedBackModel.setFeedBackType(
                              AppStrings.FEEDBACK_SUGGESTIONS_OPTIMIZATION),
                          Navigator.pop(context)
                        }),
                DividerLineView(),
                InkWell(
                    highlightColor: AppColors.COLOR_FFFFFF,
                    splashColor: AppColors.COLOR_FFFFFF,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: ScreenUtil().setHeight(AppDimens.DIMENS_120),
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(AppDimens.DIMENS_30)),
                      child: Text(
                        AppStrings.FEEDBACK_OTHER,
                        style: TextStyle(
                            color: AppColors.COLOR_333333,
                            fontSize: ScreenUtil().setSp(AppDimens.DIMENS_42)),
                      ),
                    ),
                    onTap: () => {
                          _feedBackModel
                              .setFeedBackType(AppStrings.FEEDBACK_OTHER),
                          Navigator.pop(context)
                        }),
              ],
            ),
          );
        });
  }
}
