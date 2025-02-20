import 'company_entity.dart';

class SimpleCartBean {
  String? id;
  CompanyEntity? company;
  bool checked = false;
  List<ShoppingCartProduct>? shoppingCartProduct;

  SimpleCartBean({this.id, this.company, this.shoppingCartProduct});

  SimpleCartBean.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    company = json['Company'] != null
        ? CompanyEntity.fromJson(json['Company'])
        : null;
    if (json['ShoppingCartProduct'] != null) {
      shoppingCartProduct = [];
      json['ShoppingCartProduct'].forEach((v) {
        shoppingCartProduct!.add(ShoppingCartProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    if (this.company != null) {
      data['Company'] = this.company!.toJson();
    }
    if (this.shoppingCartProduct != null) {
      data['ShoppingCartProduct'] =
          this.shoppingCartProduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShoppingCartProduct {
  String? id;
  int? num;
  Product? product;
  String? productVariations;
  SkuInfo? skuInfo;
  bool checked = false;
  bool? isSuitableVehicle;
  List<String>? variationOptionIds;
  int changeTag = 0;

  ShoppingCartProduct(
      {this.id,
      this.num,
      this.product,
      this.productVariations,
      this.skuInfo,
      this.isSuitableVehicle});

  ShoppingCartProduct.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    num = json['Num'];
    product =
        json['Product'] != null ? new Product.fromJson(json['Product']) : null;
    productVariations = json['ProductVariations'];
    skuInfo =
        json['SkuInfo'] != null ? new SkuInfo.fromJson(json['SkuInfo']) : null;
    isSuitableVehicle = json['IsSuitableVehicle'];
    if(json['VariationOptionIds'] != null) {
      variationOptionIds = json['VariationOptionIds'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Num'] = this.num;
    if (this.product != null) {
      data['Product'] = this.product!.toJson();
    }
    data['ProductVariations'] = this.productVariations;
    if (this.skuInfo != null) {
      data['SkuInfo'] = this.skuInfo!.toJson();
    }
    data['IsSuitableVehicle'] = this.isSuitableVehicle;
    return data;
  }

  int? get unitPrice => skuInfo?.unitPrice ?? 0;

}

class Product {
  String? imageUrl;
  String? id;
  String? slug;
  String? title;

  Product({this.imageUrl, this.id, this.slug, this.title});

  Product.fromJson(Map<String, dynamic> json) {
    imageUrl = json['ImageUrl'];
    id = json['Id'];
    slug = json['Slug'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ImageUrl'] = this.imageUrl;
    data['Id'] = this.id;
    data['Slug'] = this.slug;
    data['Title'] = this.title;
    return data;
  }
}

class SkuInfo {
  String? priceDiscounted;
  int? unitPrice;
  double? unitPriceYuan;
  dynamic minNum;
  dynamic discountRate;
  String? price;
  dynamic stock;
  dynamic tieredPricing;

  SkuInfo(
      {this.priceDiscounted,
      this.unitPrice,
      this.unitPriceYuan,
      this.minNum,
      this.discountRate,
      this.price,
      this.stock,
      this.tieredPricing});

  SkuInfo.fromJson(Map<String, dynamic> json) {
    priceDiscounted = json['PriceDiscounted'];
    unitPrice = json['UnitPrice'];
    unitPriceYuan = json['UnitPriceYuan'];
    minNum = json['MinNum'];
    discountRate = json['DiscountRate'];
    price = json['Price'];
    stock = json['Stock'];
    tieredPricing = json['TieredPricing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PriceDiscounted'] = this.priceDiscounted;
    data['UnitPrice'] = this.unitPrice;
    data['UnitPriceYuan'] = this.unitPriceYuan;
    data['MinNum'] = this.minNum;
    data['DiscountRate'] = this.discountRate;
    data['Price'] = this.price;
    data['Stock'] = this.stock;
    data['TieredPricing'] = this.tieredPricing;
    return data;
  }
}
