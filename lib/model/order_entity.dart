import 'package:dealful_mall/model/company_entity.dart';
import 'package:dealful_mall/model/order_product.dart';

class OrderEntity {
  String? id;
  String? orderNumber;
  String? priceSubtotal;
  String? priceShipping;
  String? priceTotal;
  dynamic status;
  String? paymentMethod;
  String? paymentStatus;
  String? createdAt;
  String? showStatus;
  String? showPaymentStatus;
  String? showPaymentMethod;
  String? updateAgo;
  CompanyEntity? store;
  List<OrderProduct>? products;

  OrderEntity(
      {this.id,
        this.orderNumber,
        this.priceSubtotal,
        this.priceShipping,
        this.priceTotal,
        this.status,
        this.paymentMethod,
        this.paymentStatus,
        this.createdAt,
        this.showStatus,
        this.showPaymentStatus,
        this.showPaymentMethod,
        this.updateAgo,
        this.store,
        this.products});

  OrderEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    orderNumber = json['OrderNumber'];
    priceSubtotal = json['PriceSubtotal'];
    priceShipping = json['PriceShipping'];
    priceTotal = json['PriceTotal'];
    status = json['Status'];
    paymentMethod = json['PaymentMethod'];
    paymentStatus = json['PaymentStatus'];
    createdAt = json['CreatedAt'];
    showStatus = json['ShowStatus'];
    showPaymentStatus = json['ShowPaymentStatus'];
    showPaymentMethod = json['ShowPaymentMethod'];
    updateAgo = json['UpdateAgo'];
    if(json["Store"] != null) {
      store = CompanyEntity.fromJson(json["Store"]);
    }
    if (json['Products'] != null) {
      products = [];
      json['Products'].forEach((v) {
        products!.add(new OrderProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['OrderNumber'] = this.orderNumber;
    data['PriceSubtotal'] = this.priceSubtotal;
    data['PriceShipping'] = this.priceShipping;
    data['PriceTotal'] = this.priceTotal;
    data['Status'] = this.status;
    data['PaymentMethod'] = this.paymentMethod;
    data['PaymentStatus'] = this.paymentStatus;
    data['CreatedAt'] = this.createdAt;
    data['ShowStatus'] = this.showStatus;
    data['ShowPaymentStatus'] = this.showPaymentStatus;
    data['ShowPaymentMethod'] = this.showPaymentMethod;
    data['UpdateAgo'] = this.updateAgo;
    if (this.products != null) {
      data['Products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String getStatusText() {
    if(paymentStatus == "payment_received") {
      return showStatus ?? "";
    } else {
      return showPaymentStatus ?? "";
    }
  }
}


