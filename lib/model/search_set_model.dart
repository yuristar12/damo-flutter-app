import 'package:dealful_mall/model/search_bean.dart';
import 'package:flutter/foundation.dart';
class SearchSetModel {
  final List<SearchBean> filterBeans;

  const SearchSetModel(this.filterBeans);

  bool hasFilter() {
    return filterBeans.isNotEmpty;
  }

  SearchSetModel copy() {
    return SearchSetModel(List.from(filterBeans));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchSetModel &&
          runtimeType == other.runtimeType &&
          listEquals(filterBeans, other.filterBeans);

  @override
  int get hashCode => filterBeans.hashCode;

  void clear() {
    filterBeans.clear();
  }

  void applyFrom(SearchSetModel tempSearchSetModel) {
    filterBeans.clear();
    filterBeans.addAll(tempSearchSetModel.filterBeans);
  }

  void addSearch(SearchBean searchBean) {
    filterBeans.add(searchBean);
  }
}