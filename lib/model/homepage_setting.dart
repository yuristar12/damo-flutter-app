class HomepageSetting {
  bool? sliderStatus;
  String? sliderType;
  String? sliderEffect;
  bool? featuredCategories;
  bool? indexPromotedProducts;
  bool? indexLatestProducts;
  bool? indexBlogSlider;
  String? logo;
  String? language;
  String? singleCountryId;
  bool? singleCountryMode;

  HomepageSetting(
      {this.sliderStatus,
        this.sliderType,
        this.sliderEffect,
        this.featuredCategories,
        this.indexPromotedProducts,
        this.indexLatestProducts,
        this.indexBlogSlider,
        this.logo,
        this.language});

  HomepageSetting.fromJson(Map<String, dynamic> json) {
    sliderStatus = json['SliderStatus'];
    sliderType = json['SliderType'];
    sliderEffect = json['SliderEffect'];
    featuredCategories = json['FeaturedCategories'];
    indexPromotedProducts = json['IndexPromotedProducts'];
    indexLatestProducts = json['IndexLatestProducts'];
    indexBlogSlider = json['IndexBlogSlider'];
    logo = json['Logo'];
    language = json['Language'];
    singleCountryId = json['SingleCountryId'];
    singleCountryMode = json['SingleCountryMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SliderStatus'] = this.sliderStatus;
    data['SliderType'] = this.sliderType;
    data['SliderEffect'] = this.sliderEffect;
    data['FeaturedCategories'] = this.featuredCategories;
    data['IndexPromotedProducts'] = this.indexPromotedProducts;
    data['IndexLatestProducts'] = this.indexLatestProducts;
    data['IndexBlogSlider'] = this.indexBlogSlider;
    data['Logo'] = this.logo;
    data['Language'] = this.language;
    return data;
  }
}
