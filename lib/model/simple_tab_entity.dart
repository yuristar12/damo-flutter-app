class SimpleTabEntity {
  int? count;
  String? title;

  SimpleTabEntity({this.count, this.title});

  SimpleTabEntity.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    title = json['Title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['Title'] = this.title;
    return data;
  }
}
