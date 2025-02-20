class OnlineUser {
  String? id;
  String? username;
  String? avatar;

  OnlineUser({this.id, this.username, this.avatar});

  OnlineUser.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    username = json['Username'];
    avatar = json['Avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Username'] = this.username;
    data['Avatar'] = this.avatar;
    return data;
  }
}