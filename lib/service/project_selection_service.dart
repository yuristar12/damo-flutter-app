import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/app_urls.dart';
import 'package:dealful_mall/model/base_response.dart';
import 'package:dealful_mall/model/project_selection_detail_entity.dart';
import 'package:dealful_mall/model/related_project_selection_entity.dart';
import 'package:dealful_mall/utils/http_util.dart';

class ProjectSelectionService {
  Future<BaseResponse<ProjectSelectionDetailEntity>> projectSelectionDetail(
      Map<String, dynamic> parameters) async {
    BaseResponse<ProjectSelectionDetailEntity> jsonResult =
        BaseResponse<ProjectSelectionDetailEntity>();
    try {
      var response = await HttpUtil.instance
          .get(AppUrls.PROJECT_SELECTION_DETAIL, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        ProjectSelectionDetailEntity projectSelectionDetailEntity =
            ProjectSelectionDetailEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.success = true;
        jsonResult.data = projectSelectionDetailEntity;
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

  Future<BaseResponse<RelatedProjectSelectionEntity>> projectSelectionRecommend(
      Map<String, dynamic> parameters) async {
    BaseResponse<RelatedProjectSelectionEntity> jsonResult =
        BaseResponse<RelatedProjectSelectionEntity>();
    try {
      var response = await HttpUtil.instance
          .get(AppUrls.PROJECT_SELECTION_RECOMMEND, parameters: parameters);
      if (response[AppStrings.ERR_NO] == 0 &&
          response[AppStrings.DATA] != null) {
        RelatedProjectSelectionEntity relatedProjectSelectionEntity =
            RelatedProjectSelectionEntity.fromJson(response[AppStrings.DATA]);
        jsonResult.success = true;
        jsonResult.data = relatedProjectSelectionEntity;
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
