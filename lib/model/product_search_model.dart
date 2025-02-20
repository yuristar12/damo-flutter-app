import 'package:dealful_mall/model/search_bean.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_search_model.g.dart';
@JsonSerializable()
class ProductSearchModel {
  @JsonKey(name: 'CategoryId')
  String? categoryId;

  final List<String> _brandIds = [];

  @JsonKey(name: 'SearchIndex')
  String? searchIndex;

  @JsonKey(name: 'CompanyId')
  String? companyId;

  @JsonKey(name: 'IsPromoted')
  int? isPromoted;

  @JsonKey(name: 'IsSpecialOffer')
  int? isSpecialOffer;

  @JsonKey(includeToJson: false, includeFromJson: false)
  int? minPrice;

  @JsonKey(includeToJson: false, includeFromJson: false)
  int? maxPrice;

  final List<SearchBean> customSearchBeans = [];
  ProductSearchModel({this.categoryId, this.searchIndex});

  Map<String, dynamic> toJson() => _$ProductSearchModelToJson(this);

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) => _$ProductSearchModelFromJson(json);

  ProductSearchModel copy() {
    var result = ProductSearchModel.fromJson(toJson());
    result.minPrice = minPrice;
    result.maxPrice = maxPrice;
    result.customSearchBeans.clear();
    result.customSearchBeans.addAll(customSearchBeans);
    result._brandIds.clear();
    result._brandIds.addAll(_brandIds);
    return result;
  }

  Map<String, dynamic> toSearchList() {
    List<SearchBean> searchBeans = [];
    appendSearch(searchBeans, "CategoryId", categoryId);
    for(String brandid in _brandIds) {
      appendSearch(searchBeans, "BrandId", brandid);
    }
    appendSearch(searchBeans, "SearchKeyword", searchIndex);
    appendSearch(searchBeans, "companyId", companyId);
    appendSearch(searchBeans, "IsPromoted", XUtils.textOf(isPromoted));
    appendSearch(searchBeans, "IsSpecialOffer", XUtils.textOf(isSpecialOffer));
    appendSearch(searchBeans, "MinPrice", XUtils.textOf(minPrice));
    appendSearch(searchBeans, "MaxPrice", XUtils.textOf(maxPrice));
    searchBeans.addAll(customSearchBeans);
    return {
      "SearchList": searchBeans
    };
  }

  void appendSearch(List<SearchBean> searchBeans, String key, String? value) {
    if(value?.isNotEmpty == true) {
      searchBeans.add(SearchBean(searchKey: key, searchValue: value));
    }
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSearchModel &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          _brandIds == other._brandIds &&
          searchIndex == other.searchIndex &&
          isPromoted == other.isPromoted &&
          isSpecialOffer == other.isSpecialOffer &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          listEquals(customSearchBeans, other.customSearchBeans) &&
  listEquals(_brandIds, other._brandIds);

  @override
  int get hashCode =>
      categoryId.hashCode ^
      _brandIds.hashCode ^
      searchIndex.hashCode ^
      isPromoted.hashCode ^
      isSpecialOffer.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode;

  void copyFrom(ProductSearchModel tempSearchModel) {
    this.categoryId = tempSearchModel.categoryId;
    this._brandIds.clear();
    this._brandIds.addAll(tempSearchModel._brandIds);
    this.searchIndex = tempSearchModel.searchIndex;
    this.isPromoted = tempSearchModel.isPromoted;
    this.isSpecialOffer = tempSearchModel.isSpecialOffer;
    this.minPrice = tempSearchModel.minPrice;
    this.maxPrice = tempSearchModel.maxPrice;
    customSearchBeans.clear();
    customSearchBeans.addAll(tempSearchModel.customSearchBeans);
  }

  bool hasFilter() {
    return categoryId != null || _brandIds.isNotEmpty || isPromoted != null || isSpecialOffer != null || minPrice != null || maxPrice != null;
  }

  void addBrandId(String? brandId) {
    if(brandId != null) {
      if(!_brandIds.contains(brandId)) {
        _brandIds.add(brandId);
      }
    }
  }
  
  void removeBrandId(String? brandId) {
    _brandIds.remove(brandId);
  }

  bool isBrandSelected(String? brandId){
    return _brandIds.contains(brandId);
  }

  void clearBrand() {
    _brandIds.clear();
  }
}

