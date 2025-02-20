import 'package:dealful_mall/model/online_user.dart';

class CommentEntity {
  String? id;
  String? comment;
  String? timeAgo;
  List<CommentEntity>? replyComments;
  OnlineUser? userInfo;

  CommentEntity(
      {this.id, this.comment, this.timeAgo, this.replyComments, this.userInfo});

  CommentEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    comment = json['Comment'];
    timeAgo = json['TimeAgo'];
    if (json['ReplyComments'] != null) {
      replyComments = [];
      json['ReplyComments'].forEach((v) {
        replyComments!.add(CommentEntity.fromJson(v));
      });
    }
    userInfo = json['UserInfo'] != null
        ? OnlineUser.fromJson(json['UserInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Comment'] = this.comment;
    data['TimeAgo'] = this.timeAgo;
    if (this.replyComments != null) {
      data['ReplyComments'] =
          this.replyComments!.map((v) => v.toJson()).toList();
    }
    if (this.userInfo != null) {
      data['UserInfo'] = this.userInfo!.toJson();
    }
    return data;
  }
}
