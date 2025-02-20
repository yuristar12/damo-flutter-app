import 'dart:convert';
import 'dart:io';

import 'package:dealful_mall/constant/app_strings.dart';
import 'package:dealful_mall/constant/app_urls.dart';
import 'package:dealful_mall/model/language_entity.dart';
import 'package:dealful_mall/utils/api_store.dart';
import 'package:dealful_mall/utils/shared_preferences_util.dart';
import 'package:dealful_mall/utils/x_router.dart';
import 'package:dealful_mall/utils/x_localization.dart';
import 'package:dealful_mall/utils/x_utils.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as Getx;

class HttpUtil {
  // 工厂模式
  static HttpUtil get instance => _getInstance();
  static HttpUtil? _httpUtil;
  late var dio;
  late ApiStore _apiStore;

  static HttpUtil _getInstance() {
    if (_httpUtil == null) {
      _httpUtil = HttpUtil();
    }
    return _httpUtil!;
  }

  static ApiStore fetchApiStore() {
    return instance._apiStore;
  }

  HttpUtil() {
    BaseOptions options = BaseOptions(
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 30),
    );
    options.headers[HttpHeaders.userAgentHeader] = AppStrings.APP_UA;
    dio = new Dio(options);
    _apiStore = ApiStore(dio, AppUrls.BASE_URL);
    dio.interceptors.add(InterceptorsWrapper(onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      await SharedPreferencesUtil.getInstance()
          .getString(AppStrings.TOKEN)
          .then((token) {
        if (token?.isNotEmpty == true) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      });
      LanguageEntity? entity = XLocalization.getLanguageEntity();
      if(entity?.languageCode != null) {
        options.headers['Language'] = entity?.languageCode;
      }
      options.headers['Location'] = XLocalization.obtainLocationId();
      String? currencyCode = XLocalization.currencyEntity?.code;
      if(currencyCode != null) {
        options.headers['Currency'] = currencyCode;
      }
      String carAttribute = XLocalization.getCarAttribute();
      if(XLocalization.tempCarAttribute.isNotEmpty) {
        options.headers['AttributeValue'] = XLocalization.tempCarAttribute;
      } else if(carAttribute.isNotEmpty) {
        options.headers['AttributeValue'] = carAttribute;
      }
      options.headers['BranchId'] = '1353057';
      XUtils.showLog(
          "请求path:${options.uri.toString()} ,BranchId=${options.headers['BranchId']} ,Authorization=${options.headers['Authorization']} Language=${options.headers['Language']} body=${json.encode(options.data)}");
      return handler.next(options);
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      print("========================请求数据===================");

      print("${response.requestOptions.path}的response=${response.data}");
      if (response.data[AppStrings.ERR_NO] == 401) {
        SharedPreferencesUtil.getInstance().remove(AppStrings.TOKEN);
        Getx.Get.toNamed(XRouterPath.login);
      }
      return handler.next(response);
    }, onError: (DioException error, ErrorInterceptorHandler handler) {
      XUtils.showError(error.message);
      handler.next(error);
      print(
          "${error.requestOptions.path} 请求错误, error.message =${error.message}");
    }));
  }

  //get请求
  Future get(String url,
      {Map<String, dynamic>? parameters, Options? options}) async {
    Response? response;
    if (parameters != null && options != null) {
      response =
          await dio.get(url, queryParameters: parameters, options: options);
    } else if (parameters != null && options == null) {
      response = await dio.get(url, queryParameters: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.get(url, options: options);
    } else {
      response = await dio.get(url);
    }
    return response!.data;
  }

  //post请求
  Future post(String url,
      {Map<String, dynamic>? parameters, Options? options}) async {
    Response? response;
    if (parameters != null && options != null) {
      response = await dio.post(url, data: parameters, options: options);
    } else if (parameters != null && options == null) {
      response = await dio.post(url, data: parameters);
    } else if (parameters == null && options != null) {
      response = await dio.post(url, options: options);
    } else {
      response = await dio.post(url);
    }
    return response!.data;
  }
}
