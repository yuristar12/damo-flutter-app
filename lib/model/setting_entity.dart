class SettingEntity {
  String? id;
  String? dataText;
  dynamic byVal;
  bool selected = false;
  SettingEntity({this.id, this.dataText, this.byVal});

  SettingEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    dataText = json['DataText'];
    byVal = json['ByVal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['DataText'] = dataText;
    data['ByVal'] = byVal;
    return data;
  }
}