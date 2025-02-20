import 'package:dealful_mall/model/address_entity.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/service/mine_service.dart';
import 'package:dealful_mall/utils/http_util.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';
import 'package:dealful_mall/view_model/user_view_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddressViewModel extends BaseViewModel {
  MineService _mineService = MineService();
  List<AddressEntity> _address = [];
  List<KeyEntity> addressTypes = [];
  List<AddressEntity> get address => _address;

  queryAddressData() {
    HttpUtil.fetchApiStore().getAddressList().then((response) {
      if (response.isSuccess == true) {
        if(response.data != null) {
          _address.assignAll(response.data!);
        }
        pageState = address.isEmpty ? PageState.empty : PageState.hasData;
        notifyListeners();
      } else {
        errorNotify(response.message);
      }
    });
  }
}
