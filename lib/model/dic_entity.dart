class DicEntity {
  String? dataValue1;
  String? dataValue2;
  String? dataValue3;
  String? dataValue4;
  String? dataValue5;
  String? dataValue6;
  String? dataValue7;
  dynamic dataVisible;
  dynamic isEdit;
  String? byVal;
  String? dataText;

  DicEntity(
      {this.dataValue1,
      this.dataValue2,
      this.dataValue3,
      this.dataValue4,
      this.dataValue5,
      this.dataValue6,
      this.dataValue7,
      this.dataVisible,
      this.isEdit,
      this.byVal,
      this.dataText});

  DicEntity.fromJson(Map<String, dynamic> json) {
    dataValue1 = json['DataValue1'];
    dataValue2 = json['DataValue2'];
    dataValue3 = json['DataValue3'];
    dataValue4 = json['DataValue4'];
    dataValue5 = json['DataValue5'];
    dataValue6 = json['DataValue6'];
    dataValue7 = json['DataValue7'];
    dataVisible = json['data_visible'];
    isEdit = json['IsEdit'];
    byVal = json['ByVal'];
    dataText = json['DataText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DataValue1'] = dataValue1;
    data['DataValue2'] = dataValue2;
    data['DataValue3'] = dataValue3;
    data['DataValue4'] = dataValue4;
    data['DataValue5'] = dataValue5;
    data['DataValue6'] = dataValue6;
    data['DataValue7'] = dataValue7;
    data['data_visible'] = dataVisible;
    data['IsEdit'] = isEdit;
    data['ByVal'] = byVal;
    data['DataText'] = dataText;
    return data;
  }


}
