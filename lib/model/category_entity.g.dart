// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryEntity _$CategoryEntityFromJson(Map<String, dynamic> json) =>
    CategoryEntity(
      id: json['Id'] as String?,
      description: json['Description'] as String?,
      image: json['Image'] as String?,
      name: json['Name'] as String?,
      children: (json['categoriesVOList'] as List<dynamic>?)
          ?.map((e) => CategoryEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      isSelect: json['isSelect'] as bool?,
      thirdName: json['secondName'] as String?,
      fourthName: json['thirdName'] as String?,
    )
      ..parentId = json['ParentId'] as String?
      ..slug = json['Slug'] as String?
      ..categories = (json['Categories'] as List<dynamic>?)
          ?.map((e) => CategoryEntity.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$CategoryEntityToJson(CategoryEntity instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Description': instance.description,
      'Image': instance.image,
      'Name': instance.name,
      'ParentId': instance.parentId,
      'Slug': instance.slug,
      'categoriesVOList': instance.children,
      'Categories': instance.categories,
      'isSelect': instance.isSelect,
      'secondName': instance.thirdName,
      'thirdName': instance.fourthName,
    };
