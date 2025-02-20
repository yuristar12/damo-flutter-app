class PaymentSetting {
  int? id;
  String? name;
  String? nameKey;
  String? logos;

  PaymentSetting({this.id, this.name, this.nameKey, this.logos});

  PaymentSetting.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    nameKey = json['NameKey'];
    logos = json['Logos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['NameKey'] = this.nameKey;
    data['Logos'] = this.logos;
    return data;
  }
}
