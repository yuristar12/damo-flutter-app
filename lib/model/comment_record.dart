class CommentRecord {
  String? postId;
  String? email;
  String? name;
  String? comment;

  CommentRecord({this.postId, this.email, this.name, this.comment});

  CommentRecord.fromJson(Map<String, dynamic> json) {
    postId = json['PostId'];
    email = json['Email'];
    name = json['Name'];
    comment = json['Comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PostId'] = this.postId;
    data['Email'] = this.email;
    data['Name'] = this.name;
    data['Comment'] = this.comment;
    return data;
  }
}
