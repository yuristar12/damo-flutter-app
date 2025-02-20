class BlogEntity {
  String? slug;
  String? summary;
  dynamic id;
  String? title;
  String? category;
  String? image;
  String? createdAt;

  BlogEntity(
      {this.slug,
        this.summary,
        this.id,
        this.title,
        this.category,
        this.image,
        this.createdAt});

  BlogEntity.fromJson(Map<String, dynamic> json) {
    slug = json['Slug'];
    summary = json['Summary'];
    id = json['Id'];
    title = json['Title'];
    category = json['Category'];
    image = json['Image'];
    createdAt = json['CreatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Slug'] = this.slug;
    data['Summary'] = this.summary;
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Category'] = this.category;
    data['Image'] = this.image;
    data['CreatedAt'] = this.createdAt;
    return data;
  }
}
