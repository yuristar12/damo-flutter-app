import 'package:dealful_mall/model/homepage_setting.dart';
import 'package:dealful_mall/model/language_entity.dart';

class HomepageData {
  HomepageSetting? generalSetting;
  Currency? currency;
  Language? language ;

  HomepageData({this.generalSetting, this.currency});

  HomepageData.fromJson(Map<String, dynamic> json) {
    generalSetting = json['GeneralSetting'] != null
        ? new HomepageSetting.fromJson(json['GeneralSetting'])
        : null;
    currency = json['Currency'] != null
        ? new Currency.fromJson(json['Currency'])
        : null;
    language = json['Language'] != null
        ? new Language.fromJson(json['Language'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeneralSetting'] = this.generalSetting?.toJson();
    data['Currency'] = this.currency?.toJson();
    return data;
  }
}

class Currency {
  String? defaultCurrency;
  String? showDefaultCurrency;
  List<CurrencyEntity>? currencies;

  Currency({this.defaultCurrency, this.showDefaultCurrency, this.currencies});

  Currency.fromJson(Map<String, dynamic> json) {
    defaultCurrency = json['DefaultCurrency'];
    showDefaultCurrency = json['ShowDefaultCurrency'];
    if (json['currencies'] != null) {
      currencies = [];
      json['currencies'].forEach((v) {
        currencies!.add(new CurrencyEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DefaultCurrency'] = this.defaultCurrency;
    data['ShowDefaultCurrency'] = this.showDefaultCurrency;
    if (this.currencies != null) {
      data['currencies'] = this.currencies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyEntity {
  dynamic id;
  String? code;
  String? name;
  String? showCode;
  String? showName;

  CurrencyEntity({this.id, this.code, this.name, this.showCode, this.showName});

  CurrencyEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    code = json['Code'];
    name = json['Name'];
    showCode = json['ShowCode'];
    showName = json['ShowName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Code'] = this.code;
    data['Name'] = this.name;
    data['ShowCode'] = this.showCode;
    data['ShowName'] = this.showName;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => id.hashCode ^ code.hashCode;

  String get symbol {
    if(showCode != null) {
      String copyCode = showCode!;
      int startIndex = copyCode.indexOf('(');
      int endIndex = copyCode.indexOf(')');
      if(startIndex != -1 && endIndex > startIndex) {
        return copyCode.substring(startIndex + 1, endIndex);
      }
    }
    return showCode ?? "";
  }
}

class Language {
  LanguageEntity? defaultLanguages;
  List<LanguageEntity>? languages;

  Language({this.defaultLanguages, this.languages});

  Language.fromJson(Map<String, dynamic> json) {
    defaultLanguages = json['DefaultLanguages'] != null
        ? new LanguageEntity.fromJson(json['DefaultLanguages'])
        : null;
    if (json['Languages'] != null) {
      languages = [];
      json['Languages'].forEach((v) {
        languages?.add(new LanguageEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.defaultLanguages != null) {
      data['DefaultLanguages'] = this.defaultLanguages!.toJson();
    }
    if (this.languages != null) {
      data['Languages'] = this.languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
