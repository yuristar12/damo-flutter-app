import 'package:dealful_mall/model/online_user.dart';

class ReviewEntity {
  String? id;
  OnlineUser? userInfo;
  int? rating;
  String? review;
  String? timeAgo;

  ReviewEntity(
      {this.id, this.userInfo, this.rating, this.review, this.timeAgo});

  ReviewEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    userInfo = json['UserInfo'] != null
        ? new OnlineUser.fromJson(json['UserInfo'])
        : null;
    rating = json['Rating'];
    review = json['Review'];
    timeAgo = json['TimeAgo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    if (this.userInfo != null) {
      data['UserInfo'] = this.userInfo!.toJson();
    }
    data['Rating'] = this.rating;
    data['Review'] = this.review;
    data['TimeAgo'] = this.timeAgo;
    return data;
  }
}

