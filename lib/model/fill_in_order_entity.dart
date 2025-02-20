import 'package:dealful_mall/model/cart_bean.dart';

class FillInOrderEntity {
	int? grouponRulesId;
	double? actualPrice;
	double? orderTotalPrice;
  String? cartId;
	int? couponId;
	double? goodsTotalPrice;
	String? addressId;
	int? grouponPrice;
	var couponPrice;
	int? availableCouponLength;
	int? freightPrice;
	List<CartBean>? checkedGoodsList;

	FillInOrderEntity({this.grouponRulesId, this.actualPrice, this.orderTotalPrice, this.cartId, this.couponId, this.goodsTotalPrice, this.addressId, this.grouponPrice, this.couponPrice, this.availableCouponLength, this.freightPrice, this.checkedGoodsList});

	FillInOrderEntity.fromJson(Map<String, dynamic> json) {
		grouponRulesId = json['grouponRulesId'];
		actualPrice = json['actualPrice'];
		orderTotalPrice = json['orderTotalPrice'];
		cartId = json['cartId'];
		couponId = json['couponId'];
		goodsTotalPrice = json['goodsTotalPrice'];
		addressId = json['addressId'];
		grouponPrice = json['grouponPrice'];
		couponPrice = json['couponPrice'];
		availableCouponLength = json['availableCouponLength'];
		freightPrice = json['freightPrice'];
		if (json['checkedGoodsList'] != null) {
			checkedGoodsList = [];
      (json['checkedGoodsList'] as List).forEach((v) { checkedGoodsList!.add(new CartBean.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['grouponRulesId'] = this.grouponRulesId;
		data['actualPrice'] = this.actualPrice;
		data['orderTotalPrice'] = this.orderTotalPrice;
		data['cartId'] = this.cartId;
		data['couponId'] = this.couponId;
		data['goodsTotalPrice'] = this.goodsTotalPrice;
		data['addressId'] = this.addressId;
		data['grouponPrice'] = this.grouponPrice;
		data['couponPrice'] = this.couponPrice;
		data['availableCouponLength'] = this.availableCouponLength;
		data['freightPrice'] = this.freightPrice;
		if (this.checkedGoodsList != null) {
      data['checkedGoodsList'] =  this.checkedGoodsList!.map((v) => v.toJson()).toList();
    }
		return data;
	}
}
