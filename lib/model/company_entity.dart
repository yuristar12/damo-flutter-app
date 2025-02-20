class CompanyEntity {
  String? id;
  String? slug;
  String? storeName;
  String? companyName;
  String? createdAgo;
  String? country;
  String? avatarUrl;

  CompanyEntity(
      {this.id,
        this.slug,
        this.storeName,
        this.companyName,
        this.createdAgo,
        this.country,
        this.avatarUrl});

  CompanyEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    slug = json['Slug'];
    storeName = json['StoreName'];
    companyName = json['CompanyName'];
    createdAgo = json['CreatedAgo'];
    country = json['Country'];
    avatarUrl = json['AvatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Slug'] = this.slug;
    data['StoreName'] = this.storeName;
    data['CompanyName'] = this.companyName;
    data['CreatedAgo'] = this.createdAgo;
    data['Country'] = this.country;
    data['AvatarUrl'] = this.avatarUrl;
    return data;
  }
}
