
class SimpleBannerEntity {
  String? title;
  String? description;
  String? link;
  String? buttonText;
  String? animationTitle;
  String? animationDescription;
  String? animationButton;
  String? image;
  String? textColor;
  String? buttonColor;
  String? buttonTextColor;

  SimpleBannerEntity(
      {this.title,
        this.description,
        this.link,
        this.buttonText,
        this.animationTitle,
        this.animationDescription,
        this.animationButton,
        this.image,
        this.textColor,
        this.buttonColor,
        this.buttonTextColor});

  SimpleBannerEntity.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    description = json['Description'];
    link = json['Link'];
    buttonText = json['ButtonText'];
    animationTitle = json['AnimationTitle'];
    animationDescription = json['AnimationDescription'];
    animationButton = json['AnimationButton'];
    image = json['Image'];
    textColor = json['TextColor'];
    buttonColor = json['ButtonColor'];
    buttonTextColor = json['ButtonTextColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Link'] = this.link;
    data['ButtonText'] = this.buttonText;
    data['AnimationTitle'] = this.animationTitle;
    data['AnimationDescription'] = this.animationDescription;
    data['AnimationButton'] = this.animationButton;
    data['Image'] = this.image;
    data['TextColor'] = this.textColor;
    data['ButtonColor'] = this.buttonColor;
    data['ButtonTextColor'] = this.buttonTextColor;
    return data;
  }
}