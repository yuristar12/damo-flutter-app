import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  SharedPreferencesUtil._();

  static SharedPreferencesUtil? _instance;
  SharedPreferences? sharedPreferences;

  static SharedPreferencesUtil getInstance() {
    if (_instance == null) {
      _instance = SharedPreferencesUtil._();
    }
    return _instance!;
  }

  Future setBool(String key, bool isFirst) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(key, isFirst);
  }

  Future setString(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key, value);
  }

  Future<bool?> getBool(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key);
  }

  Future<int?> getInt(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key);
  }

  Future setInt(String key, int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(key, value);
  }

  Future<String?> getString(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  Future setObject(String key, Object value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key, json.encode(value));
  }

  /// 从本地读取键值对
  Future<Map<String, dynamic>?> getMap(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String value = sharedPreferences.getString(key) ?? "";
    if(value.isNotEmpty) {
      return json.decode(value);
    }
    return null;
  }

  /// 保存键值对到本地
  Future saveMap(String key, Map<String, dynamic> map) async {
    setString(key, json.encode(map));
  }

  Future<bool> remove(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(key);
  }

  Future<bool> clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear();
  }
}
