class BrandEntity {
  String? id;
  String? name;
  String? image;
  List<BrandEntity>? children;

  BrandEntity({this.id, this.name, this.image});

  BrandEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    image = json['Image'];
    children = (json['Brands'] as List<dynamic>?)
        ?.map((e) => BrandEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Image'] = this.image;
    data['Brands'] = this.children;
    return data;
  }
}
