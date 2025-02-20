import 'package:dealful_mall/model/order_shipping.dart';

class ShippingAddress {
  OrderShipping? ordersShipping;
  OrderShipping? ordersBilling;

  ShippingAddress({this.ordersShipping, this.ordersBilling});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    ordersShipping = json['OrdersShipping'] != null
        ? new OrderShipping.fromJson(json['OrdersShipping'])
        : null;
    ordersBilling = json['OrdersBilling'] != null
        ? new OrderShipping.fromJson(json['OrdersBilling'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrdersShipping'] = this.ordersShipping?.toJson();
    data['OrdersBilling'] = this.ordersBilling?.toJson();
    return data;
  }
}

