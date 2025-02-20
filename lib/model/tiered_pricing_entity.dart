class TieredPricing {
  String? priceDiscounted;
  int? unitPrice;
  double? unitPriceYuan;
  int? minNum;
  int? maxNum;

  TieredPricing(
      {this.priceDiscounted,
        this.unitPrice,
        this.unitPriceYuan,
        this.minNum,
        this.maxNum});

  TieredPricing.fromJson(Map<String, dynamic> json) {
    priceDiscounted = json['PriceDiscounted'];
    unitPrice = json['UnitPrice'];
    unitPriceYuan = json['UnitPriceYuan'];
    minNum = json['MinNum'];
    maxNum = json['MaxNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PriceDiscounted'] = this.priceDiscounted;
    data['UnitPrice'] = this.unitPrice;
    data['UnitPriceYuan'] = this.unitPriceYuan;
    data['MinNum'] = this.minNum;
    data['MaxNum'] = this.maxNum;
    return data;
  }
}