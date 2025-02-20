class OrderShipping {
  String? id;

  OrderShipping({this.id});

  OrderShipping.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    return data;
  }
}