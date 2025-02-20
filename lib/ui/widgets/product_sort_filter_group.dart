import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/brand_entity.dart';
import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/model/custom_find_entity.dart';
import 'package:dealful_mall/model/custom_item_entity.dart';
import 'package:dealful_mall/model/product_search_model.dart';
import 'package:dealful_mall/model/search_bean.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductSortFilterGroup extends StatefulWidget {
  final ProductSearchModel? searchModel;
  final RxString sortX;
  final RxString layoutModeX;
  final VoidCallback? changeCallback;
  final String? categoryName;

  const ProductSortFilterGroup(this.sortX, this.layoutModeX,
      {this.searchModel, this.categoryName, this.changeCallback});

  @override
  State<StatefulWidget> createState() => _ProductSortFilterState();
}

class _ProductSortFilterState extends State<ProductSortFilterGroup> {
  late String sortSelection;
  /// 浏览模式，默认网格
  String layoutMode = AppStrings.GRID_LAYOUT;
  final GlobalKey filterGlobalKey = GlobalKey();
  List<CategoryEntity>? categoryEntities;
  List<BrandEntity>? brandEntities;
  final RxList<CustomFindEntity> customFindEntitiesX = RxList();
  bool loaded = false;
  bool hasFilter = false;
  bool pendingShow = false;
  final List<String> sortEntities = [
    AppStrings.DEFAULT,
    AppStrings.SORT_MOST_RECENT,
    AppStrings.SORT_LOWEST_PRICE,
    AppStrings.SORT_HIGHEST_PRICE,
    AppStrings.SORT_HIGHEST_RATING
  ];
  final List<String> layoutEntities = [
    AppStrings.GRID_LAYOUT,
    AppStrings.REGULAR_LISTING,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.sortX.value.isEmpty) {
      widget.sortX.value = sortEntities.first;
    }
    sortSelection = widget.sortX.value;
    hasFilter = widget.searchModel?.hasFilter() == true;
    acquireCustomFindEntities(widget.searchModel?.categoryId);
    Future.wait([
      HttpUtil.fetchApiStore().getHomeBrandList().then((onValue) {
        brandEntities = onValue.data;
      }),
      acquireCaterories(),
    ]).then((onValue) {
      loaded = true;
      if (pendingShow) {
        pendingShow = false;
        showSelectionView();
      }
    });
  }

  Future<dynamic> acquireCaterories() {
    if (widget.searchModel?.companyId?.isNotEmpty == true) {
      return HttpUtil.fetchApiStore()
          .getSingleSupplierCategories(
              XUtils.textOf(widget.searchModel?.categoryId, defValue: "0"),
              XUtils.textOf(widget.searchModel?.companyId))
          .then((onValue) {
        CategoryEntity? categoryEntity = onValue.data;
        if (categoryEntity == null) {
          return;
        }
        List<CategoryEntity> resData =
            categoryEntity.categories ?? categoryEntity.children ?? [];
        List<CategoryEntity> result = [];
        String categoryId = XUtils.textOf(widget.searchModel?.categoryId);
        if (categoryId.isNotEmpty && widget.categoryName?.isNotEmpty == true) {
          result.add(CategoryEntity(id: categoryId, name: widget.categoryName));
        }
        result.addAll(resData);
        categoryEntities = result;
      });
    }
    return HttpUtil.fetchApiStore()
        .getMainCategories(
            XUtils.textOf(widget.searchModel?.categoryId, defValue: "0"), 0)
        .then((onValue) {
      String categoryId = XUtils.textOf(widget.searchModel?.categoryId);
      List<CategoryEntity> result = [];
      if (categoryId.isNotEmpty && widget.categoryName?.isNotEmpty == true) {
        result.add(CategoryEntity(id: categoryId, name: widget.categoryName));
      }
      result.addAll(onValue.data ?? []);
      categoryEntities = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppDimens.DIMENS_30.w,
        ),
        GestureDetector(
          key: filterGlobalKey,
            onTap: () {
              showSelectionView();
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.DIMENS_60.r),
                border:
                    Border.all(color: hasFilter ? Colors.black : Colors.grey),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.DIMENS_30.r,
                    vertical: AppDimens.DIMENS_6.r),
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: hasFilter ? Colors.black : Colors.grey,
                ),
              ),
            )),
        SizedBox(
          width: AppDimens.DIMENS_30.w,
        ),
        DropdownButton<String>(
            value: sortSelection,
            underline: const SizedBox.shrink(),
            dropdownColor: Colors.white,
            onChanged: (entity) {
              if (entity != null && entity != sortSelection) {
                setState(() {
                  sortSelection = entity;
                  widget.sortX.value = sortSelection;
                  widget.changeCallback?.call();
                });
              }
            },
            padding: EdgeInsets.only(top: 0),
            items: buildMenuItem(sortEntities)),
        Spacer(),
        DropdownButton<String>(
            value: layoutMode,
            underline: const SizedBox.shrink(),
            dropdownColor: Colors.white,
            onChanged: (entity) {
              if (entity != null && entity != layoutMode) {
                setState(() {
                  layoutMode = entity;
                  widget.layoutModeX.value = layoutMode;
                });
              }
            },
            padding: EdgeInsets.only(top: 0),
            items: buildMenuItem(layoutEntities)),
      ],
    );
  }

  List<DropdownMenuItem<String>> buildMenuItem(List<String> entities) =>
      List.generate(entities.length, (index) {
        String value = entities[index];
        return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value.translated,
              style: XTextStyle.color_333333_size_38,
            ));
      });

  void showSelectionView() {
    if (!loaded) {
      XUtils.showToast(AppStrings.LOADING);
      pendingShow = true;
      return;
    }
    if (brandEntities == null && categoryEntities == null) {
      return;
    }
    double paddingTop = AppDimens.DIMENS_260.h.roundToDouble() + 1;
    RenderObject? renderObject = filterGlobalKey.currentContext?.findRenderObject();
    if(renderObject is RenderBox) {
      Offset offset = renderObject.localToGlobal(Offset.zero);
      paddingTop = offset.dy + renderObject.size.height/2;
    }
    ProductSearchModel tempSearchModel =
        widget.searchModel?.copy() ?? ProductSearchModel();
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (_) {
          int? categoryIndex = categoryEntities
              ?.indexWhere((test) => test.id == tempSearchModel.categoryId);
          final TextEditingController minEditController = TextEditingController(
              text: XUtils.textOf(tempSearchModel.minPrice));
          final TextEditingController maxEditController = TextEditingController(
              text: XUtils.textOf(tempSearchModel.maxPrice));
          return StatefulBuilder(
            builder: (dialogContext, stateSetter) {
              return Container(
                width: double.infinity,
                color: Colors.black54,
                margin: EdgeInsets.only(
                    top: paddingTop.ceilToDouble()),
                child: Stack(
                  children: [
                    Positioned.fill(child: GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
                      },
                    )),
                    Column(
                      children: [
                        Container(
                          height: AppDimens.DIMENS_850.h,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.DIMENS_30.w,
                                vertical: AppDimens.DIMENS_20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppStrings.CATEGORIES.translated}",
                                  style: XTextStyle.color_333333_size_48_bold,
                                ),
                                ListView.builder(
                                  itemBuilder: (_, index) {
                                    CategoryEntity? entity =
                                        categoryEntities?[index];
                                    return Row(
                                      children: [
                                        Text(XUtils.textOf(entity?.name)),
                                        Spacer(),
                                        BrnRadioButton(
                                            isSelected: index == categoryIndex,
                                            radioIndex: index,
                                            onValueChangedAtIndex:
                                                (index, checked) {
                                              if (checked &&
                                                  categoryIndex != index) {
                                                stateSetter.call(() {
                                                  categoryIndex = index;
                                                  tempSearchModel.categoryId =
                                                      categoryEntities?[index]
                                                          .id;
                                                  acquireCustomFindEntities(
                                                      tempSearchModel
                                                          .categoryId);
                                                });
                                              }
                                            })
                                      ],
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: categoryEntities?.length ?? 0,
                                ),
                                Obx(() => ListView.builder(
                                  itemBuilder: (_, index) {
                                    CustomFindEntity findEntity =
                                        customFindEntitiesX[index];
                                    List<CustomItemEntity> itemEntities =
                                        findEntity.itemList ?? [];
                                    if (itemEntities.isEmpty) {
                                      return SizedBox.shrink();
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          XUtils.textOf(findEntity.customName),
                                          style: XTextStyle
                                              .color_333333_size_48_bold,
                                        ),
                                        ListView.builder(
                                          itemBuilder: (_, index) =>
                                              buildCustomItem(findEntity, index,
                                                  stateSetter),
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: itemEntities.length,
                                        )
                                      ],
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: customFindEntitiesX.length,
                                )),
                                SizedBox(
                                  height: AppDimens.DIMENS_20.h,
                                ),
                                Text(
                                  "${AppStrings.BRAND.translated}",
                                  style: XTextStyle.color_333333_size_48_bold,
                                ),
                                ListView.builder(
                                  itemBuilder: (_, index) {
                                    BrandEntity? entity = brandEntities?[index];
                                    return Row(
                                      children: [
                                        Text(XUtils.textOf(entity?.name)),
                                        Spacer(),
                                        BrnRadioButton(
                                            isSelected: tempSearchModel.isBrandSelected(entity?.id),
                                            radioIndex: index,
                                            onValueChangedAtIndex:
                                                (index, checked) {
                                                  stateSetter.call(() {
                                                    if (tempSearchModel.isBrandSelected(entity?.id)) {
                                                      tempSearchModel.removeBrandId(entity?.id);
                                                    } else {
                                                      tempSearchModel.addBrandId(entity?.id);
                                                    }
                                                  });
                                            })
                                      ],
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: brandEntities?.length ?? 0,
                                ),
                                SizedBox(
                                  height: AppDimens.DIMENS_20.h,
                                ),
                                Text(
                                  "${AppStrings.PRICE.translated} (${XUtils.textOf(XLocalization.currencyEntity?.code)})",
                                  style: XTextStyle.color_333333_size_48_bold,
                                ),
                                SizedBox(
                                  height: AppDimens.DIMENS_10.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: minEditController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(),
                                          isDense: true,
                                          labelText: AppStrings.MIN.translated),
                                    )),
                                    SizedBox(
                                      width: AppDimens.DIMENS_30.w,
                                    ),
                                    Expanded(
                                        child: TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: maxEditController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(),
                                          isDense: true,
                                          labelText: AppStrings.MAX.translated),
                                    )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                            color: Colors.white,
                            height: AppDimens.DIMENS_160.r,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.DIMENS_30.w,
                                vertical: AppDimens.DIMENS_20.h),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.white),
                                          padding: WidgetStatePropertyAll(
                                              EdgeInsets.zero),
                                          shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  side: BorderSide(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimens
                                                              .DIMENS_30)))),
                                      onPressed: () {
                                        stateSetter.call(() {
                                          tempSearchModel.categoryId = null;
                                          tempSearchModel.clearBrand();
                                          tempSearchModel.minPrice = null;
                                          tempSearchModel.maxPrice = null;
                                          tempSearchModel.customSearchBeans.clear();
                                          for(CustomFindEntity customFindEntity in customFindEntitiesX) {
                                            customFindEntity.selectedItemId = null;
                                          }
                                          categoryIndex = null;
                                        });
                                      },
                                      child: Text(AppStrings.RESET.translated,
                                          style:
                                              XTextStyle.color_333333_size_52),
                                    )),
                                SizedBox(
                                  width: AppDimens.DIMENS_30.w,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  AppColors.primaryColor),
                                          padding: WidgetStatePropertyAll(
                                              EdgeInsets.zero),
                                          shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimens
                                                              .DIMENS_30)))),
                                      onPressed: () {
                                        tempSearchModel.minPrice = int.tryParse(
                                            minEditController.text);
                                        tempSearchModel.maxPrice = int.tryParse(
                                            maxEditController.text);
                                        tempSearchModel.customSearchBeans.clear();
                                        for(CustomFindEntity customFindEntity in customFindEntitiesX) {
                                          if (customFindEntity.selectedItemId !=
                                              null) {
                                            tempSearchModel.customSearchBeans
                                                .add(SearchBean(
                                                    searchKey: customFindEntity
                                                        .customField,
                                                    searchValue:
                                                        customFindEntity
                                                            .selectedItemId,
                                                    searchType: 1));
                                          }
                                        }
                                        if (tempSearchModel !=
                                                widget.searchModel &&
                                            widget.searchModel != null) {
                                          setState(() {
                                            hasFilter =
                                                tempSearchModel.hasFilter();
                                          });
                                          widget.searchModel
                                              ?.copyFrom(tempSearchModel);
                                          widget.changeCallback?.call();
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppStrings.OK.translated,
                                          style:
                                              XTextStyle.color_FFFFFF_size_52),
                                    ))
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Widget buildCustomItem(
      CustomFindEntity findEntity, int index, StateSetter stateSetter) {
    CustomItemEntity? itemEntity = findEntity.itemList?[index];
    if (itemEntity == null) {
      return SizedBox.shrink();
    }
    return Row(
      children: [
        Text(XUtils.textOf(itemEntity.itemName)),
        Spacer(),
        BrnRadioButton(
            isSelected: findEntity.selectedItemId == itemEntity.itemId,
            radioIndex: index,
            onValueChangedAtIndex: (index, checked) {
              if (checked) {
                stateSetter.call(() {
                  findEntity.selectedItemId = itemEntity.itemId;
                });
              }
            })
      ],
    );
  }

  void acquireCustomFindEntities(String? categoryId) {
    customFindEntitiesX.clear();
    if (categoryId == null) {
      return;
    }
    HttpUtil.fetchApiStore()
        .getCustomFieldsForCategory(categoryId)
        .apiCallback((data) {
      if (data is List<CustomFindEntity>) {
        customFindEntitiesX.assignAll(data);
      }
    });
  }
}
