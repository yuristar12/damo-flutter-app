import 'package:dealful_mall/model/product_entity.dart';

class SupplierEntity {
  List<ProductEntity>? productList;
  dynamic affiliate;
  dynamic location;
  String? role;
  String? user;
  dynamic activeShopRequest;
  dynamic status;
  dynamic updatedAgo;
  dynamic lastSeenAgo;
  dynamic facebookUrl;
  dynamic twitterUrl;
  dynamic instagramUrl;
  dynamic tiktokUrl;
  dynamic whatsappUrl;
  dynamic youtubeUrl;
  dynamic discordUrl;
  dynamic telegramUrl;
  dynamic pinterestUrl;
  dynamic linkedinUrl;
  dynamic twitchUrl;
  dynamic vkUrl;
  dynamic personalWebsiteUrl;
  dynamic membershipPlan;
  String? countryName;
  String? storeName;
  String? categoryName;
  String? id;
  String? branchId;
  String? username;
  String? slug;
  String? email;
  dynamic emailStatus;
  String? password;
  String? salt;
  String? roleId;
  dynamic balance;
  dynamic numberOfSales;
  String? userType;
  dynamic facebookId;
  dynamic googleId;
  dynamic vkontakteId;
  String? avatar;
  dynamic coverImage;
  dynamic coverImageType;
  dynamic banned;
  String? firstName;
  String? lastName;
  dynamic aboutMe;
  dynamic phoneNumber;
  String? countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic address;
  dynamic zipCode;
  dynamic showEmail;
  dynamic showPhone;
  dynamic showLocation;
  dynamic socialMediaData;
  dynamic lastSeen;
  dynamic showRssFeeds;
  dynamic sendEmailNewMessage;
  String? companyName;
  String? companyType;
  String? productCategory;
  dynamic foreignTradeExp;
  dynamic isActiveShopRequest;
  dynamic shopRequestRejectReason;
  dynamic shopRequestDate;
  dynamic vendorDocuments;
  dynamic isMembershipPlanExpired;
  dynamic isUsedFreePlan;
  dynamic cashOnDelivery;
  dynamic isFixedVat;
  dynamic fixedVatRate;
  dynamic vatRatesData;
  dynamic vatRatesDataState;
  dynamic isAffiliate;
  dynamic vendorAffiliateStatus;
  dynamic affiliateCommissionRate;
  dynamic affiliateDiscountRate;
  dynamic taxRegistrationNumber;
  dynamic vacationMode;
  dynamic vacationMessage;
  dynamic commissionDebt;
  dynamic accountDeleteReq;
  dynamic accountDeleteReqDate;
  String? createdAt;
  String? emailCode;
  dynamic emailShortCode;
  String? introduceUserId;
  String? type;
  String? keyAt;
  String? companyRegisterAt;
  String? market;

  SupplierEntity(
      {this.productList,
        this.affiliate,
        this.location,
        this.role,
        this.user,
        this.activeShopRequest,
        this.status,
        this.updatedAgo,
        this.lastSeenAgo,
        this.facebookUrl,
        this.twitterUrl,
        this.instagramUrl,
        this.tiktokUrl,
        this.whatsappUrl,
        this.youtubeUrl,
        this.discordUrl,
        this.telegramUrl,
        this.pinterestUrl,
        this.linkedinUrl,
        this.twitchUrl,
        this.vkUrl,
        this.personalWebsiteUrl,
        this.membershipPlan,
        this.countryName,
        this.categoryName,
        this.id,
        this.branchId,
        this.username,
        this.slug,
        this.email,
        this.emailStatus,
        this.password,
        this.salt,
        this.roleId,
        this.balance,
        this.numberOfSales,
        this.userType,
        this.facebookId,
        this.googleId,
        this.vkontakteId,
        this.avatar,
        this.coverImage,
        this.coverImageType,
        this.banned,
        this.firstName,
        this.lastName,
        this.aboutMe,
        this.phoneNumber,
        this.countryId,
        this.stateId,
        this.cityId,
        this.address,
        this.zipCode,
        this.showEmail,
        this.showPhone,
        this.showLocation,
        this.socialMediaData,
        this.lastSeen,
        this.showRssFeeds,
        this.sendEmailNewMessage,
        this.companyName,
        this.companyType,
        this.productCategory,
        this.foreignTradeExp,
        this.isActiveShopRequest,
        this.shopRequestRejectReason,
        this.shopRequestDate,
        this.vendorDocuments,
        this.isMembershipPlanExpired,
        this.isUsedFreePlan,
        this.cashOnDelivery,
        this.isFixedVat,
        this.fixedVatRate,
        this.vatRatesData,
        this.vatRatesDataState,
        this.isAffiliate,
        this.vendorAffiliateStatus,
        this.affiliateCommissionRate,
        this.affiliateDiscountRate,
        this.taxRegistrationNumber,
        this.vacationMode,
        this.vacationMessage,
        this.commissionDebt,
        this.accountDeleteReq,
        this.accountDeleteReqDate,
        this.createdAt,
        this.emailCode,
        this.emailShortCode,
        this.introduceUserId,
        this.type,
        this.keyAt,
        this.companyRegisterAt,
        this.market});

  SupplierEntity.fromJson(Map<String, dynamic> json) {
    if (json['ProductList'] != null) {
      productList = [];
      json['ProductList'].forEach((v) {
        productList!.add(ProductEntity.fromJson(v));
      });
    }
    affiliate = json['Affiliate'];
    location = json['Location'];
    role = json['Role'];
    user = json['User'];
    activeShopRequest = json['ActiveShopRequest'];
    status = json['Status'];
    storeName = json['StoreName'];
    updatedAgo = json['UpdatedAgo'];
    lastSeenAgo = json['LastSeenAgo'];
    facebookUrl = json['FacebookUrl'];
    twitterUrl = json['TwitterUrl'];
    instagramUrl = json['InstagramUrl'];
    tiktokUrl = json['TiktokUrl'];
    whatsappUrl = json['WhatsappUrl'];
    youtubeUrl = json['YoutubeUrl'];
    discordUrl = json['DiscordUrl'];
    telegramUrl = json['TelegramUrl'];
    pinterestUrl = json['PinterestUrl'];
    linkedinUrl = json['LinkedinUrl'];
    twitchUrl = json['TwitchUrl'];
    vkUrl = json['VkUrl'];
    personalWebsiteUrl = json['PersonalWebsiteUrl'];
    membershipPlan = json['MembershipPlan'];
    countryName = json['CountryName'];
    categoryName = json['CategoryName'];
    id = json['Id'];
    branchId = json['BranchId'];
    username = json['Username'];
    slug = json['Slug'];
    email = json['Email'];
    emailStatus = json['EmailStatus'];
    password = json['Password'];
    salt = json['Salt'];
    roleId = json['RoleId'];
    balance = json['Balance'];
    numberOfSales = json['NumberOfSales'];
    userType = json['UserType'];
    facebookId = json['FacebookId'];
    googleId = json['GoogleId'];
    vkontakteId = json['VkontakteId'];
    avatar = json['Avatar'];
    coverImage = json['CoverImage'];
    coverImageType = json['CoverImageType'];
    banned = json['Banned'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    aboutMe = json['AboutMe'];
    phoneNumber = json['PhoneNumber'];
    countryId = json['CountryId'];
    stateId = json['StateId'];
    cityId = json['CityId'];
    address = json['Address'];
    zipCode = json['ZipCode'];
    showEmail = json['ShowEmail'];
    showPhone = json['ShowPhone'];
    showLocation = json['ShowLocation'];
    socialMediaData = json['SocialMediaData'];
    lastSeen = json['LastSeen'];
    showRssFeeds = json['ShowRssFeeds'];
    sendEmailNewMessage = json['SendEmailNewMessage'];
    companyName = json['CompanyName'];
    companyType = json['CompanyType'];
    productCategory = json['ProductCategory'];
    foreignTradeExp = json['ForeignTradeExp'];
    isActiveShopRequest = json['IsActiveShopRequest'];
    shopRequestRejectReason = json['ShopRequestRejectReason'];
    shopRequestDate = json['ShopRequestDate'];
    vendorDocuments = json['VendorDocuments'];
    isMembershipPlanExpired = json['IsMembershipPlanExpired'];
    isUsedFreePlan = json['IsUsedFreePlan'];
    cashOnDelivery = json['CashOnDelivery'];
    isFixedVat = json['IsFixedVat'];
    fixedVatRate = json['FixedVatRate'];
    vatRatesData = json['VatRatesData'];
    vatRatesDataState = json['VatRatesDataState'];
    isAffiliate = json['IsAffiliate'];
    vendorAffiliateStatus = json['VendorAffiliateStatus'];
    affiliateCommissionRate = json['AffiliateCommissionRate'];
    affiliateDiscountRate = json['AffiliateDiscountRate'];
    taxRegistrationNumber = json['TaxRegistrationNumber'];
    vacationMode = json['VacationMode'];
    vacationMessage = json['VacationMessage'];
    commissionDebt = json['CommissionDebt'];
    accountDeleteReq = json['AccountDeleteReq'];
    accountDeleteReqDate = json['AccountDeleteReqDate'];
    createdAt = json['CreatedAt'];
    emailCode = json['email_code'];
    emailShortCode = json['EmailShortCode'];
    introduceUserId = json['introduce_user_id'];
    type = json['Type'];
    keyAt = json['KeyAt'];
    companyRegisterAt = json['CompanyRegisterAt'];
    market = json['Market'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productList != null) {
      data['ProductList'] = this.productList!.map((v) => v.toJson()).toList();
    }
    data['Affiliate'] = this.affiliate;
    data['Location'] = this.location;
    data['Role'] = this.role;
    data['User'] = this.user;
    data['ActiveShopRequest'] = this.activeShopRequest;
    data['Status'] = this.status;
    data['UpdatedAgo'] = this.updatedAgo;
    data['LastSeenAgo'] = this.lastSeenAgo;
    data['FacebookUrl'] = this.facebookUrl;
    data['TwitterUrl'] = this.twitterUrl;
    data['InstagramUrl'] = this.instagramUrl;
    data['TiktokUrl'] = this.tiktokUrl;
    data['WhatsappUrl'] = this.whatsappUrl;
    data['YoutubeUrl'] = this.youtubeUrl;
    data['DiscordUrl'] = this.discordUrl;
    data['TelegramUrl'] = this.telegramUrl;
    data['PinterestUrl'] = this.pinterestUrl;
    data['LinkedinUrl'] = this.linkedinUrl;
    data['TwitchUrl'] = this.twitchUrl;
    data['VkUrl'] = this.vkUrl;
    data['PersonalWebsiteUrl'] = this.personalWebsiteUrl;
    data['MembershipPlan'] = this.membershipPlan;
    data['CountryName'] = this.countryName;
    data['CategoryName'] = this.categoryName;
    data['Id'] = this.id;
    data['BranchId'] = this.branchId;
    data['Username'] = this.username;
    data['Slug'] = this.slug;
    data['Email'] = this.email;
    data['EmailStatus'] = this.emailStatus;
    data['Password'] = this.password;
    data['Salt'] = this.salt;
    data['RoleId'] = this.roleId;
    data['Balance'] = this.balance;
    data['NumberOfSales'] = this.numberOfSales;
    data['UserType'] = this.userType;
    data['FacebookId'] = this.facebookId;
    data['GoogleId'] = this.googleId;
    data['VkontakteId'] = this.vkontakteId;
    data['Avatar'] = this.avatar;
    data['CoverImage'] = this.coverImage;
    data['CoverImageType'] = this.coverImageType;
    data['Banned'] = this.banned;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['AboutMe'] = this.aboutMe;
    data['PhoneNumber'] = this.phoneNumber;
    data['CountryId'] = this.countryId;
    data['StateId'] = this.stateId;
    data['CityId'] = this.cityId;
    data['Address'] = this.address;
    data['ZipCode'] = this.zipCode;
    data['ShowEmail'] = this.showEmail;
    data['ShowPhone'] = this.showPhone;
    data['ShowLocation'] = this.showLocation;
    data['SocialMediaData'] = this.socialMediaData;
    data['LastSeen'] = this.lastSeen;
    data['ShowRssFeeds'] = this.showRssFeeds;
    data['SendEmailNewMessage'] = this.sendEmailNewMessage;
    data['CompanyName'] = this.companyName;
    data['CompanyType'] = this.companyType;
    data['ProductCategory'] = this.productCategory;
    data['ForeignTradeExp'] = this.foreignTradeExp;
    data['IsActiveShopRequest'] = this.isActiveShopRequest;
    data['ShopRequestRejectReason'] = this.shopRequestRejectReason;
    data['ShopRequestDate'] = this.shopRequestDate;
    data['VendorDocuments'] = this.vendorDocuments;
    data['IsMembershipPlanExpired'] = this.isMembershipPlanExpired;
    data['IsUsedFreePlan'] = this.isUsedFreePlan;
    data['CashOnDelivery'] = this.cashOnDelivery;
    data['IsFixedVat'] = this.isFixedVat;
    data['FixedVatRate'] = this.fixedVatRate;
    data['VatRatesData'] = this.vatRatesData;
    data['VatRatesDataState'] = this.vatRatesDataState;
    data['IsAffiliate'] = this.isAffiliate;
    data['VendorAffiliateStatus'] = this.vendorAffiliateStatus;
    data['AffiliateCommissionRate'] = this.affiliateCommissionRate;
    data['AffiliateDiscountRate'] = this.affiliateDiscountRate;
    data['TaxRegistrationNumber'] = this.taxRegistrationNumber;
    data['VacationMode'] = this.vacationMode;
    data['VacationMessage'] = this.vacationMessage;
    data['CommissionDebt'] = this.commissionDebt;
    data['AccountDeleteReq'] = this.accountDeleteReq;
    data['AccountDeleteReqDate'] = this.accountDeleteReqDate;
    data['CreatedAt'] = this.createdAt;
    data['email_code'] = this.emailCode;
    data['EmailShortCode'] = this.emailShortCode;
    data['introduce_user_id'] = this.introduceUserId;
    data['Type'] = this.type;
    data['KeyAt'] = this.keyAt;
    data['CompanyRegisterAt'] = this.companyRegisterAt;
    data['Market'] = this.market;
    return data;
  }
}
