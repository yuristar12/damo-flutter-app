import 'package:dealful_mall/constant/text_style.dart';
import 'package:dealful_mall/model/key_entity.dart';
import 'package:dealful_mall/model/label_entity.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:flutter/material.dart';

class CommonWidgetCreater{
  static List<DropdownMenuItem<KeyEntity>> buildKeyMenus(List<KeyEntity> keyEntities, {TextStyle? textStyle}) =>
      List.generate(keyEntities.length, (index) {
        KeyEntity keyEntity = keyEntities[index];
        return DropdownMenuItem<KeyEntity>(
            value: keyEntity,
            child: Text(
              XUtils.textOf(keyEntity.title),
              style: textStyle,
            ));
      });

  static List<DropdownMenuItem<LabelEntity>> buildLabelMenus(List<LabelEntity> labelEntities, {TextStyle? textStyle}) =>
      List.generate(labelEntities.length, (index) {
        LabelEntity keyEntity = labelEntities[index];
        return DropdownMenuItem<LabelEntity>(
            value: keyEntity,
            child: Text(
              XUtils.textOf(keyEntity.label),
              style: textStyle,
            ));
      });
}