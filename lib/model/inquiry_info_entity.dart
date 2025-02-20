import 'package:dealful_mall/model/label_entity.dart';

class InquiryInfoEntity {
  List<LabelEntity>? quantityUnit;
  String? inquiryReceiver;

  InquiryInfoEntity({this.quantityUnit, this.inquiryReceiver});

  InquiryInfoEntity.fromJson(Map<String, dynamic> json) {
    if (json['QuantityUnit'] != null) {
      quantityUnit = [];
      json['QuantityUnit'].forEach((v) {
        quantityUnit!.add(LabelEntity.fromJson(v));
      });
    }
    inquiryReceiver = json['InquiryReceiver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.quantityUnit != null) {
      data['QuantityUnit'] = this.quantityUnit!.map((v) => v.toJson()).toList();
    }
    data['InquiryReceiver'] = this.inquiryReceiver;
    return data;
  }
}