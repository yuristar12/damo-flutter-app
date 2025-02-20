import 'package:dealful_mall/model/company_entity.dart';
import 'package:dealful_mall/model/label_entity.dart';
import 'package:dealful_mall/model/online_user.dart';
import 'package:get/get.dart';

class ProductDetailEntity {
  String? id;
  String? productType;
  String? price;
  String? priceDiscounted;
  String? currency;
  String? discountRate;
  int? isPromoted;
  String? rating;
  int? pageviews;
  dynamic stock;
  String? updatedAt;
  String? createdAt;
  dynamic source;
  dynamic sourceId;
  String? name;
  String? stockStatus;
  DescriptionTab? descriptionTab;
  List<LabelEntity>? productInfos;
  List<Variations>? variations;
  List<ImageBean>? imageList;
  List<MediaBean>? mediaList;
  int? reviewsNum;
  ReviewsTab? reviewsTab;
  double? unitPriceYuan;
  int? commentsNum;
  CommentsTab? commentsTab;
  CompanyEntity? company;
  ShippingLocationTab? shippingLocationTab;
  String? username;
  String? listingType;
  bool? isWishlist;
  ProductDetailEntity(
      {this.id,
        this.productType,
        this.price,
        this.priceDiscounted,
        this.currency,
        this.discountRate,
        this.isPromoted,
        this.rating,
        this.pageviews,
        this.stock,
        this.updatedAt,
        this.createdAt,
        this.source,
        this.sourceId,
        this.name,
        this.stockStatus,
        this.descriptionTab,
        this.productInfos,
        this.variations,
        this.imageList,
        this.mediaList,
        this.reviewsNum,
        this.reviewsTab,
        this.commentsNum,
        this.commentsTab,
        this.shippingLocationTab,
        this.username});

  String? get userId => company?.id;

  ProductDetailEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productType = json['ProductType'];
    price = json['Price'];
    priceDiscounted = json['PriceDiscounted'];
    currency = json['Currency'];
    discountRate = json['DiscountRate'];
    isPromoted = json['IsPromoted'];
    rating = json['Rating'];
    pageviews = json['Pageviews'];
    stock = json['Stock'];
    updatedAt = json['UpdatedAt'];
    createdAt = json['CreatedAt'];
    source = json['Source'];
    sourceId = json['SourceId'];
    name = json['Name'];
    isWishlist = json['IsWishlist'];
    stockStatus = json['StockStatus'];
    listingType = json['ListingType'];
    descriptionTab = json['DescriptionTab'] != null
        ? new DescriptionTab.fromJson(json['DescriptionTab'])
        : null;
    if (json['ProductInfos'] != null) {
      productInfos = [];
      json['ProductInfos'].forEach((v) {
        if(v != null) {
          productInfos!.add(LabelEntity.fromJson(v));
        }
      });
    }
    if (json['Variations'] != null) {
      variations = [];
      json['Variations'].forEach((v) {
        if(v != null) {
          variations!.add(new Variations.fromJson(v));
        }
      });
    }
    if (json['ImageList'] != null) {
      imageList = [];
      json['ImageList'].forEach((v) {
        if(v != null) {
          imageList!.add(new ImageBean.fromJson(v));
        }
      });
    }
    if (json['MediaList'] != null) {
      mediaList = [];
      json['MediaList'].forEach((v) {
        if(v != null) {
          mediaList!.add(new MediaBean.fromJson(v));
        }
      });
    }
    reviewsNum = json['ReviewsNum'];
    reviewsTab = json['ReviewsTab'] != null
        ? ReviewsTab.fromJson(json['ReviewsTab'])
        : null;
    commentsNum = json['CommentsNum'];
    commentsTab = json['CommentsTab'] != null
        ? CommentsTab.fromJson(json['CommentsTab'])
        : null;
    shippingLocationTab = json['ShippingLocationTab'] != null
        ? ShippingLocationTab.fromJson(json['ShippingLocationTab'])
        : null;
    company = json['Company'] != null
        ? CompanyEntity.fromJson(json['Company'])
        : null;
    unitPriceYuan = json['UnitPriceYuan'];
    username = json['Username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ProductType'] = this.productType;
    data['Price'] = this.price;
    data['PriceDiscounted'] = this.priceDiscounted;
    data['Currency'] = this.currency;
    data['DiscountRate'] = this.discountRate;
    data['IsPromoted'] = this.isPromoted;
    data['Rating'] = this.rating;
    data['Pageviews'] = this.pageviews;
    data['Stock'] = this.stock;
    data['UpdatedAt'] = this.updatedAt;
    data['CreatedAt'] = this.createdAt;
    data['Source'] = this.source;
    data['SourceId'] = this.sourceId;
    data['Name'] = this.name;
    data['StockStatus'] = this.stockStatus;
    data['IsWishlist'] = this.isWishlist;
    if (this.descriptionTab != null) {
      data['DescriptionTab'] = this.descriptionTab!.toJson();
    }
    if (this.productInfos != null) {
      data['ProductInfos'] = this.productInfos!.map((v) => v.toJson()).toList();
    }
    if (this.variations != null) {
      data['Variations'] = this.variations!.map((v) => v.toJson()).toList();
    }
    if (this.imageList != null) {
      data['ImageList'] = this.imageList!.map((v) => v.toJson()).toList();
    }
    if (this.mediaList != null) {
      data['MediaList'] = this.mediaList!.map((v) => v.toJson()).toList();
    }
    data['ReviewsNum'] = this.reviewsNum;
    if (this.reviewsTab != null) {
      data['ReviewsTab'] = this.reviewsTab!.toJson();
    }
    data['CommentsNum'] = this.commentsNum;
    if (this.commentsTab != null) {
      data['CommentsTab'] = this.commentsTab!.toJson();
    }
    if (this.shippingLocationTab != null) {
      data['ShippingLocationTab'] = this.shippingLocationTab!.toJson();
    }
    data['Username'] = this.username;
    return data;
  }
}

class DescriptionTab {
  String? descriptionTabName;
  String? description;

  DescriptionTab({this.descriptionTabName, this.description});

  DescriptionTab.fromJson(Map<String, dynamic> json) {
    descriptionTabName = json['DescriptionTabName'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DescriptionTabName'] = this.descriptionTabName;
    data['Description'] = this.description;
    return data;
  }
}

class Variations {
  String? id;
  String? variationType;
  String? optionDisplayType;
  bool? showImagesOnSlider;
  List<VariationOptions>? variationOptions;
  String? labelName;
  Variations(
      {this.id,
        this.variationType,
        this.optionDisplayType,
        this.showImagesOnSlider,
        this.variationOptions,
        this.labelName});

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    variationType = json['VariationType'];
    optionDisplayType = json['OptionDisplayType'];
    showImagesOnSlider = json['ShowImagesOnSlider'];
    if (json['VariationOptions'] != null) {
      variationOptions = [];
      json['VariationOptions'].forEach((v) {
        if(v != null) {
          variationOptions!.add(VariationOptions.fromJson(v));
        }
      });
    }
    labelName = json['LabelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['VariationType'] = this.variationType;
    data['OptionDisplayType'] = this.optionDisplayType;
    data['ShowImagesOnSlider'] = this.showImagesOnSlider;
    if (this.variationOptions != null) {
      data['VariationOptions'] =
          this.variationOptions!.map((v) => v.toJson()).toList();
    }
    data['LabelName'] = this.labelName;
    return data;
  }

  void clearSelect() {
    if(variationOptions != null) {
      for(VariationOptions option in variationOptions!) {
        option.selectedX.value = false;
      }
    }
  }
}

class VariationOptions {
  String? id;
  List<ImageBean>? imageList;
  String? colorOrImage;
  String? optionName;
  RxBool selectedX = RxBool(false);
  VariationOptions({this.id, this.imageList, this.optionName, this.colorOrImage});

  VariationOptions.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    if (json['ImageList'] != null) {
      imageList = [];
      json['ImageList'].forEach((v) {
        if(v != null) {
          imageList!.add(ImageBean.fromJson(v));
        }
      });
    }
    optionName = json['OptionName'];
    colorOrImage = json['ColorOrImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    if (this.imageList != null) {
      data['ImageList'] = this.imageList!.map((v) => v.toJson()).toList();
    }
    data['OptionName'] = this.optionName;
    return data;
  }
}

class ImageBean {
  String? id;
  String? imageBig;
  String? imageSmall;
  String? fileType;
  bool? isMain;

  ImageBean({this.id, this.imageBig, this.imageSmall, this.isMain});

  ImageBean.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    imageBig = json['ImageBig'];
    imageSmall = json['ImageSmall'];
    fileType = json['FileType'];
    isMain = json['IsMain'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ImageBig'] = this.imageBig;
    data['ImageSmall'] = this.imageSmall;
    data['IsMain'] = this.isMain;
    return data;
  }
}

class MediaBean {
  String? mediaType;
  String? fileName;

  MediaBean({this.mediaType, this.fileName});

  MediaBean.fromJson(Map<String, dynamic> json) {
    mediaType = json['MediaType'];
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MediaType'] = this.mediaType;
    data['FileName'] = this.fileName;
    return data;
  }
}

class ReviewsTab {
  String? reviewsTabName;
  List<Reviews>? reviews;

  ReviewsTab({this.reviewsTabName, this.reviews});

  ReviewsTab.fromJson(Map<String, dynamic> json) {
    reviewsTabName = json['ReviewsTabName'];
    if (json['Reviews'] != null) {
      reviews = [];
      json['Reviews'].forEach((v) {
        if(v != null) {
          reviews!.add(Reviews.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ReviewsTabName'] = this.reviewsTabName;
    if (this.reviews != null) {
      data['Reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  String? id;
  int? rating;
  String? review;
  OnlineUser? userInfo;
  String? timeAgo;

  Reviews({this.id, this.rating, this.review, this.userInfo, this.timeAgo});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    rating = json['Rating'];
    review = json['Review'];
    userInfo = json['UserInfo'] != null
        ? new OnlineUser.fromJson(json['UserInfo'])
        : null;
    timeAgo = json['TimeAgo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Rating'] = this.rating;
    data['Review'] = this.review;
    if (this.userInfo != null) {
      data['UserInfo'] = this.userInfo!.toJson();
    }
    data['TimeAgo'] = this.timeAgo;
    return data;
  }
}

class CommentsTab {
  String? commentsTabName;
  List<Comments>? comments;

  CommentsTab({this.commentsTabName, this.comments});

  CommentsTab.fromJson(Map<String, dynamic> json) {
    commentsTabName = json['CommentsTabName'];
    if (json['Comments'] != null) {
      comments = [];
      json['Comments'].forEach((v) {
        if(v != null) {
          comments!.add(Comments.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CommentsTabName'] = this.commentsTabName;
    if (this.comments != null) {
      data['Comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? id;
  String? comment;
  OnlineUser? userInfo;
  String? timeAgo;
  List<ReplyComments>? replyComments;

  Comments(
      {this.id, this.comment, this.userInfo, this.timeAgo, this.replyComments});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    comment = json['Comment'];
    userInfo = json['UserInfo'] != null
        ? OnlineUser.fromJson(json['UserInfo'])
        : null;
    timeAgo = json['TimeAgo'];
    if (json['ReplyComments'] != null) {
      replyComments = [];
      json['ReplyComments'].forEach((v) {
        if(v != null) {
          replyComments!.add(ReplyComments.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Comment'] = this.comment;
    if (this.userInfo != null) {
      data['UserInfo'] = this.userInfo!.toJson();
    }
    data['TimeAgo'] = this.timeAgo;
    if (this.replyComments != null) {
      data['ReplyComments'] =
          this.replyComments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReplyComments {
  String? id;
  String? comment;
  OnlineUser? userInfo;
  String? timeAgo;
  dynamic replyComments;

  ReplyComments(
      {this.id, this.comment, this.userInfo, this.timeAgo, this.replyComments});

  ReplyComments.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    comment = json['Comment'];
    userInfo = json['UserInfo'] != null
        ? OnlineUser.fromJson(json['UserInfo'])
        : null;
    timeAgo = json['TimeAgo'];
    replyComments = json['ReplyComments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Comment'] = this.comment;
    if (this.userInfo != null) {
      data['UserInfo'] = this.userInfo!.toJson();
    }
    data['TimeAgo'] = this.timeAgo;
    data['ReplyComments'] = this.replyComments;
    return data;
  }
}

class ShippingLocationTab {
  String? shippingTabName;
  List<LabelEntity>? shipping;

  ShippingLocationTab({this.shippingTabName, this.shipping});

  ShippingLocationTab.fromJson(Map<String, dynamic> json) {
    shippingTabName = json['ShippingTabName'];
    if (json['Shipping'] != null) {
      shipping = [];
      json['Shipping'].forEach((v) {
        if(v != null) {
          shipping!.add(LabelEntity.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShippingTabName'] = this.shippingTabName;
    if (this.shipping != null) {
      data['Shipping'] = this.shipping!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
