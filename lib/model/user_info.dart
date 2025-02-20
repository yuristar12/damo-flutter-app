class UserInfo {
  String? id;
  String? username;
  String? email;
  String? avatar;
  String? coverImage;
  String? aboutMe;
  String? phoneNumber;
  String? lastSeen;
  String? createdAt;
  String? location;
  String? points;
  String? coupon;
  String? balance;
  bool? carVehicleSelection;
  bool? supplierSearch;
  Map<String, dynamic>? userMember;

  UserInfo(
      {this.id,
        this.username,
        this.email,
        this.avatar,
        this.coverImage,
        this.aboutMe,
        this.phoneNumber,
        this.lastSeen,
        this.createdAt,
        this.location,
        this.balance,
        this.points,
        this.coupon,
        this.carVehicleSelection,
        this.supplierSearch,
        this.userMember
        });

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    username = json['Username'];
    email = json['Email'];
    avatar = json['Avatar'];
    coverImage = json['CoverImage'];
    aboutMe = json['AboutMe'];
    phoneNumber = json['PhoneNumber'];
    lastSeen = json['LastSeen'];
    createdAt = json['CreatedAt'];
    location = json['Location'];
    points = json['ShowPoints'];
    coupon = json['ShowCouponCount'];
    balance = json['ShowBalance'];
    carVehicleSelection = json['UserPermission']['CarVehicleSelection'];
    supplierSearch = json['UserPermission']['SupplierSearch'];
    userMember = json['UserMember'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Username'] = this.username;
    data['Email'] = this.email;
    data['Avatar'] = this.avatar;
    data['CoverImage'] = this.coverImage;
    data['AboutMe'] = this.aboutMe;
    data['PhoneNumber'] = this.phoneNumber;
    data['LastSeen'] = this.lastSeen;
    data['CreatedAt'] = this.createdAt;
    data['Location'] = this.location;
    data['UserMember'] = this.userMember;
    return data;
  }

  String? get realName {
    return username;
  }

  String? get parentId {
    return null;
  }
}
