class LanguageEntity {
  dynamic id;
  String? name;
  String? shortForm;
  String? languageCode;
  String? textDirection;
  String? flagPath;

  LanguageEntity(
      {this.id,
        this.name,
        this.shortForm,
        this.languageCode,
        this.textDirection,
        this.flagPath});

  LanguageEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    shortForm = json['ShortForm'];
    languageCode = json['LanguageCode'];
    textDirection = json['TextDirection'];
    flagPath = json['FlagPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['ShortForm'] = this.shortForm;
    data['LanguageCode'] = this.languageCode;
    data['TextDirection'] = this.textDirection;
    data['FlagPath'] = this.flagPath;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if(other is LanguageEntity) {
      return this.languageCode == other.languageCode;
    }
    return false;
  }
}
