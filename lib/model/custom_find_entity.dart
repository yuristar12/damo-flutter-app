import 'package:dealful_mall/model/custom_item_entity.dart';

class CustomFindEntity {
  String? customField;
  String? customName;
  String? selectedItemId;
  List<CustomItemEntity>? itemList;

  CustomFindEntity({this.customField, this.customName, this.itemList});

  CustomFindEntity.fromJson(Map<String, dynamic> json) {
    customField = json['CustomField'];
    customName = json['CustomName'];
    if (json['ItemList'] != null) {
      itemList = [];
      json['ItemList'].forEach((v) {
        itemList!.add(CustomItemEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomField'] = this.customField;
    data['CustomName'] = this.customName;
    if (this.itemList != null) {
      data['ItemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
