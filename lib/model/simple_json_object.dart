
class SimpleJsonObject {
  Map<String, dynamic>? bean;

  SimpleJsonObject();

  SimpleJsonObject.fromJson(this.bean);

  bool selected = false;

  Map<String, dynamic> toJson() {
    if (bean == null) {
      return <String, dynamic>{};
    } else {
      return bean!;
    }
  }

  bool hasKey(String key) {
    return toJson().containsKey(key);
  }

  void setValue(String key, dynamic value) {
    if (bean != null) {
      bean![key] = value;
    }
  }

  dynamic operator [](String? key) {
    if (key == null) {
      return null;
    }
    return toJson()[key];
  }

  static SimpleJsonObject fromJsonModel(Object? json) =>
      SimpleJsonObject.fromJson(json as Map<String, dynamic>);
}
