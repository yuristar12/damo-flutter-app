import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/project_selection_detail_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/view_model_state_widget.dart';
import 'package:dealful_mall/ui/widgets/waterfull_product_widget.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:dealful_mall/view_model/project_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ProjectSelectionDetailView extends StatefulWidget {
  final int id;

  ProjectSelectionDetailView(this.id);

  @override
  _ProjectSelectionDetailViewState createState() =>
      _ProjectSelectionDetailViewState();
}

class _ProjectSelectionDetailViewState
    extends State<ProjectSelectionDetailView> {
  ProjectSelectionViewModel _projectSelectionViewModel =
      ProjectSelectionViewModel();

  @override
  void initState() {
    super.initState();
    _projectSelectionViewModel.queryDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.PROJECT_SELECTION_DETAIL),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider(
          create: (_) => _projectSelectionViewModel,
          child: Consumer<ProjectSelectionViewModel>(
              builder: (context, model, child) {
            return _initView(model);
          }),
        ));
  }

  Widget _initView(ProjectSelectionViewModel projectSelectionViewModel) {
    if (projectSelectionViewModel.pageState == PageState.hasData) {
      return _contentView(projectSelectionViewModel);
    }
    return ViewModelStateWidget.stateWidgetWithCallBack(
        projectSelectionViewModel, () {});
  }

  Widget _contentView(ProjectSelectionViewModel projectSelectionViewModel) {
    double cardWidth = (ScreenUtil().screenWidth -
            AppDimens.DIMENS_30 * 2 -
            AppDimens.DIMENS_30) /
        2;
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(AppDimens.DIMENS_30)),
          ),
          MasonryGridView.count(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(ScreenUtil().setWidth(AppDimens.DIMENS_30)),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: AppDimens.DIMENS_20.h,
            itemCount: projectSelectionViewModel.goods!.length,
            crossAxisSpacing: AppDimens.DIMENS_30.w,
            itemBuilder: (context, index) {
              return _getGridViewItem(
                  projectSelectionViewModel.goods![index], cardWidth);
            },
          ),
          Container(
            height: ScreenUtil().setHeight(AppDimens.DIMENS_60),
            alignment: Alignment.center,
            child: Text(AppStrings.RECOMMEND_PROJECT_SELECTION,
                style: XTextStyle.color_333333_size_26),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _projectSelectionViewModel
                  .relatedProjectSelectionDetailTopics!.length,
              itemBuilder: (BuildContext context, int index) {
                return _itemView(_projectSelectionViewModel
                    .relatedProjectSelectionDetailTopics![index]);
              })
        ],
      ),
    ));
  }

  _goGoodsDetail(String goodsId) {
    NavigatorUtil.goGoodsDetails(context, goodsId);
  }

  Widget _getGridViewItem(ProductEntity productEntity, double cardWidth) {
    return WaterfullProductWidget(productEntity, (id) => _goGoodsDetail(id), cardWidth);
  }

  Widget _itemView(ProjectSelectionDetailTopic related) {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
          right: ScreenUtil().setWidth(AppDimens.DIMENS_30),
          top: ScreenUtil().setHeight(AppDimens.DIMENS_30)),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _goDetail(related.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  child: CachedImageView(
                      double.infinity,
                      ScreenUtil().setHeight(AppDimens.DIMENS_400),
                      related.picUrl)),
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_20))),
              Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_30)),
                  child: Text(related.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: XTextStyle.color_333333_size_42)),
              Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_30)),
                  child: Text(related.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: XTextStyle.color_333333_size_42)),
              Container(
                  margin: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(AppDimens.DIMENS_30),
                      left: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      right: ScreenUtil().setWidth(AppDimens.DIMENS_30),
                      top: ScreenUtil().setHeight(AppDimens.DIMENS_30)),
                  child: Text(AppStrings.DOLLAR + "${related.price}",
                      style: XTextStyle.color_primary_size_42)),
            ],
          ),
        ),
      ),
    );
  }

  _goDetail(int? id) {
    _projectSelectionViewModel.queryDetail(widget.id);
  }
}
