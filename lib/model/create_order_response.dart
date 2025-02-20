import 'package:dealful_mall/model/order_shipping.dart';

class CreateOrderResponse {
  String? paymentMethod;
  String? orderNumber;
  dynamic buyerId;
  String? buyerType;
  String? paymentStatus;
  dynamic branchId;
  String? orderStatus;
  List<String>? orderNos;
  List<String>? orderIds;
  OrderShipping? ordersShipping;
  PaymentOrder? paymentOrder;

  CreateOrderResponse(
      {this.paymentMethod,
        this.orderNumber,
        this.buyerId,
        this.buyerType,
        this.paymentStatus,
        this.branchId,
        this.orderStatus,
        this.ordersShipping,
        this.paymentOrder});

  CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['PaymentMethod'];
    orderNumber = json['OrderNumber'];
    buyerId = json['BuyerId'];
    buyerType = json['BuyerType'];
    paymentStatus = json['PaymentStatus'];
    branchId = json['BranchId'];
    orderStatus = json['OrderStatus'];
    ordersShipping = json['OrdersShipping'] != null
        ? new OrderShipping.fromJson(json['OrdersShipping'])
        : null;
    var object = json['PaymentOrder'];
    if(object != null) {
      if(object is String) {
        paymentOrder = PaymentOrder(orderInfo: object);
      } else if(object is Map<String, dynamic>) {
        paymentOrder = PaymentOrder.fromJson(object);
      }
    }
    if(json["OrderNos"] != null) {
      orderNos = json["OrderNos"].cast<String>();
    }
    if(json["orderIds"] != null) {
      orderIds = json["orderIds"].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PaymentMethod'] = this.paymentMethod;
    data['OrderNumber'] = this.orderNumber;
    data['BuyerId'] = this.buyerId;
    data['BuyerType'] = this.buyerType;
    data['PaymentStatus'] = this.paymentStatus;
    data['BranchId'] = this.branchId;
    data['OrderStatus'] = this.orderStatus;
    if (this.ordersShipping != null) {
      data['OrdersShipping'] = this.ordersShipping!.toJson();
    }
    if (this.paymentOrder != null) {
      data['PaymentOrder'] = this.paymentOrder!.toJson();
    }
    return data;
  }
}

class PaymentOrder {
  String? createTime;
  String? updateTime;
  String? id;
  String? status;
  /// Alipay OrderInfo
  String? orderInfo;
  String? appId;
  String? partnerId;
  String? prepayId;
  String? package;
  String? nonceStr;
  String? timeStamp;
  String? sign;
  List<Links>? links;

  PaymentOrder(
      {this.createTime, this.updateTime, this.id, this.status, this.links, this.orderInfo, this.appId});

  PaymentOrder.fromJson(Map<String, dynamic> json) {
    createTime = json['create_time'];
    updateTime = json['update_time'];
    id = json['id'];
    status = json['status'];
    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    appId = json['AppId'];
    partnerId = json['PartnerId'];
    prepayId = json['PrepayId'];
    package = json['Package'];
    nonceStr = json['NonceStr'];
    timeStamp = json['TimeStamp'];
    sign = json['Sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['id'] = this.id;
    data['status'] = this.status;
    if(this.orderInfo != null) {
      data['OrderInfo'] = this.orderInfo;
    }
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['AppId'] = this.appId;
    data['PartnerId'] = this.partnerId;
    data['PrepayId'] = this.prepayId;
    data['Package'] = this.package;
    data['NonceStr'] = this.nonceStr;
    data['TimeStamp'] = this.timeStamp;
    data['Sign'] = this.sign;
    return data;
  }
}

class Links {
  String? href;
  String? rel;
  String? method;

  Links({this.href, this.rel, this.method});

  Links.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    rel = json['rel'];
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    data['rel'] = this.rel;
    data['method'] = this.method;
    return data;
  }
}
