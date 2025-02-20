
import 'package:dealful_mall/model/setting_entity.dart';

class ColumnItemEntity {
  String? id;
  String? formNo;
  String? formName;
  dynamic sort;
  String? dataField;
  String? dataTitle;
  dynamic dataWidth;
  String? formType;
  dynamic dataSortable;
  dynamic dataVisible;
  List<SettingEntity>? setting;

  ColumnItemEntity();

  ColumnItemEntity.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    formNo = json['FormNo'];
    formName = json['FormName'];
    sort = json['Sort'];
    dataField = json['DataField'];
    dataTitle = json['DataTitle'];
    dataWidth = json['DataWidth'];
    dataSortable = json['DataSortable'];
    dataVisible = json['DataVisible'];
    formType = json['FormType'];
    if (json['Setting'] != null) {
      setting = [];
      json['Setting'].forEach((v) {
        setting!.add(SettingEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['FormNo'] = formNo;
    data['FormName'] = formName;
    data['Sort'] = sort;
    data['DataField'] = dataField;
    data['DataTitle'] = dataTitle;
    data['DataWidth'] = dataWidth;
    data['DataSortable'] = dataSortable;
    data['DataVisible'] = dataVisible;
    data['FormType'] = formType;
    if (setting != null) {
      data['setting'] = setting!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String check(dynamic value) {
    if (value == null) {
      return "";
    }
    if (setting?.isNotEmpty == true) {
      var iterable = setting!.where((item) => item.byVal == value);
      if (iterable.isNotEmpty) {
        return iterable.first.dataText ?? "";
      }
    }
    return value.toString();
  }

  void clearSelect() {
    setting?.forEach((item){
      item.selected = false;
    });
  }
}


