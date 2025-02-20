import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/page_info.dart';
import 'package:dealful_mall/model/quote_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class QuoteRequestsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuoteRequestState();
}

class QuoteRequestState extends State<QuoteRequestsPage> {
  final RefreshController refreshController = RefreshController();
  final RxList<QuoteEntity> quoteEntitiesX = RxList();
  final PageInfo pageInfo = PageInfo(10);
  PageState pageState = PageState.loading;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.QUOTE_REQUESTS.translated),
        centerTitle: true,
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    if (pageState != PageState.hasData) {
      return ViewModelStateWidget.pageStateWidget(pageState, errorMessage, () {
        _onRefresh();
      });
    }
    return SmartRefresher(
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primaryColor,
        ),
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () => _onRefresh(),
        onLoading: () => _acquireData(),
        child: Obx(() => ListView.separated(
              padding: EdgeInsets.all(AppDimens.DIMENS_30.r),
              itemBuilder: (BuildContext context, int index) {
                return buildItemWidget(quoteEntitiesX[index]);
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: AppDimens.DIMENS_10.h,
              ),
              itemCount: quoteEntitiesX.length,
            )));
  }

  _onRefresh() {
    pageInfo.reset();
    _acquireData();
  }

  _acquireData() {
    HttpUtil.fetchApiStore().getMyQuoteRequests(pageInfo.pageIndex).apiCallback(
        (data) {
      if (data is List<QuoteEntity>) {
        if (pageInfo.isFirstPage()) {
          quoteEntitiesX.assignAll(data);
          setState(() {
            if (data.isNotEmpty) {
              pageState = PageState.hasData;
            } else {
              pageState = PageState.empty;
            }
          });
        } else {
          quoteEntitiesX.addAll(data);
        }
        if (data.isNotEmpty) {
          pageInfo.nextPage();
        }
      }
    }, (errorMsg) {
      XUtils.showError(errorMsg);
      if (pageInfo.isFirstPage()) {
        refreshController.loadFailed();
        setState(() {
          errorMessage = errorMsg;
          pageState = PageState.error;
        });
      } else {
        refreshController.loadFailed();
      }
    });
  }

  Widget buildItemWidget(QuoteEntity quoteEntity) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      child: Padding(
          padding: EdgeInsets.all(AppDimens.DIMENS_20.r),
          child: Slidable(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CachedImageView(
                    ScreenUtil().setWidth(AppDimens.DIMENS_200),
                    ScreenUtil().setWidth(AppDimens.DIMENS_200),
                    XUtils.textOf(quoteEntity.image),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(AppDimens.DIMENS_20))),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(XUtils.textOf(quoteEntity.productTitle),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: XTextStyle.color_333333_size_42),
                        Padding(
                          padding: EdgeInsets.only(top: AppDimens.DIMENS_20.h),
                          child: Row(
                            children: [
                              Text("${quoteEntity.showPrice}",
                                  style: XTextStyle.color_999999_size_42),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (actionContext) {
                      deleteQuoteRequest(quoteEntity);
                    },
                    label: AppStrings.DELETE.translated,
                    icon: Icons.delete,
                    foregroundColor: AppColors.primaryColor,
                  )
                ],
              ))),
    );
  }

  void deleteQuoteRequest(QuoteEntity entity) {
    HttpUtil.fetchApiStore()
        .removeQuoteRequest(XUtils.textOf(entity.id))
        .apiCallback((data) {
      quoteEntitiesX.remove(entity);
    });
  }
}
