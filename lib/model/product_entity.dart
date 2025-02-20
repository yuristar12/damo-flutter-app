class ProductEntity {
  String? id;
  String? productType;
  String? price;
  String? priceDiscounted;
  String? currency;
  int? isPromoted;
  String? rating;
  int? pageviews;
  int? stock;
  String? name;
  String? username;
  List<String>? imageList;

  ProductEntity(
      {this.id,
        this.productType,
        this.price,
        this.priceDiscounted,
        this.currency,
        this.isPromoted,
        this.rating,
        this.pageviews,
        this.stock,
        this.name,
        this.username,});

  ProductEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productType = json['ProductType'];
    price = json['Price'];
    priceDiscounted = json['PriceDiscounted'];
    currency = json['Currency'];
    isPromoted = json['IsPromoted'];
    rating = json['Rating'];
    pageviews = json['Pageviews'];
    stock = json['Stock'];
    name = json['Name'];
    username = json['Username'];
    if(json['ImageList'] != null) {
      imageList = json['ImageList'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ProductType'] = this.productType;
    data['Price'] = this.price;
    data['PriceDiscounted'] = this.priceDiscounted;
    data['Currency'] = this.currency;
    data['IsPromoted'] = this.isPromoted;
    data['Rating'] = this.rating;
    data['Pageviews'] = this.pageviews;
    data['Stock'] = this.stock;
    data['Name'] = this.name;
    data['Username'] = this.username;
    data['ImageList'] = imageList;
    return data;
  }

  String? get image {
    if(imageList?.isNotEmpty == true) {
      return imageList?[0];
    } else {
      return "";
    }
  }
}
