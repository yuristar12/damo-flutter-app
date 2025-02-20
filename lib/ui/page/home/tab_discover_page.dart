import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_images.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/event/tab_select_event.dart';
import 'package:dealful_mall/model/brand_entity.dart';
import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/ui/widgets/cached_image.dart';
import 'package:dealful_mall/ui/widgets/empty_data.dart';
import 'package:dealful_mall/ui/widgets/x_text.dart';
import 'package:dealful_mall/utils/navigator_util.dart';
import 'package:dealful_mall/utils/refresh_state_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/tab_category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TabDiscoverPage extends StatefulWidget {
  @override
  _TabDiscoverPageState createState() => _TabDiscoverPageState();
}

class _TabDiscoverPageState extends State<TabDiscoverPage>
    with SingleTickerProviderStateMixin {
  TabDiscoverViewModel _tabDiscoverViewModel = TabDiscoverViewModel();
  RefreshController _categoryRefreshController = RefreshController();
  RefreshController _brandRefreshController = RefreshController();
  final TextEditingController _keyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    _tabDiscoverViewModel.onRefreshBrand();
    _tabDiscoverViewModel.onRefreshCategory();
    XLocalization.listen((data) {
      _tabDiscoverViewModel.onRefreshBrand();
      _tabDiscoverViewModel.onRefreshCategory();
      if (mounted) {
        setState(() {});
      }
    });
    tabController = TabController(length: 2, vsync: this);
    tabSelectBus.on<TabSelectEvent>().listen((event) {
      print('event---${event.menuIndex}');
      if (event.selectIndex == 1) {
        _tabDiscoverViewModel.setParentCategorySelect(event.menuIndex);
        tabController.index = event.innerTabIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TabDiscoverViewModel>(
      create: (_) => _tabDiscoverViewModel,
      child: Scaffold(
          appBar: AppBar(
            title: _searchWidget(),
          ),
          body: Column(
            children: [
              TabBar(
                  controller: tabController,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  indicatorColor: AppColors.primaryColor,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: Colors.black,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.only(
                      top: AppDimens.DIMENS_10.h,
                      bottom: AppDimens.DIMENS_20.h),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      TextStyle(fontWeight: FontWeight.normal),
                  tabs: [
                    Text(AppStrings.CATEGORIES.translated),
                    Text(AppStrings.BRAND.translated),
                  ]),
              Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: [categoriesTab(), brandsTab()]))
            ],
          )),
    );
  }

  Widget categoriesTab() {
    return Consumer<TabDiscoverViewModel>(
      builder: (context, model, child) {
        RefreshStateUtil.getInstance()
            .stopRefreshOrLoadMore(_categoryRefreshController);
        return RefreshConfiguration(
          child: SmartRefresher(
              enablePullUp: false,
              header: WaterDropMaterialHeader(
                backgroundColor: AppColors.primaryColor,
              ),
              controller: _categoryRefreshController,
              onRefresh: () => _tabDiscoverViewModel.onRefreshCategory(),
              child: _tabDiscoverViewModel.parentCategories.length == 0
                  ? EmptyDataView()
                  : Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: _parentCategoryWidget(_tabDiscoverViewModel),
                          ),
                          Expanded(
                            flex: 7,
                            child: _tabDiscoverViewModel
                                        .childCategories.length ==
                                    0
                                ? EmptyDataView()
                                : _childCategoryWidget(_tabDiscoverViewModel),
                          ),
                        ]))),
        );
      },
    );
  }

  Widget _searchWidget() {
    return Container(
      height: AppBar().preferredSize.height,
      padding: EdgeInsets.all(AppDimens.DIMENS_30.r),
      alignment: Alignment.center,
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.COLOR_FFFFFF,
            border: Border.all(
                color: AppColors.COLOR_FFFFFF, width: AppDimens.DIMENS_1.w),
            borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
          ),
          child: TextField(
            onSubmitted: (value) {
              toSearch();
            },
            controller: _keyController,
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: AppColors.COLOR_333333,
                fontSize: ScreenUtil().setSp(AppDimens.DIMENS_42)),
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: toSearch,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height.w),
                  ),
                  margin: EdgeInsets.all(AppDimens.DIMENS_10.r),
                  child: Icon(
                    Icons.search_outlined,
                    size: AppDimens.DIMENS_70.w,
                    color: Colors.white,
                  ),
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w),
              hintText: AppStrings.KEYWORD.translated,
              hintStyle: XTextStyle.color_999999_size_42,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          )),
    );
  }

  void toSearch() {
    NavigatorUtil.goSearchGoods(
      context,
      keyword: _keyController.text,
    );
  }

  Widget _parentCategoryWidget(TabDiscoverViewModel tabCategoryViewModel) {
    return Selector<TabDiscoverViewModel, TabDiscoverViewModel>(
      shouldRebuild: (previous, next) => previous.parentShouldBuild,
      selector: (context, provider) => provider,
      builder: (context, provider, child) {
        provider.parentRebuild();
        return ListView.separated(
            padding: EdgeInsets.only(bottom: AppDimens.DIMENS_20.h),
            itemCount: provider.parentCategories.length,
            separatorBuilder: (_, int index) => SizedBox(
                  height: AppDimens.DIMENS_36.h,
                ),
            itemBuilder: (BuildContext context, int index) {
              return Selector<TabDiscoverViewModel, int>(
                selector: (context, provider) {
                  return provider.selectIndex;
                },
                builder: (context, data, child) {
                  return _getFirstLevelView(
                      provider.parentCategories[index], index, data);
                },
              );
            });
      },
    );
  }

  _itemParentClick(int index) {
    _focusNode.unfocus();
    _tabDiscoverViewModel.setParentCategorySelect(index);
  }

  Widget _getFirstLevelView(
      CategoryEntity categoryEntity, int index, int selectIndex) {
    return InkWell(
      onTap: () => _itemParentClick(index),
      child: Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: AppDimens.DIMENS_6.w),
                color: selectIndex == index ? AppColors.primaryColor : null,
                width: AppDimens.DIMENS_6.w,
                height: AppDimens.DIMENS_50.r,
              ),
              SizedBox(
                width: AppDimens.DIMENS_20.w,
              ),
              Expanded(
                child: Text(
                  XUtils.textOf(categoryEntity.name),
                  softWrap: true,
                  style: selectIndex == index
                      ? TextStyle(
                          color: AppColors.primaryColor,
                          height: 1,
                          fontSize: AppDimens.DIMENS_38.sp)
                      : TextStyle(
                          color: AppColors.COLOR_333333,
                          height: 1,
                          fontSize: AppDimens.DIMENS_38.sp),
                ),
              )
            ],
          )),
    );
  }

  Widget _childCategoryWidget(TabDiscoverViewModel tabCategoryViewModel) {
    return Selector<TabDiscoverViewModel, List<CategoryEntity>>(builder:
        (BuildContext context, List<CategoryEntity> data, Widget? child) {
      return ListView.separated(
        padding: EdgeInsets.only(
            top: AppDimens.DIMENS_10.r,
            right: AppDimens.DIMENS_20.r,
            left: AppDimens.DIMENS_10.r),
        itemBuilder: (BuildContext context, int index) {
          CategoryEntity item = data[index];
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36.r), color: Colors.white),
            padding: EdgeInsets.symmetric(
                horizontal: AppDimens.DIMENS_20.r,
                vertical: AppDimens.DIMENS_20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _categoryClick(item, false);
                  },
                  child: XText(
                    "${XUtils.textOf(item.name)} >",
                    fontSize: 40.sp,
                    maxLines: 2,
                    color: AppColors.COLOR_333333,
                    fontWeight: FontWeight.bold,
                    fontHeight: 1,
                  ),
                ),
                SizedBox(
                  height: 10.r,
                ),
                GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10.r),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: item.children?.length ?? 0,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: AppDimens.DIMENS_1.w,
                        mainAxisExtent: AppDimens.DIMENS_360.r,
                        crossAxisSpacing: AppDimens.DIMENS_20.w),
                    itemBuilder: (BuildContext context, int index) {
                      return _getChildItemView(item.children?[index]);
                    }),
              ],
            ),
          );
        },
        separatorBuilder: (_, index) => SizedBox(
          height: AppDimens.DIMENS_20.h,
        ),
        itemCount: data.length,
      );
    }, selector:
        (BuildContext context, TabDiscoverViewModel tabCategoryViewModel) {
      return tabCategoryViewModel.childCategories;
    });
  }

  _categoryClick(CategoryEntity categoryEntity, [bool showChild = false]) {
    _focusNode.unfocus();
    print('categoryEntitycategoryEntity${categoryEntity.children}');
    if (categoryEntity.children != null &&
        categoryEntity.children!.isNotEmpty &&
        showChild) {
      Get.dialog(_fourthMenu(categoryEntity));
      return;
    }
    if (showChild) {
      Get.dialog(_fourthMenu(categoryEntity));
    } else {
      NavigatorUtil.goCategoryGoodsListPage(context, categoryEntity);
    }
  }

  // 四级菜单弹窗
  Widget _fourthMenu(CategoryEntity categoryEntity) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 400,
          padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_30.w, vertical: AppDimens.DIMENS_20.h),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20.w)),
          child: Column(
            children: [
              Container(
                width: 700.w,
                child: Text(
                  XUtils.textOf(categoryEntity.name),
                ),
              ),
              SizedBox(
                height: 40.w,
              ),
              Expanded(
                  child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10.r),
                      itemCount: categoryEntity.children?.length ?? 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: AppDimens.DIMENS_18.w,
                          mainAxisExtent: AppDimens.DIMENS_300.r,
                          crossAxisSpacing: AppDimens.DIMENS_32.w),
                      itemBuilder: (BuildContext context, int index) {
                        return _getChildItemView(
                            categoryEntity.children?[index]);
                      }))
            ],
          ),
        )
      ],
    );
  }

  Widget _getChildItemView(CategoryEntity? categoryEntity) {
    if (categoryEntity == null) {
      return SizedBox.shrink();
    }
    return GestureDetector(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: AppDimens.DIMENS_10.r),
              child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: CachedImageView(AppDimens.DIMENS_200.r,
                      AppDimens.DIMENS_200.r, categoryEntity.image, fit: BoxFit.contain,),
                  ))),
          Expanded(
              child: Center(
            child: Text(
              Characters(XUtils.textOf(categoryEntity.name)).join('\u{200B}'),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppColors.COLOR_333333,
                  height: 1,
                  fontSize: ScreenUtil().setSp(AppDimens.DIMENS_32)),
            ),
          )),
        ],
      ),
      onTap: () => _categoryClick(
          categoryEntity, categoryEntity.children?.isNotEmpty == true),
    );
  }

  Widget brandsTab() {
    return Consumer<TabDiscoverViewModel>(
      builder: (context, model, child) {
        RefreshStateUtil.getInstance()
            .stopRefreshOrLoadMore(_brandRefreshController);
        return RefreshConfiguration(
            child: SmartRefresher(
                enablePullUp: false,
                header: WaterDropMaterialHeader(
                  backgroundColor: AppColors.primaryColor,
                ),
                controller: _brandRefreshController,
                onRefresh: () => _tabDiscoverViewModel.onRefreshBrand(),
                child: _tabDiscoverViewModel.brandEntities.length == 0
                    ? EmptyDataView()
                    : ListView.separated(
                        padding: EdgeInsets.only(
                            top: AppDimens.DIMENS_10.r,
                            right: AppDimens.DIMENS_30.w,
                            left: AppDimens.DIMENS_30.w),
                        itemBuilder: (BuildContext context, int index) {
                          BrandEntity item =
                              _tabDiscoverViewModel.brandEntities[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.DIMENS_20.r,
                                vertical: AppDimens.DIMENS_20.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: AppDimens.DIMENS_30.w),
                                  child: XText(
                                    XUtils.textOf(item.name),
                                    fontSize: 40.sp,
                                    maxLines: 2,
                                    color: AppColors.COLOR_333333,
                                    fontWeight: FontWeight.bold,
                                    fontHeight: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.r,
                                ),
                                GridView.builder(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.r),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: item.children?.length ?? 0,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1.5,
                                            mainAxisSpacing:
                                                AppDimens.DIMENS_10.h,
                                            crossAxisSpacing:
                                                AppDimens.DIMENS_20.w),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _getBrandItemView(
                                          item.children?[index]);
                                    })
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, index) => SizedBox(
                          height: AppDimens.DIMENS_10.h,
                        ),
                        itemCount: _tabDiscoverViewModel.brandEntities.length,
                      )));
      },
    );
  }

  Widget _getBrandItemView(BrandEntity? brandEntity) {
    if (brandEntity == null) {
      return SizedBox.shrink();
    }
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.DIMENS_20.r),
            color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: AppDimens.DIMENS_10.r),
        child: Column(
          children: [
            SizedBox(
              height: AppDimens.DIMENS_20.r,
            ),
            CachedImageView(
              AppDimens.DIMENS_120.r,
              AppDimens.DIMENS_120.r,
              XUtils.textOf(brandEntity.image),
              fit: BoxFit.contain,
            ),
            Expanded(
                child: Center(
              child: Text(
                XUtils.textOf(brandEntity.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColors.COLOR_333333,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.DIMENS_36.sp),
              ),
            )),
          ],
        ),
      ),
      onTap: () => _brandClick(brandEntity),
    );
  }

  _brandClick(BrandEntity brandEntity) {
    _focusNode.unfocus();
    NavigatorUtil.goSearchGoods(context,
        brandId: XUtils.textOf(brandEntity.id));
  }
}
