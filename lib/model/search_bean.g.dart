// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchBean _$SearchBeanFromJson(Map<String, dynamic> json) => SearchBean(
      searchKey: json['SearchKey'] as String?,
      searchValue: json['SearchValue'] as String?,
      searchType: (json['SearchType'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SearchBeanToJson(SearchBean instance) =>
    <String, dynamic>{
      'SearchKey': instance.searchKey,
      'SearchValue': instance.searchValue,
      'SearchType': instance.searchType,
    };
