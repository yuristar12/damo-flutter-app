// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSearchModel _$ProductSearchModelFromJson(Map<String, dynamic> json) =>
    ProductSearchModel(
      categoryId: json['CategoryId'] as String?,
      searchIndex: json['SearchIndex'] as String?,
    )
      ..companyId = json['CompanyId'] as String?
      ..isPromoted = (json['IsPromoted'] as num?)?.toInt()
      ..isSpecialOffer = (json['IsSpecialOffer'] as num?)?.toInt();

Map<String, dynamic> _$ProductSearchModelToJson(ProductSearchModel instance) =>
    <String, dynamic>{
      'CategoryId': instance.categoryId,
      'SearchIndex': instance.searchIndex,
      'CompanyId': instance.companyId,
      'IsPromoted': instance.isPromoted,
      'IsSpecialOffer': instance.isSpecialOffer,
    };
