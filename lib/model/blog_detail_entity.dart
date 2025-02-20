class BlogDetailEntity {
  String? id;
  String? title;
  String? content;
  String? createdAt;
  List<BlogTags>? blogTags;
  String? category;
  String? image;

  BlogDetailEntity(
      {this.id,
        this.title,
        this.content,
        this.createdAt,
        this.blogTags,
        this.category,
        this.image});

  BlogDetailEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    content = json['Content'];
    createdAt = json['CreatedAt'];
    if (json['BlogTags'] != null) {
      blogTags = [];
      json['BlogTags'].forEach((v) {
        blogTags!.add(new BlogTags.fromJson(v));
      });
    }
    category = json['Category'];
    image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Content'] = this.content;
    data['CreatedAt'] = this.createdAt;
    if (this.blogTags != null) {
      data['BlogTags'] = this.blogTags!.map((v) => v.toJson()).toList();
    }
    data['Category'] = this.category;
    data['Image'] = this.image;
    return data;
  }
}

class BlogTags {
  String? id;
  String? tag;
  String? tagSlug;

  BlogTags({this.id, this.tag, this.tagSlug});

  BlogTags.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    tag = json['Tag'];
    tagSlug = json['TagSlug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Tag'] = this.tag;
    data['TagSlug'] = this.tagSlug;
    return data;
  }
}
