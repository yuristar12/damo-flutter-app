// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseListResponse<T> _$BaseListResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BaseListResponse<T>(
      data: (json['Data'] as List<dynamic>?)?.map(fromJsonT).toList(),
      success: json['Success'] as bool?,
      errorCode: (json['ErrorCode'] as num?)?.toInt(),
      msg: json['Msg'] as String?,
      total: (json['Total'] as num?)?.toInt(),
      successCount: (json['SuccessCount'] as num?)?.toInt(),
    )..urlList = json['UrlList'];

Map<String, dynamic> _$BaseListResponseToJson<T>(
  BaseListResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'Data': instance.data?.map(toJsonT).toList(),
      'Success': instance.success,
      'ErrorCode': instance.errorCode,
      'Msg': instance.msg,
      'Total': instance.total,
      'UrlList': instance.urlList,
      'SuccessCount': instance.successCount,
    };

BaseResponse<T> _$BaseResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BaseResponse<T>(
      data: _$nullableGenericFromJson(json['Data'], fromJsonT),
      success: json['Success'] as bool?,
      errorCode: (json['ErrorCode'] as num?)?.toInt(),
      msg: json['Msg'] as String?,
    );

Map<String, dynamic> _$BaseResponseToJson<T>(
  BaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'Data': _$nullableGenericToJson(instance.data, toJsonT),
      'Success': instance.success,
      'ErrorCode': instance.errorCode,
      'Msg': instance.msg,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
