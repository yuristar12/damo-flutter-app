class LabelEntity {
  String? label;
  dynamic value;

  LabelEntity({this.label, this.value});

  LabelEntity.fromJson(Map<String, dynamic> json) {
    label = json['Label'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Label'] = this.label;
    data['Value'] = this.value;
    return data;
  }
}
