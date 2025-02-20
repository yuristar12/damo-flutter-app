class QuoteEntity {
  String? id;
  String? productTitle;
  int? productQuantity;
  String? status;
  String? image;
  String? showPrice;
  String? showStatus;
  String? updateTimeAgo;

  QuoteEntity(
      {this.id,
        this.productTitle,
        this.productQuantity,
        this.status,
        this.image,
        this.showPrice,
        this.showStatus,
        this.updateTimeAgo});

  QuoteEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productTitle = json['ProductTitle'];
    productQuantity = json['ProductQuantity'];
    status = json['Status'];
    image = json['Image'];
    showPrice = json['ShowPrice'];
    showStatus = json['ShowStatus'];
    updateTimeAgo = json['UpdateTimeAgo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ProductTitle'] = this.productTitle;
    data['ProductQuantity'] = this.productQuantity;
    data['Status'] = this.status;
    data['Image'] = this.image;
    data['ShowPrice'] = this.showPrice;
    data['ShowStatus'] = this.showStatus;
    data['UpdateTimeAgo'] = this.updateTimeAgo;
    return data;
  }
}
