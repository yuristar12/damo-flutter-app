import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/model/comment_entity.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/ui/widgets/comment_widget.dart';
import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommentTab extends StatefulWidget {
  final String productId;

  const CommentTab(
    this.productId, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CommentTabState();
}

class _CommentTabState extends State<CommentTab> {
  final RefreshController refreshController = RefreshController();
  final List<CommentEntity> commentEntities = [];
  final PageInfo pageInfo = PageInfo(10);

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullUp: true,
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primaryColor,
        ),
        controller: refreshController,
        onRefresh: () => refresh(),
        onLoading: () => acquireData(),
        child: commentEntities.length == 0
            ? EmptyDataView()
            : ListView.separated(
                itemBuilder: (_, index) => Container(
                    color: AppColors.COLOR_FFFFFF,
                    padding: EdgeInsets.all(AppDimens.DIMENS_30.r),
                    child: CommentWidget(commentEntities[index])),
                separatorBuilder: (_, index) => SizedBox(
                      height: AppDimens.DIMENS_10.h,
                    ),
                itemCount: commentEntities.length));
  }

  refresh() {
    pageInfo.reset();
    acquireData();
  }

  void acquireData() {
    HttpUtil.fetchApiStore()
        .getProductComments(widget.productId, pageInfo.pageIndex)
        .apiCallback((data) {
      if (data is List<CommentEntity>) {
        if (pageInfo.isFirstPage()) {
          commentEntities.assignAll(data);
        } else {
          commentEntities.addAll(data);
        }
        setState(() {});
        pageInfo.nextPage();
      }
    }, (errorMsg) {
      XUtils.showError(errorMsg);
    });
  }
}
