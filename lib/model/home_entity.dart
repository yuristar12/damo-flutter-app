import 'package:dealful_mall/model/category_entity.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/simple_banner_entity.dart';

class HomeEntity {
  List<ProductEntity>? specialOfferProducts;
  List<ProductEntity>? featuredStoreProducts;
  List<ProductEntity>? newArrivalProducts;
  List<CategoryEntity>? channel;
  // List<HomeModelBanner>? banner;
  List<HomeModelMenu>? menu;
  List<HomeModelRecommend>? recommendMenu;
  Map<String, dynamic>? appSetting;
  int index;
  List<SimpleBannerEntity>? banner;

  HomeEntity({
    this.specialOfferProducts,
    this.featuredStoreProducts,
    this.newArrivalProducts,
    this.channel,
    this.banner,
    this.menu,
    this.recommendMenu,
    this.appSetting,
    this.index = 0
  });
}

class HomeModelCouponlist {
  double? min;
  String? name;
  double? discount;
  int? days;
  int? id;
  String? tag;
  String? desc;

  HomeModelCouponlist(
      {this.min,
      this.name,
      this.discount,
      this.days,
      this.id,
      this.tag,
      this.desc});

  HomeModelCouponlist.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    name = json['name'];
    discount = json['discount'];
    days = json['days'];
    id = json['id'];
    tag = json['tag'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min'] = this.min;
    data['name'] = this.name;
    data['discount'] = this.discount;
    data['days'] = this.days;
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['desc'] = this.desc;
    return data;
  }
}

class HomeModelGrouponlist {
  String? brief;
  String? picUrl;
  double? grouponPrice;
  int? grouponDiscount;
  String? name;
  double? counterPrice;
  int? id;
  double? retailPrice;
  int? grouponMember;

  HomeModelGrouponlist(
      {this.brief,
      this.picUrl,
      this.grouponPrice,
      this.grouponDiscount,
      this.name,
      this.counterPrice,
      this.id,
      this.retailPrice,
      this.grouponMember});

  HomeModelGrouponlist.fromJson(Map<String, dynamic> json) {
    brief = json['brief'];
    picUrl = json['picUrl'];
    grouponPrice = json['grouponPrice'];
    grouponDiscount = json['grouponDiscount'];
    name = json['name'];
    counterPrice = json['counterPrice'];
    id = json['id'];
    retailPrice = json['retailPrice'];
    grouponMember = json['grouponMember'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brief'] = this.brief;
    data['picUrl'] = this.picUrl;
    data['grouponPrice'] = this.grouponPrice;
    data['grouponDiscount'] = this.grouponDiscount;
    data['name'] = this.name;
    data['counterPrice'] = this.counterPrice;
    data['id'] = this.id;
    data['retailPrice'] = this.retailPrice;
    data['grouponMember'] = this.grouponMember;
    return data;
  }
}

class HomeModelRecommend {
  String? Id;
  String? Name;
  String? Icon;
  String? Link;
  String? ImageUrl;
  List? categoriesVOList;

  HomeModelRecommend(
      { this.Id,
        this.Name,
        this.Icon,
        this.Link,
        this.ImageUrl,
        this.categoriesVOList
      });

  HomeModelRecommend.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    Name = json['Name'];
    Icon = json['Icon'];
    Link = json['Link'];
    ImageUrl = json['ImageUrl'] ?? json["Image"];
    categoriesVOList = json['categoriesVOList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.Id;
    data['Name'] = this.Name;
    data['Icon'] = this.Icon;
    data['Link'] = this.Link;
    data['ImageUrl'] = this.ImageUrl;
    data['categoriesVOList'] = this.categoriesVOList;
    return data;
  }
}

class BackgroundBgModel {
  String? BackgroundImage;
  String? IconHome;
  String? IconDiscover;
  String? IconMessage;
  String? IconCart;
  String? IconAccount;
  List? categoriesVOList;

  BackgroundBgModel(
      { this.BackgroundImage,
        this.IconHome,
        this.IconDiscover,
        this.IconMessage,
        this.IconCart,
        this.IconAccount,
        this.categoriesVOList
      });

  BackgroundBgModel.fromJson(Map<String, dynamic> json) {
    BackgroundImage = json['BackgroundImage'];
    IconHome = json['IconHome'];
    IconDiscover = json['IconDiscover'];
    IconMessage = json['IconMessage'];
    IconCart = json['IconCart'];
    IconAccount = json['IconAccount'];
    categoriesVOList = json['categoriesVOList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BackgroundImage'] = this.BackgroundImage;
    data['IconHome'] = this.IconHome;
    data['IconDiscover'] = this.IconDiscover;
    data['IconMessage'] = this.IconMessage;
    data['IconCart'] = this.IconCart;
    data['IconAccount'] = this.IconAccount;
    data['categoriesVOList'] = this.categoriesVOList;
    return data;
  }
}

class HomeModelMenu {
  String? Id;
  String? Title;
  String? Icon;
  String? Link;
  String? ImageUrl;

  HomeModelMenu(
      { this.Id,
        this.Title,
        this.Icon,
        this.Link,
        this.ImageUrl
      });

  HomeModelMenu.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    Title = json['Title'];
    Icon = json['Icon'];
    Link = json['Link'];
    ImageUrl = json['ImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.Id;
    data['Title'] = this.Title;
    data['Icon'] = this.Icon;
    data['Link'] = this.Link;
    data['ImageUrl'] = this.ImageUrl;
    return data;
  }
}

class HomeModelBanner {
  String? title;
  String? description;
  String? link;
  String? buttonText;
  String? animationTitle;
  String? animationDescription;
  String? animationButton;
  String? image;
  String? textColor;
  String? buttonColor;
  String? buttonTextColor;

  HomeModelBanner(
      {this.title,
        this.description,
        this.link,
        this.buttonText,
        this.animationTitle,
        this.animationDescription,
        this.animationButton,
        this.image,
        this.textColor,
        this.buttonColor,
        this.buttonTextColor});

  HomeModelBanner.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    description = json['Description'];
    link = json['Link'];
    buttonText = json['ButtonText'];
    animationTitle = json['AnimationTitle'];
    animationDescription = json['AnimationDescription'];
    animationButton = json['AnimationButton'];
    image = json['Image'];
    textColor = json['TextColor'];
    buttonColor = json['ButtonColor'];
    buttonTextColor = json['ButtonTextColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Link'] = this.link;
    data['ButtonText'] = this.buttonText;
    data['AnimationTitle'] = this.animationTitle;
    data['AnimationDescription'] = this.animationDescription;
    data['AnimationButton'] = this.animationButton;
    data['Image'] = this.image;
    data['TextColor'] = this.textColor;
    data['ButtonColor'] = this.buttonColor;
    data['ButtonTextColor'] = this.buttonTextColor;
    return data;
  }
}

class HomeModelTopiclist {
  String? picUrl;
  double? price;
  String? subtitle;
  int? id;
  String? title;
  String? readCount;

  HomeModelTopiclist(
      {this.picUrl,
      this.price,
      this.subtitle,
      this.id,
      this.title,
      this.readCount});

  HomeModelTopiclist.fromJson(Map<String, dynamic> json) {
    picUrl = json['picUrl'];
    price = json['price'];
    subtitle = json['subtitle'];
    id = json['id'];
    title = json['title'];
    readCount = json['readCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picUrl'] = this.picUrl;
    data['price'] = this.price;
    data['subtitle'] = this.subtitle;
    data['id'] = this.id;
    data['title'] = this.title;
    data['readCount'] = this.readCount;
    return data;
  }
}

class HomeModelFloorgoodslist {
  String? name;
  List<ProductEntity>? goodsList;
  int? id;

  HomeModelFloorgoodslist({this.name, this.goodsList, this.id});

  HomeModelFloorgoodslist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['goodsList'] != null) {
      goodsList = [];
      (json['goodsList'] as List).forEach((v) {
        goodsList!.add(new ProductEntity.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['goodsList'] = this.goodsList!.map((v) => v.toJson()).toList();
    data['id'] = this.id;
    return data;
  }
}
