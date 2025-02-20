import 'package:dealful_mall/model/company_entity.dart';
import 'package:dealful_mall/model/order_product.dart';

class CartBean {
  String? id;
  String? productId;
  String? productName;
  String? productImage;
  String? productVariations;
  String? userId;
  String? userName;
  int? unitPrice;
  dynamic unitPriceYuan;
  String? showUnitPrice;
  CompanyEntity? company;
  int? num;
  bool checked = false;
  int changeTag = 0;
  List<String>? variationOptionIds;
  CartBean(
      {this.id,
        this.productId,
        this.productName,
        this.productImage,
        this.productVariations,
        this.userId,
        this.userName,
        this.unitPrice,
        this.showUnitPrice,
        this.num,
        this.company,
        this.variationOptionIds
      });

  CartBean.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productId = json['ProductId'];
    productName = json['ProductName'];
    productImage = json['ProductImage'];
    productVariations = json['ProductVariations'];
    userId = json['UserId'];
    userName = json['UserName'];
    unitPrice = json['UnitPrice'];
    unitPriceYuan = json['UnitPriceYuan'];
    showUnitPrice = json['ShowUnitPrice'];
    num = json['Num'];
    if(json["Company"] != null) {
      company = CompanyEntity.fromJson(json["Company"]);
    }
    if(json['VariationOptionIds'] != null) {
      variationOptionIds = json['VariationOptionIds'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ProductId'] = this.productId;
    data['ProductName'] = this.productName;
    data['ProductImage'] = this.productImage;
    data['ProductVariations'] = this.productVariations;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['UnitPrice'] = this.unitPrice;
    data['ShowUnitPrice'] = this.showUnitPrice;
    data['Num'] = this.num;
    return data;
  }

  OrderProduct packOrder() {
    return OrderProduct(
      sellerId: company?.id,
      productId: productId,
      productTitle: productName,
      productQuantity: num,
      shoppingCartId: id,
      skuIds: variationOptionIds
    );
  }
}
