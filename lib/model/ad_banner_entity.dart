class AdBannerEntity {
  String? bannerUrl;
  String? bannerImagePath;
  double? bannerWidth;
  String? bannerLocation;

  AdBannerEntity(
      {this.bannerUrl,
        this.bannerImagePath,
        this.bannerWidth,
        this.bannerLocation});

  AdBannerEntity.fromJson(Map<String, dynamic> json) {
    bannerUrl = json['BannerUrl'];
    bannerImagePath = json['BannerImagePath'];
    bannerWidth = json['BannerWidth'];
    bannerLocation = json['BannerLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BannerUrl'] = this.bannerUrl;
    data['BannerImagePath'] = this.bannerImagePath;
    data['BannerWidth'] = this.bannerWidth;
    data['BannerLocation'] = this.bannerLocation;
    return data;
  }
}
