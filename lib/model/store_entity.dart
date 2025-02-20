class StoreEntity {
  String? id;
  String? companyName;
  String? storeName;
  String? avatar;
  String? mainProducts;
  String? businessType;
  String? mainMarkets;

  StoreEntity({
    this.id,
    this.companyName,
    this.storeName,
    this.avatar,
    this.mainProducts,
    this.businessType,
    this.mainMarkets,
  });

  factory StoreEntity.fromJson(Map<String, dynamic> json) {
    return StoreEntity(
      id: json['Id'],
      companyName: json['CompanyName'],
      storeName: json['StoreName'],
      avatar: json['Avatar'],
      mainProducts: json['MainProducts'],
      businessType: json['BusinessType'],
      mainMarkets: json['MainMarkets'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'storeName': storeName,
      'avatar': avatar,
      'mainProducts': mainProducts,
      'businessType': businessType,
      'mainMarkets': mainMarkets,
    };
  }
}
