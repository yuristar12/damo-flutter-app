import 'package:common_utils/common_utils.dart';
import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/model/homepage_data.dart';
import 'package:dealful_mall/model/language_entity.dart';
import 'package:dealful_mall/model/location_entity.dart';
import 'package:dealful_mall/model/simple_json_object.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:get/get.dart';

class XLocalization {
  static Map<String, dynamic>? _translation;
  static LanguageEntity? _languageEntity;
  static final RxInt _localizationX = RxInt(0);
  static LocationEntity? _countryEntity;
  static LocationEntity? _stateEntity;
  static LocationEntity? _cityEntity;
  static final Rx<CurrencyEntity?> _currencyEntity = Rx(null);
  static String _carAttribute = "";
  static String tempCarAttribute = "";
  static String getTranslatedValue(String key) {
    return XUtils.textOf(_translation?[key] ?? key);
  }

  static void setLanguageEntity(LanguageEntity entity) {
    _languageEntity = entity;
  }

  static CurrencyEntity? get currencyEntity => _currencyEntity.value;

  static void setCurrencyEntity(CurrencyEntity? value, [bool fireChange = false]) {
    _currencyEntity.value = value;
    if(value == null) {
      SharedPreferencesUtil.getInstance().remove(
          AppStrings.APP_CURRENCY);
    } else {
      SharedPreferencesUtil.getInstance().setObject(
          AppStrings.APP_CURRENCY, value);
      if(fireChange) {
        _localizationX.refresh();
      }
    }
  }

  static void loadCarAttribute() {
    SharedPreferencesUtil.getInstance()
        .getString(AppStrings.APP_ATTRIBUTE)
        .then((onValue) {
      _carAttribute = XUtils.textOf(onValue);
    });
  }

  static void saveCarAttribute(String? carAttribute, [bool fireChange = false]) {
    var temp = XUtils.textOf(carAttribute);
    if(temp == _carAttribute) {
      return;
    }
    _carAttribute = temp;
    XUtils.showLog("carAttribute：$carAttribute");
    SharedPreferencesUtil.getInstance().setString(AppStrings.APP_ATTRIBUTE, _carAttribute);
    if(fireChange) {
      _localizationX.refresh();
    }
  }

  static String getCarAttribute() {
    return XUtils.textOf(_carAttribute);
  }

  static void setLanguagePack(SimpleJsonObject jsonObj, [bool fireChange = false]) {
    _translation = jsonObj.toJson();
    SharedPreferencesUtil.getInstance().saveMap(
        "${AppStrings.LANGUAGE_PACK_PREFIX}${_languageEntity?.languageCode}",
        _translation!);
    if(fireChange) {
      _localizationX.refresh();
    }
  }

  static void saveLocation(LocationEntity? countryEntity,LocationEntity? stateEntity, LocationEntity? cityEntity) {
    _countryEntity = countryEntity;
    _stateEntity = stateEntity;
    _cityEntity = cityEntity;
    _saveLocationWithKey(AppStrings.LOCATION_COUNTRY, countryEntity);
    _saveLocationWithKey(AppStrings.LOCATION_STATE, stateEntity);
    _saveLocationWithKey(AppStrings.LOCATION_CITY, cityEntity);
    _localizationX.refresh();
  }

  static String obtainLocationStr() {
    StringBuffer stringBuffer = StringBuffer();
    if(_countryEntity?.id != null) {
      stringBuffer.write(XUtils.textOf(_countryEntity?.name));
      if(stateEntity?.id != null) {
        stringBuffer.write(", ");
        stringBuffer.write(XUtils.textOf(stateEntity?.name));
        if(cityEntity?.id != null) {
          stringBuffer.write(", ");
          stringBuffer.write(XUtils.textOf(cityEntity?.name));
        }
      }
    }
    return stringBuffer.toString();
  }

  static String obtainLocationId() {
    return "${XUtils.textOf(countryEntity?.id)}_${XUtils.textOf(stateEntity?.id)}${XUtils.textOf(cityEntity?.id)}";
  }

  static void _saveLocationWithKey(String key, LocationEntity? countryEntity) {
    if(countryEntity == null) {
      SharedPreferencesUtil.getInstance().remove(key);
    } else {
      SharedPreferencesUtil.getInstance().setObject(key, countryEntity);
    }
  }

  static void loadLanguagePack() {
    SharedPreferencesUtil.getInstance()
        .getMap(
            "${AppStrings.LANGUAGE_PACK_PREFIX}${_languageEntity?.languageCode}")
        .then((onValue) {
      _translation = onValue;
    });
  }

  static void loadLocation() {
    SharedPreferencesUtil.getInstance()
        .getMap(AppStrings.LOCATION_COUNTRY)
        .then((onValue) {
          if(onValue != null) {
            _countryEntity = LocationEntity.fromJson(onValue);
          }
    });
    SharedPreferencesUtil.getInstance()
        .getMap(AppStrings.LOCATION_STATE)
        .then((onValue) {
      if(onValue != null) {
        _stateEntity = LocationEntity.fromJson(onValue);
      }
    });
    SharedPreferencesUtil.getInstance()
        .getMap(AppStrings.LOCATION_CITY)
        .then((onValue) {
      if(onValue != null) {
        _cityEntity = LocationEntity.fromJson(onValue);
      }
    });
  }

  static LanguageEntity? getLanguageEntity() {
    return _languageEntity;
  }

  static bool isPrepared() {
    return _translation != null;
  }

  static void listen(Function(dynamic data) param0) {
    _localizationX.listen(param0);
  }

  static LocationEntity? get cityEntity => _cityEntity;

  static LocationEntity? get countryEntity => _countryEntity;

  static LocationEntity? get stateEntity => _stateEntity;

  static void assignCurrency(List<CurrencyEntity>? currencies, String? defaultCurrency) {
    if(currencies?.isNotEmpty == true) {
      List<CurrencyEntity> list = currencies!;
      var first = list
          .firstWhereOrNull((test) => test.code == _currencyEntity.value?.code);
      if (first == null) {
        first = list.firstWhereOrNull((test) => test.code == defaultCurrency);
        setCurrencyEntity(first);
      }
    }
  }

  static void clear() {
    saveLocation(null, null, null);
  }

}

extension CustomExtension on String {
  String get translated {
    return XLocalization.getTranslatedValue(this);
  }
}
