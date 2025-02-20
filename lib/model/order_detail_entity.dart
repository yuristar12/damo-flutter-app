import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/company_entity.dart';
import 'package:dealful_mall/model/order_product.dart';

class OrderDetailEntity {
  String? id;
  String? orderNumber;
  String? buyerId;
  String? buyerType;
  String? priceSubtotal;
  dynamic priceVat;
  String? priceShipping;
  String? priceTotal;
  String? priceCurrency;
  String? couponCode;
  String? couponProducts;
  dynamic couponDiscount;
  dynamic couponDiscountRate;
  dynamic couponSellerId;
  dynamic status;
  String? shippedStatus;
  String? transactionFeeRate;
  dynamic transactionFee;
  String? globalTaxesData;
  String? paymentMethod;
  String? paymentStatus;
  String? shipping;
  String? affiliateData;
  String? updatedAt;
  String? createdAt;
  String? branchId;
  String? buyer;
  String? orderStatus;
  String? username;
  String? email;
  String? phoneNumber;
  String? avatar;
  CompanyEntity? store;
  List<OrderProduct>? orderProducts;
  List<OrderAddress>? ordersAddress;

  OrderDetailEntity(
      {this.id,
        this.orderNumber,
        this.buyerId,
        this.buyerType,
        this.priceSubtotal,
        this.priceVat,
        this.priceShipping,
        this.priceTotal,
        this.priceCurrency,
        this.couponCode,
        this.couponProducts,
        this.couponDiscount,
        this.couponDiscountRate,
        this.couponSellerId,
        this.status,
        this.shippedStatus,
        this.transactionFeeRate,
        this.transactionFee,
        this.globalTaxesData,
        this.paymentMethod,
        this.paymentStatus,
        this.shipping,
        this.affiliateData,
        this.updatedAt,
        this.createdAt,
        this.branchId,
        this.buyer,
        this.orderStatus,
        this.username,
        this.email,
        this.phoneNumber,
        this.avatar,
        this.orderProducts});

  OrderDetailEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    orderNumber = json['OrderNumber'];
    buyerId = json['BuyerId'];
    buyerType = json['BuyerType'];
    priceSubtotal = json['PriceSubtotal'];
    priceVat = json['PriceVat'];
    priceShipping = json['PriceShipping'];
    priceTotal = json['PriceTotal'];
    priceCurrency = json['PriceCurrency'];
    couponCode = json['CouponCode'];
    couponProducts = json['CouponProducts'];
    couponDiscount = json['CouponDiscount'];
    couponDiscountRate = json['CouponDiscountRate'];
    couponSellerId = json['CouponSellerId'];
    status = json['Status'];
    shippedStatus = json['ShippedStatus'];
    transactionFeeRate = json['TransactionFeeRate'];
    transactionFee = json['TransactionFee'];
    globalTaxesData = json['GlobalTaxesData'];
    paymentMethod = json['PaymentMethod'];
    paymentStatus = json['PaymentStatus'];
    shipping = json['Shipping'];
    affiliateData = json['AffiliateData'];
    updatedAt = json['UpdatedAt'];
    createdAt = json['CreatedAt'];
    branchId = json['BranchId'];
    buyer = json['Buyer'];
    orderStatus = json['OrderStatus'];
    username = json['Username'];
    email = json['Email'];
    phoneNumber = json['PhoneNumber'];
    avatar = json['Avatar'];
    if(json["Store"] != null) {
      store = CompanyEntity.fromJson(json["Store"]);
    }
    if (json['Products'] != null) {
      orderProducts = [];
      json['Products'].forEach((v) {
        orderProducts!.add(OrderProduct.fromJson(v));
      });
    }
    if (json['OrdersAddress'] != null) {
      ordersAddress = [];
      json['OrdersAddress'].forEach((v) {
        ordersAddress!.add(OrderAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['OrderNumber'] = this.orderNumber;
    data['BuyerId'] = this.buyerId;
    data['BuyerType'] = this.buyerType;
    data['PriceSubtotal'] = this.priceSubtotal;
    data['PriceVat'] = this.priceVat;
    data['PriceShipping'] = this.priceShipping;
    data['PriceTotal'] = this.priceTotal;
    data['PriceCurrency'] = this.priceCurrency;
    data['CouponCode'] = this.couponCode;
    data['CouponProducts'] = this.couponProducts;
    data['CouponDiscount'] = this.couponDiscount;
    data['CouponDiscountRate'] = this.couponDiscountRate;
    data['CouponSellerId'] = this.couponSellerId;
    data['Status'] = this.status;
    data['ShippedStatus'] = this.shippedStatus;
    data['TransactionFeeRate'] = this.transactionFeeRate;
    data['TransactionFee'] = this.transactionFee;
    data['GlobalTaxesData'] = this.globalTaxesData;
    data['PaymentMethod'] = this.paymentMethod;
    data['PaymentStatus'] = this.paymentStatus;
    data['Shipping'] = this.shipping;
    data['AffiliateData'] = this.affiliateData;
    data['UpdatedAt'] = this.updatedAt;
    data['CreatedAt'] = this.createdAt;
    data['BranchId'] = this.branchId;
    data['Buyer'] = this.buyer;
    data['OrderStatus'] = this.orderStatus;
    data['Username'] = this.username;
    data['Email'] = this.email;
    data['PhoneNumber'] = this.phoneNumber;
    data['Avatar'] = this.avatar;
    if (this.orderProducts != null) {
      data['Products'] =
          this.orderProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class OrderAddress {
  String? title;
  AddressEntity? addresses;

  OrderAddress({this.title, this.addresses});

  OrderAddress.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    addresses = json['addresses'] != null
        ? new AddressEntity.fromJson(json['addresses'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.toJson();
    }
    return data;
  }


}



