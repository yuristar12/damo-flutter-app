import 'package:dealful_mall/constant/app_parameters.dart';
import 'package:dealful_mall/model/product_entity.dart';
import 'package:dealful_mall/model/project_selection_detail_entity.dart';
import 'package:dealful_mall/service/project_selection_service.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dealful_mall/view_model/base_view_model.dart';
import 'package:dealful_mall/view_model/page_state.dart';

class ProjectSelectionViewModel extends BaseViewModel {
  ProjectSelectionService _projectSelectionService = ProjectSelectionService();
  ProjectSelectionDetailTopic? _projectSelectionDetailTopic;
  List<ProductEntity>? _goods = [];
  List<ProjectSelectionDetailTopic>? _relatedProjectSelectionDetailTopics =
      [];

  ProjectSelectionDetailTopic? get projectSelectionDetailTopic =>
      _projectSelectionDetailTopic;

  List<ProjectSelectionDetailTopic>? get relatedProjectSelectionDetailTopics =>
      _relatedProjectSelectionDetailTopics;

  List<ProductEntity>? get goods => _goods;

  queryDetail(int id) {
    var parameters = {AppParameters.ID: id};
    _projectSelectionService
        .projectSelectionDetail(parameters)
        .then((response) {
      if (response.isSuccess!) {
        _projectSelectionDetailTopic = response.data!.topic;
        _goods = response.data!.goods;
        pageState = PageState.hasData;
        queryRelatedGoods(parameters);
      } else {
        XUtils.showToast(response.message);
      }
    });
  }

  queryRelatedGoods(var parameters) {
    _projectSelectionService
        .projectSelectionRecommend(parameters)
        .then((response) {
      if (response.isSuccess!) {
        _relatedProjectSelectionDetailTopics = response.data!.xList;
        notifyListeners();
      } else {
        XUtils.showToast(response.message);
      }
    });
  }
}
