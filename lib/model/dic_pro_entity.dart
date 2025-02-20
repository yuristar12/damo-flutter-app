/// 词典实例
class DicProEntity {
  String? dataClass;
  String? dataType;
  String? byVal;

  DicProEntity({this.dataClass, this.dataType, this.byVal});

  DicProEntity.fromJson(Map<String, dynamic> json) {
    dataClass = json['DataClass'];
    dataType = json['DataType'];
    byVal = json['ByVal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DataClass'] = dataClass;
    data['DataType'] = dataType;
    data['ByVal'] = byVal;
    return data;
  }
}
