import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/app_urls.dart';
import 'package:dealful_mall/model/brand_detail_entity.dart';
import 'package:dealful_mall/model/base_response.dart';
import 'package:dealful_mall/utils/http_util.dart';

/**
 * Create by luyouxin
 * description
    Created by $USER_NAME on 2020/9/16.
 */

class BrandDetailService{

  Future<BaseResponse<BrandDetailEntity>> queryBrandDetail(Map<String, dynamic> parameters) async {
    BaseResponse<BrandDetailEntity> jsonResult=new BaseResponse<BrandDetailEntity>();
    try {
      var response =
      await HttpUtil.instance.get(AppUrls.BRAND_DETAIL, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        BrandDetailEntity brandDetailEntity =
        BrandDetailEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.success = true;
        jsonResult.data = brandDetailEntity;
      } else {
        jsonResult.success = false;
        jsonResult.msg = response[AppStrings.ERR_MSG] != null
            ? response[AppStrings.ERR_MSG]
            : AppStrings.SERVER_EXCEPTION;
      }
    } catch (e) {
      jsonResult.success = false;
      jsonResult.msg = AppStrings.SERVER_EXCEPTION;
      print(e.toString());
    }
    return jsonResult;
  }
}