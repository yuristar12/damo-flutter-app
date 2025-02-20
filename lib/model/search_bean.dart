
import 'package:json_annotation/json_annotation.dart';
part 'search_bean.g.dart';
@JsonSerializable()
class SearchBean{
  @JsonKey(name: 'SearchKey')
  String? searchKey;

  @JsonKey(name: 'SearchValue')
  String? searchValue;

  @JsonKey(name: 'SearchType')
  int? searchType;

  SearchBean({this.searchKey, this.searchValue, this.searchType = 0});

  Map<String, dynamic> toJson() => _$SearchBeanToJson(this);

  factory SearchBean.fromJson(Map<String, dynamic> json) => _$SearchBeanFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchBean &&
          runtimeType == other.runtimeType &&
          searchKey == other.searchKey &&
          searchValue == other.searchValue &&
          searchType == other.searchType;

  @override
  int get hashCode =>
      searchKey.hashCode ^ searchValue.hashCode ^ searchType.hashCode;
}