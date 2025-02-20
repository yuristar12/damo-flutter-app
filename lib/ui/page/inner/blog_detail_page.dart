import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/blog_detail_entity.dart';
import 'package:dealful_mall/model/blog_entity.dart';
import 'package:dealful_mall/model/comment_entity.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/ui/widgets/adaptive_webview.dart';
import 'package:dealful_mall/ui/widgets/comment_widget.dart';
import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/ui/widgets/input_comment_widget.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BlogDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  BlogDetailEntity? blogDetailEntity = null;
  String title = AppStrings.APP_NAME;
  PageState pageState = PageState.loading;
  String errorMessage = "";
  RxList<CommentEntity> commentEntitiesX = RxList();
  PageInfo pageInfo = PageInfo(10);
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    String blogId = XUtils.textOf(Get.parameters[AppParameters.ID]);
    if (blogId.isNotEmpty) {
      HttpUtil.fetchApiStore().getBlogDetail(blogId).apiCallback((data) {
        if (data is BlogDetailEntity) {
          blogDetailEntity = data;
          setState(() {
            title = XUtils.textOf(data.title);
            pageState = PageState.hasData;
          });
        }
      }, (errorData) {
        errorMessage = errorData;
        setState(() {
          pageState = PageState.error;
        });
      });
    } else {
      pageState = PageState.empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (pageState != PageState.hasData) {
      return Scaffold(
          body: ViewModelStateWidget.pageStateWidget(
              pageState, errorMessage, () {}));
    }
    return Scaffold(
      appBar: AppBar(),
      body: _content(),
      persistentFooterButtons: [
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return BottomSheet(
                          backgroundColor: Colors.white,
                          builder: (_) => Container(
                              height: AppDimens.DIMENS_400.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppDimens.DIMENS_30.w),
                              child: InputCommentWidget((commentRecord) {
                                commentRecord.postId = blogDetailEntity?.id;
                                HttpUtil.fetchApiStore()
                                    .addBlogComment(commentRecord)
                                    .apiCallback((onValue) {
                                  XUtils.showToast(
                                      AppStrings.MSG_COMMENT_SENT.translated);
                                  Navigator.pop(context);
                                }, (errorMsg) {
                                  XUtils.showError(errorMsg);
                                });
                              })),
                          onClosing: () {},
                        );
                      });
                },
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.edit,
                      color: AppColors.COLOR_333333,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
                    hintText: AppStrings.WRITE_REVIEW.translated,
                    hintStyle: XTextStyle.color_999999_size_42,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              )),
              GestureDetector(
                  onTap: showCommentSheet,
                  child: Icon(Icons.mode_comment_outlined))
            ],
          ),
        )
      ],
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: XTextStyle.color_000000_size_54_bold,
          ),
          Row(
            children: [
              Icon(
                Icons.folder_open,
                size: AppDimens.DIMENS_42.r,
                color: AppColors.COLOR_999999,
              ),
              Text(
                XUtils.textOf(blogDetailEntity?.category),
                style: XTextStyle.color_999999_size_36,
              ),
              SizedBox(
                width: AppDimens.DIMENS_20.w,
              ),
              Icon(Icons.access_time,
                  size: AppDimens.DIMENS_42.r, color: AppColors.COLOR_999999),
              Text(
                XUtils.textOf(blogDetailEntity?.createdAt),
                style: XTextStyle.color_999999_size_36,
              )
            ],
          ),
          AdaptiveWebView(
            htmlString: XUtils.textOf(blogDetailEntity?.content),
          )
        ],
      ),
    );
  }

  void showCommentSheet() async {
    if (commentEntitiesX.isEmpty) {
      await loadComments();
    }
    showCommentSheetReal();
  }

  Future loadComments() {
    return HttpUtil.fetchApiStore().getBlogComments({
      "Search": {"PostId": blogDetailEntity?.id},
      "paging": pageInfo.pageIndex
    }).then((onValue) {
      if (pageInfo.isFirstPage()) {
        commentEntitiesX.assignAll(onValue.data ?? []);
        if (commentEntitiesX.isNotEmpty) {
          refreshController.resetNoData();
          pageInfo.nextPage();
        }
      } else {
        List<CommentEntity> result = onValue.data ?? [];
        commentEntitiesX.addAll(result);
        if (result.isNotEmpty) {
          refreshController.loadComplete();
          pageInfo.nextPage();
        } else {
          refreshController.loadNoData();
        }
      }
    });
  }

  void showCommentSheetReal() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (sheetContext) {
          return Padding(
            padding: EdgeInsets.all(AppDimens.DIMENS_30.r),
            child: Column(
              children: [
                Text(
                  AppStrings.COMMENTS.translated,
                  style: XTextStyle.color_333333_size_60,
                ),
                Expanded(
                    child: SmartRefresher(
                        enablePullUp: true,
                        enablePullDown: false,
                        controller: refreshController,
                        onLoading: () => loadComments,
                        child: commentEntitiesX.length == 0
                            ? EmptyDataView()
                            : Obx(() => ListView.separated(
                                itemBuilder: (_, index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppDimens.DIMENS_30.r,
                                        vertical: AppDimens.DIMENS_20.r),
                                    child:
                                        CommentWidget(commentEntitiesX[index])),
                                separatorBuilder: (_, index) => Divider(),
                                itemCount: commentEntitiesX.length))))
              ],
            ),
          );
        });
  }
}
