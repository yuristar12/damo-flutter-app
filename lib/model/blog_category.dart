class BlogCategory {
  String? id;
  String? name;
  String? slug;

  BlogCategory({this.id, this.name, this.slug});

  BlogCategory.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    slug = json['Slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Slug'] = this.slug;
    return data;
  }
}
