import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/comment_record.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InputCommentWidget extends StatelessWidget {
  final GlobalKey<FormState> _commentKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final void Function(CommentRecord record) onSubmited;

  InputCommentWidget(
    this.onSubmited, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _commentKey,
        child: ListView(
          children: [
            SizedBox(height: AppDimens.DIMENS_30.h,),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: TextFormField(
                  controller: nameController,
                  validator: (input) {
                    if (input?.isNotEmpty == true) {
                      return null;
                    } else {
                      return AppStrings.INPUT_HINT.translated;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: AppStrings.NAME.translated,
                      isDense: true,
                      border: OutlineInputBorder()),
                )),
                SizedBox(
                  width: AppDimens.DIMENS_20.w,
                ),
                Expanded(
                  flex: 3,
                    child: TextFormField(
                  controller: emailController,
                  validator: (input) {
                    if (input?.isNotEmpty == true && GetUtils.isEmail(input!)) {
                      return null;
                    } else {
                      return AppStrings.ENTER_EMAIL_TIP.translated;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: AppStrings.EMAIL_ADDRESS.translated,
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: AppStrings.ENTER_EMAIL_TIP.translated),
                )),
              ],
            ),
            SizedBox(height: AppDimens.DIMENS_20.h,),
            TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                  labelText: AppStrings.COMMENT.translated,
                  isDense: true,
                  border: OutlineInputBorder()),
              validator: (input) {
                if (input?.isNotEmpty == true) {
                  return null;
                } else {
                  return AppStrings.INPUT_HINT.translated;
                }
              },
              minLines: 1,
              maxLines: 3,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_10)),
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.primaryColor),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppDimens.DIMENS_30))))),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_commentKey.currentState!.validate()) {
                    CommentRecord record = CommentRecord(
                        email: emailController.text,
                        name: nameController.text,
                        comment: commentController.text);
                    onSubmited.call(record);
                  }
                },
                child: Text(AppStrings.SUBMIT.translated,
                    style: XTextStyle.color_ffffff_size_42),
              ),
            )
          ],
        ));
  }
}
