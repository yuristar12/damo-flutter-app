

import 'package:dealful_mall/model/column_item_entity.dart';
import 'package:dealful_mall/model/custom_find_entity.dart';
import 'package:dealful_mall/model/dic_pro_entity.dart';

class SortFilterProp {
  /// 排序方式，asc/desc
  String sortType;
  /// 排序字段
  String sortField;
  SearchProp searchProp = SearchProp();
  /// 自定义筛选条件是否变化
  bool customChanged = false;
  DicProEntity? dicProEntity;
  SortFilterProp.sortBy(this.sortField, {this.sortType = "desc"});

  SortFilterProp._internal(this.sortField, this.sortType);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortFilterProp &&
          runtimeType == other.runtimeType &&
          sortType == other.sortType &&
          sortField == other.sortField &&
          searchProp == other.searchProp &&
          customChanged == other.customChanged;

  @override
  int get hashCode =>
      sortType.hashCode ^ sortField.hashCode ^ searchProp.hashCode;

  SortFilterProp copy() {
    SortFilterProp result = SortFilterProp._internal(sortField, sortType);
    result.searchProp = SearchProp()..copyFrom(searchProp);
    result.dicProEntity = dicProEntity;
    result.customChanged = customChanged;
    return result;
  }

  /// 深拷贝
  void copyFrom(SortFilterProp other) {
    sortField = other.sortField;
    sortType = other.sortType;
    dicProEntity = other.dicProEntity;
    searchProp = SearchProp()..copyFrom(other.searchProp);
  }
}

class SearchProp{
  String? customFindId;
  String rootId = "";
  int sub = 0;

  List<String>? under;
  List<String>? searchKeywords;
  List<String>? searchType;
  List<String>? listField;

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is SearchProp &&
          runtimeType == other.runtimeType &&
          customFindId == other.customFindId &&
          sub == other.sub &&
          under == other.under &&
          searchKeywords == other.searchKeywords &&
          searchType == other.searchType &&
          listField == other.listField;

  @override
  int get hashCode =>
      customFindId.hashCode ^
      sub.hashCode ^
      under.hashCode ^
      searchKeywords.hashCode ^
      searchType.hashCode ^
      listField.hashCode;

  /// 深拷贝
  void copyFrom(SearchProp searchProp) {
    customFindId = searchProp.customFindId;
    sub = searchProp.sub;
    if(searchProp.under?.isNotEmpty == true) {
      under = List.from(searchProp.under!);
    }
    if(searchProp.searchKeywords?.isNotEmpty == true) {
      searchKeywords = List.from(searchProp.searchKeywords!);
    }
    if(searchProp.searchType?.isNotEmpty == true) {
      searchType = List.from(searchProp.searchType!);
    }
    if(searchProp.listField?.isNotEmpty == true) {
      listField = List.from(searchProp.listField!);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomFindId'] = this.customFindId ?? "";
    data['Sub'] = this.sub;
    data['ListField'] = listField;
    data['SearchKeyword'] = searchKeywords;
    data['SearchType'] = searchType;
    data['RootId'] = rootId;
    return data;
  }
}

class SortFilterBundle {
  final List<ColumnItemEntity> sortableColumnItems;
  final List<ColumnItemEntity> columnItems;
  final List<CustomFindEntity> filterList;
  final List<DicProEntity> dicProList;
  String? dataClass;

  SortFilterBundle(this.sortableColumnItems, this.filterList, this.dicProList, this.columnItems);

  get hasDicPro => dataClass?.isNotEmpty == true && dicProList.isNotEmpty;
}