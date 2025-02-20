class LocationEntity {
  dynamic id;
  String? name;
  String? continentCode;

  LocationEntity({this.id, this.name, this.continentCode});

  LocationEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    continentCode = json['ContinentCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['ContinentCode'] = this.continentCode;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
