class CustomItemEntity {
  String? itemId;
  String? itemName;

  CustomItemEntity({this.itemId, this.itemName});

  CustomItemEntity.fromJson(Map<String, dynamic> json) {
    itemId = json['ItemId'];
    itemName = json['ItemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemId'] = this.itemId;
    data['ItemName'] = this.itemName;
    return data;
  }
}
