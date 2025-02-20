import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/model/location_entity.dart';
import 'package:dealful_mall/service/mine_service.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AddressDetailViewModel extends BaseViewModel {
  MineService _mineService = MineService();
  late AddressEntity _addressEntity;

  KeyEntity? selectedType;
  final RxList<KeyEntity> addressTypesX = RxList();
  RxString addressAreaX = RxString("");
  RxBool isDefaultX = RxBool(false);
  String? _name;
  String? _phone;
  String? _addressDetail;

  String? _stateName;
  String? _cityName;
  String? _countryName;
  String? _id;

  AddressEntity get addressEntity => _addressEntity;

  String? get name => _name;

  String? get phone => _phone;

  String? get addressDetail => _addressDetail;

  String? get cityName => _cityName;

  String? get countryName => _countryName;

  String? get id => _id;

  setDefault(bool value) {
    isDefaultX.value = value;
  }

  void saveLocation(LocationEntity? countryEntity, LocationEntity? stateEntity, LocationEntity? cityEntity) {
    String countryName = XUtils.textOf(countryEntity?.name);
    String stateName = XUtils.textOf(stateEntity?.name);
    String cityName = XUtils.textOf(cityEntity?.name);
    addressAreaX.value = XUtils.textOf(countryName, orEmpty: true, suffix: " ") + XUtils.textOf(stateName, orEmpty: true, suffix: " ") + XUtils.textOf(cityName, orEmpty: true);
    _countryName = countryName;
    _stateName = stateName;
    _cityName = cityName;
    addressEntity.countryId = countryEntity?.id;
    addressEntity.stateId = stateEntity?.id;
  }

  queryAddressDetail(String addressId) {
    _addressEntity = AddressEntity();
    if (addressId.isEmpty) {
      pageState = PageState.hasData;
      acquireAddressTypes();
      notifyListeners();
      return;
    }
    _mineService.queryAddressDetail(addressId).then((response) {
      if (response.isSuccess == true) {
        pageState = PageState.hasData;
        _addressEntity = response.data!;
        isDefaultX.value = _addressEntity.isMain ?? false;
        _stateName = _addressEntity.state;
        _cityName = _addressEntity.city;
        _countryName = _addressEntity.country;
        addressAreaX.value = XUtils.textOf(countryName, orEmpty: true, suffix: " ") + XUtils.textOf(_stateName, orEmpty: true, suffix: " ") + XUtils.textOf(_cityName, orEmpty: true);
        _name = _addressEntity.name;
        _phone = _addressEntity.phoneNumber;
        _addressDetail = _addressEntity.address;
        _id = _addressEntity.id;
        acquireAddressTypes();
        notifyListeners();
      } else {
        pageState = PageState.error;
        XUtils.showToast(response.message);
      }
    });
  }

  void acquireAddressTypes() {
    HttpUtil.fetchApiStore().getAddressType().apiCallback((data) {
      if (data is List<KeyEntity>) {
        addressTypesX.assignAll(data);
        if (addressTypesX.isNotEmpty) {
          selectedType = addressTypesX.firstWhere(
              (test) => test.key == addressEntity.addressType,
              orElse: () => addressTypesX.first);
          notifyListeners();
        }
      }
    });
  }

  Future<bool?> saveAddress(
      String title,
      String firstName,
      String lastName,
      String email,
      String zipCode,
      String tel,
      String addressDetail,) async {
    bool? result = false;
    _addressEntity.title = title;
    _addressEntity.firstName = firstName;
    _addressEntity.lastName = lastName;
    _addressEntity.email = email;
    _addressEntity.zipCode = zipCode;
    _addressEntity.phoneNumber = tel;
    _addressEntity.address = addressDetail;
    _addressEntity.country = _countryName;
    _addressEntity.state = _stateName;
    _addressEntity.city = _cityName;
    _addressEntity.isMain = isDefaultX.value;
    _addressEntity.addressType = selectedType?.key;
    if(_addressEntity.userId == null) {
      // _addressEntity.userId = "1";
    }
    await _mineService.saveAddress(_addressEntity.toJson()).then((response) {
      result = response.isSuccess;
      if (result != true) {
        XUtils.showToast(response.message);
      }
    });
    return result;
  }

  Future<bool?> deleteAddress(String? id) async {
    bool? result = false;
    await _mineService.deleteAddress([id ?? ""]).then((response) {
      result = response.isSuccess;
    });
    return result;
  }
}
