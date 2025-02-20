import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/app_urls.dart';
import 'package:dealful_mall/model/base_response.dart';
import 'package:dealful_mall/model/user_entity.dart';
import 'package:dealful_mall/utils/http_util.dart';

class UserService {

Future<BaseResponse<dynamic>> register(Map<String, dynamic> parameters) async {
  BaseResponse<dynamic> jsonResult = BaseResponse<dynamic>();
  try {
    var response = await HttpUtil.instance.post(AppUrls.REGISTER, parameters: parameters);
    if (response[AppStrings.ERR_NO] == 0) {
      jsonResult.success = true;
      jsonResult.data = AppStrings.SUCCESS;
    } else {
      jsonResult.success = false;
      jsonResult.msg = response[AppStrings.ERR_MSG] != null
          ? response[AppStrings.ERR_MSG]
          : AppStrings.SERVER_EXCEPTION;
    }
  } catch (e) {
    jsonResult.success = false;
    jsonResult.msg = AppStrings.SERVER_EXCEPTION;
  }
  return jsonResult;
}


}
