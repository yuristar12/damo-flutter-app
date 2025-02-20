

class AddressEntity {
  String? id;
  String? title;
  String? email;
  String? phoneNumber;
  String? address;
  String? city;
  String? zipCode;
  String? addressType;
  bool? isMain;
  String? _name;
  String? country;
  String? state;
  String? showAddressType;
  String? userId;
  String? branchId;
  String? firstName;
  String? lastName;
  String? countryId;
  String? stateId;

  String? get name {
    if(_name == null) {
      return "${firstName} ${lastName}";
    }
    return _name;
  }

  set name(String? value) {
    _name = value;
  }

  AddressEntity(
      {this.id,
        this.title,
        this.email,
        this.phoneNumber,
        this.address,
        this.city,
        this.zipCode,
        this.addressType,
        this.isMain,
        this.country,
        this.state,
        this.showAddressType});

  AddressEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    email = json['Email'];
    phoneNumber = json['PhoneNumber'];
    address = json['Address'];
    city = json['City'];
    zipCode = json['ZipCode'];
    addressType = json['AddressType'];
    isMain = json['IsMain'];
    name = json['Name'];
    country = json['Country'];
    state = json['State'];
    showAddressType = json['ShowAddressType'];
    userId = json['UserId'];
    branchId = json['BranchId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    countryId = json['CountryId'];
    stateId = json['StateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Email'] = this.email;
    data['PhoneNumber'] = this.phoneNumber;
    data['Address'] = this.address;
    data['City'] = this.city;
    data['ZipCode'] = this.zipCode;
    data['AddressType'] = this.addressType;
    data['IsMain'] = this.isMain;
    data['Name'] = this.name;
    data['Country'] = this.country;
    data['State'] = this.state;
    data['ShowAddressType'] = this.showAddressType;
    data['UserId'] = this.userId;
    data['BranchId'] = this.branchId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['CountryId'] = this.countryId;
    data['StateId'] = this.stateId;
    return data;
  }
}
