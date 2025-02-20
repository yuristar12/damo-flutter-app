import 'package:bruno/bruno.dart';
import 'package:dealful_mall/constant/app_colors.dart';
import 'package:dealful_mall/constant/app_dimens.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/column_item_entity.dart';
import 'package:dealful_mall/model/custom_find_entity.dart';
import 'package:dealful_mall/model/custom_item_entity.dart';
import 'package:dealful_mall/model/search_bean.dart';
import 'package:dealful_mall/model/search_set_model.dart';
import 'package:dealful_mall/model/setting_entity.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchSetFilterGroup extends StatefulWidget {
  final SearchSetModel searchSetModel;
  final RxString sortX;
  final String formNo;
  final VoidCallback? changeCallback;

  const SearchSetFilterGroup(this.searchSetModel, this.sortX, this.formNo,
      {this.changeCallback});

  @override
  State<StatefulWidget> createState() => _SortFilterState();
}

class _SortFilterState extends State<SearchSetFilterGroup> {
  late String sortSelection;
  final GlobalKey filterGlobalKey = GlobalKey();
  final RxList<ColumnItemEntity> columnItemEntitiesX = RxList();
  bool loaded = false;
  bool hasFilter = false;
  bool pendingShow = false;
  final List<String> sortEntities = [
    AppStrings.DEFAULT,
    AppStrings.SORT_MOST_RECENT,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.sortX.value.isEmpty) {
      widget.sortX.value = sortEntities.first;
    }
    sortSelection = widget.sortX.value;
    hasFilter = widget.searchSetModel.hasFilter();
    HttpUtil.fetchApiStore()
        .getSearchSetByFormNo(widget.formNo)
        .apiCallback((successData) {
      if (successData is List<ColumnItemEntity>) {
        loaded = true;
        columnItemEntitiesX.assignAll(successData);
        if (pendingShow) {
          pendingShow = false;
          showSelectionView();
        }
      }
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
    if (columnItemEntitiesX.isEmpty) {
      return;
    }
    double paddingTop = AppDimens.DIMENS_260.h.roundToDouble() + 1;
    RenderObject? renderObject =
        filterGlobalKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      Offset offset = renderObject.localToGlobal(Offset.zero);
      paddingTop = offset.dy + renderObject.size.height / 2;
    }
    SearchSetModel tempSearchSetModel = widget.searchSetModel.copy();
    showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (_) {
          return StatefulBuilder(
            builder: (dialogContext, stateSetter) {
              return Container(
                width: double.infinity,
                color: Colors.black54,
                margin: EdgeInsets.only(top: paddingTop.ceilToDouble()),
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
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppDimens.DIMENS_30.w,
                                    vertical: AppDimens.DIMENS_20.h),
                                itemBuilder: (_, index) {
                                  ColumnItemEntity itemEntity = columnItemEntitiesX[index];
                                  List<SettingEntity>? settingEntities = itemEntity.setting;
                                  if (settingEntities == null ||
                                      settingEntities.isEmpty) {
                                    return SizedBox.shrink();
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        XUtils.textOf(itemEntity.dataTitle),
                                        style: XTextStyle
                                            .color_333333_size_48_bold,
                                      ),
                                      buildSettingList(settingEntities, itemEntity.formType == "radio", stateSetter),
                                    ],
                                  );
                                },
                              itemCount: columnItemEntitiesX.length,
                            )),
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
                                          tempSearchSetModel.clear();
                                          columnItemEntitiesX.forEach((item) {
                                            item.clearSelect();
                                          });
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
                                        tempSearchSetModel.clear();
                                        for (ColumnItemEntity columnItem
                                            in columnItemEntitiesX) {
                                          String dataField = XUtils.textOf(
                                              columnItem.dataField);
                                          if (dataField.isNotEmpty) {
                                            columnItem.setting
                                                ?.forEach((setting) {
                                              if (setting.selected) {
                                                String selectedVal =
                                                    XUtils.textOf(
                                                        setting.byVal);
                                                if (selectedVal.isNotEmpty) {
                                                  tempSearchSetModel.addSearch(
                                                      SearchBean(
                                                          searchKey: dataField,
                                                          searchValue:
                                                              selectedVal,
                                                          searchType: 0));
                                                }
                                              }
                                            });
                                          }
                                        }
                                        if (tempSearchSetModel !=
                                            widget.searchSetModel) {
                                          setState(() {
                                            hasFilter =
                                                tempSearchSetModel.hasFilter();
                                          });
                                          widget.searchSetModel
                                              .applyFrom(tempSearchSetModel);
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

  Widget buildSettingList(List<SettingEntity> settingEntities,
      bool singleSelect, StateSetter stateSetter) {
    return ListView.builder(
      itemBuilder: (_, index) {
        SettingEntity entity = settingEntities[index];
        return Row(
          children: [
            Text(XUtils.textOf(entity.dataText)),
            Spacer(),
            BrnRadioButton(
                isSelected: entity.selected,
                radioIndex: index,
                onValueChangedAtIndex: (index, checked) {
                  stateSetter.call(() {
                    if(singleSelect) {
                      if(checked) {
                        settingEntities.forEach((item){
                          item.selected = false;
                        });
                      }
                      entity.selected = true;
                    } else {
                    entity.selected = !entity.selected;
                    }
                  });
                })
          ],
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: settingEntities.length,
    );
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
}
