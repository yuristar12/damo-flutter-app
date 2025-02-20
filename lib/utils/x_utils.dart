import 'package:dealful_mall/model/base_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class XUtils {
  static showLog(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

  /// [orEmpty] 当对象得到的字符串是空字符串时也返回[defValue], [suffix]是当值有效且非空字符时的后缀
  static String textOf(item, {String defValue = "", bool orEmpty = false, String suffix = ""}) {
    if(item == null) {
      return defValue;
    } else {
      String result = item.toString();
      if(result.isEmpty && orEmpty) {
        return defValue;
      }
      return result+suffix;
    }
  }


  static showToast(String? message) {
    if (message == null || message.isEmpty) {
      return;
    }
    EasyLoading.showToast(message);
  }

  static void showError(String? message) {
    if (message == null || message.isEmpty) {
      return;
    }
    EasyLoading.showError(message);
  }
}

extension CustomExtension on String? {
  /// 根据当前语言环境返回相应的文案
  String translation(String? zhStr) {
    if (this == null || Get.locale!.languageCode == "zh") {
      return zhStr ?? "";
    }
    return this ?? "";
  }

  String format(List<String> params) {
    String source = this ?? "";
    if (source.contains("{field}") || source.contains("{param}")) {
      String pattern = "\{(field|param)\}";
      int paramsIndex = 0;
      int paramLength = params.length;
      source = source.replaceAllMapped(RegExp(pattern), (match) {
        if (paramsIndex < paramLength) {
          int tempIndex = paramsIndex;
          paramsIndex++;
          return params[tempIndex];
        }
        return match.group(0) ?? "";
      });
    }
    return source;
  }

  /// 将字符串转成颜色,当转换失败时返回默认色
  Color toColor({Color defColor = Colors.transparent}) {
    int value = 0x00000000;
    if (this?.isNotEmpty == true) {
      String colorString = this!;
      if (colorString[0] == "#") {
        colorString = colorString.substring(1);
      }
      value = int.tryParse(colorString, radix: 16) ?? value;
      if (value < 0xff000000) {
        value += 0xff000000;
      }
    }
    return Color(value);
  }
}

extension AsyncExtensions on Future {
  Future<dynamic> apiCallback(Function(Object? data) successFunc, [Function(String errorMsg)? errorFunc]) {
    Function(String errorMsg) realErrorFunc = errorFunc ?? (msg) {
      XUtils.showError(msg);
    };
    return then((onValue) {
      bool success = false;
      int errorCode = 0;
      String msg = "";
      dynamic data;
      if(onValue is BaseResponse) {
        success = onValue.success == true;
        errorCode = onValue.errorCode ?? errorCode;
        msg = onValue.msg ?? msg;
        data = onValue.data;
      } else if (onValue is BaseListResponse) {
        success = onValue.success == true;
        errorCode = onValue.errorCode ?? errorCode;
        msg = onValue.msg ?? msg;
        data = onValue.data;
      }
      if(success) {
        successFunc.call(data);
      } else {
        if(errorCode != 401 || errorFunc != null) {
          realErrorFunc.call(msg);
        }
      }
    }, onError: (error) {
      XUtils.showLog("报错了呀：$error");
      realErrorFunc.call(error.toString());
    });
  }
}
