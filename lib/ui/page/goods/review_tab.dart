import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/model/review_entity.dart';
import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/ui/widgets/review_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReviewTab extends StatefulWidget {
  final String productId;

  const ReviewTab(
    this.productId, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  final RefreshController refreshController = RefreshController();
  final List<ReviewEntity> reviewEntities = [];
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
        child: reviewEntities.length == 0
            ? EmptyDataView()
            : ListView.separated(
                itemBuilder: (_, index) => Container(
                    color: AppColors.COLOR_FFFFFF,
                    padding: EdgeInsets.all(AppDimens.DIMENS_30.r),
                    child: ColoredBox(
                        color: AppColors.COLOR_FFFFFF,
                        child: ReviewWidget(reviewEntities[index]))),
                separatorBuilder: (_, index) => SizedBox(
                      height: AppDimens.DIMENS_10.h,
                    ),
                itemCount: reviewEntities.length));
  }

  refresh() {
    pageInfo.reset();
    acquireData();
  }

  void acquireData() {
    HttpUtil.fetchApiStore()
        .getProductReviews(widget.productId, pageInfo.pageIndex)
        .apiCallback((data) {
      if (data is List<ReviewEntity>) {
        if (pageInfo.isFirstPage()) {
          reviewEntities.assignAll(data);
        } else {
          reviewEntities.addAll(data);
        }
        setState(() {});
        pageInfo.nextPage();
      }
    }, (errorMsg) {
      XUtils.showError(errorMsg);
    });
  }
}
