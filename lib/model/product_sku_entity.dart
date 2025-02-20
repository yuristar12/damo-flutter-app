import 'package:dealful_mall/model/tiered_pricing_entity.dart';

class ProductSkuEntity {
  String? priceDiscounted;
  int? unitPrice;
  double? unitPriceYuan;
  int? minNum;
  String? discountRate;
  String? price;
  String? productId;
  int? stock;
  List<TieredPricing>? tieredPricing;

  ProductSkuEntity(
      {this.priceDiscounted,
      this.unitPrice,
      this.unitPriceYuan,
      this.minNum,
      this.discountRate,
      this.price,
      this.productId,
      this.stock,
      this.tieredPricing});

  ProductSkuEntity.fromJson(Map<String, dynamic> json) {
    priceDiscounted = json['PriceDiscounted'];
    unitPrice = json['UnitPrice'];
    unitPriceYuan = json['UnitPriceYuan'];
    minNum = json['MinNum'];
    discountRate = json['DiscountRate'];
    price = json['Price'];
    productId = json['ProductId'];
    stock = json['Stock'];
    if (json['TieredPricing'] != null) {
      tieredPricing = [];
      json['TieredPricing'].forEach((v) {
        tieredPricing!.add(TieredPricing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PriceDiscounted'] = this.priceDiscounted;
    data['UnitPrice'] = this.unitPrice;
    data['UnitPriceYuan'] = this.unitPriceYuan;
    data['MinNum'] = this.minNum;
    data['DiscountRate'] = this.discountRate;
    data['Price'] = this.price;
    data['ProductId'] = this.productId;
    data['Stock'] = this.stock;
    data['TieredPricing'] = this.tieredPricing?.map((v) => v.toJson()).toList();
    return data;
  }
}
