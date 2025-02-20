class KeyEntity {
  String? key;
  String? id;
  String? title;

  KeyEntity({this.key, this.id, this.title});

  KeyEntity.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    id = json['Id'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Title'] = this.title;
    data['Id'] = this.id;
    return data;
  }
}
