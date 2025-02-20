import 'package:dealful_mall/model/simple_tab_entity.dart';

class SupplierProfile {
  String? id;
  String? storeName;
  String? slug;
  String? companyName;
  String? companyType;
  dynamic coverImageType;
  String? avatarUrl;
  String? coverImageUrl;
  String? companyRegisterAgo;
  dynamic profileRating;
  String? country;
  String? soldNum;
  String? followers;
  bool isFollower = false;
  SimpleTabEntity? productTab;
  SupplierProfile(
      {this.id,
      this.storeName,
      this.slug,
      this.companyName,
      this.companyType,
      this.coverImageType,
      this.avatarUrl,
      this.coverImageUrl,
      this.companyRegisterAgo,
      this.profileRating,
      this.country,
      this.soldNum,
      this.followers,
      this.productTab,
      this.isFollower = false});

  SupplierProfile.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    storeName = json['StoreName'];
    slug = json['Slug'];
    companyName = json['CompanyName'];
    companyType = json['CompanyType'];
    coverImageType = json['CoverImageType'];
    avatarUrl = json['AvatarUrl'];
    coverImageUrl = json['CoverImageUrl'];
    companyRegisterAgo = json['CompanyRegisterAgo'];
    profileRating = json['ProfileRating'];
    country = json['Country'];
    soldNum = json['SoldNum'];
    followers = json['Followers'];
    isFollower = json['IsFollower'] == true;
    if (json['ProductTab'] != null) {
      productTab = SimpleTabEntity.fromJson(json['ProductTab']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['StoreName'] = this.storeName;
    data['Slug'] = this.slug;
    data['CompanyName'] = this.companyName;
    data['CompanyType'] = this.companyType;
    data['CoverImageType'] = this.coverImageType;
    data['AvatarUrl'] = this.avatarUrl;
    data['CoverImageUrl'] = this.coverImageUrl;
    data['CompanyRegisterAgo'] = this.companyRegisterAgo;
    data['ProfileRating'] = this.profileRating;
    data['Country'] = this.country;
    data['SoldNum'] = this.soldNum;
    data['Followers'] = this.followers;
    data['IsFollower'] = this.isFollower;
    return data;
  }

  int getProductCount() {
    return productTab?.count ?? 0;
  }
}
