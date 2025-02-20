import 'package:json_annotation/json_annotation.dart';

part 'category_entity.g.dart';

@JsonSerializable()
class CategoryEntity {
  @JsonKey(name: 'Id')
  String? id;
  @JsonKey(name: 'Description')
  String? description;
  @JsonKey(name: 'Image')
  String? image;
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'ParentId')
  String? parentId;
  @JsonKey(name: 'Slug')
  String? slug;
  @JsonKey(name: 'categoriesVOList')
  List<CategoryEntity>? children;
  @JsonKey(name: 'Categories')
  List<CategoryEntity>? categories;
  @JsonKey(name: 'isSelect')
  bool? isSelect;
  @JsonKey(name: 'secondName')
  String? thirdName;
  @JsonKey(name: 'thirdName')
  String? fourthName;

  CategoryEntity({
    this.id,
    this.description,
    this.image,
    this.name,
    this.children,
    this.isSelect,
    this.thirdName,
    this.fourthName
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> e) =>
      _$CategoryEntityFromJson(e);

  Map<String, dynamic> toJson() => _$CategoryEntityToJson(this);
}
