import 'package:dealful_mall/model/product_entity.dart';

class CategoryProductEntity {
  String? categoryName;
  String? categoryId;
  List<ProductEntity>? storeProductsVO;

  CategoryProductEntity({this.categoryName, this.storeProductsVO});

  CategoryProductEntity.fromJson(Map<String, dynamic> json) {
    categoryName = json['CategoryName'];
    categoryId = json['CategoryId'];
    if (json['StoreProductsVO'] != null) {
      storeProductsVO = [];
      json['StoreProductsVO'].forEach((v) {
        storeProductsVO!.add(ProductEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryName'] = this.categoryName;
    data['CategoryId'] = this.categoryId;
    if (this.storeProductsVO != null) {
      data['StoreProductsVO'] =
          this.storeProductsVO!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
