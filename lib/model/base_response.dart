import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

///
/// Wrapper base response
///
@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class BaseListResponse<T> {
  @JsonKey(name: 'Data')
  List<T>? data;
  @JsonKey(name: 'Success')
  bool? success;
  @JsonKey(name: 'ErrorCode')
  int? errorCode;
  @JsonKey(name: 'Msg')
  String? msg;
  @JsonKey(name: 'Total')
  int? total;
  @JsonKey(name: 'UrlList')
  dynamic urlList;
  @JsonKey(name: 'SuccessCount')
  int? successCount;

  BaseListResponse({this.data, this.success, this.errorCode, this.msg, this.total, this.successCount});

  factory BaseListResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseListResponseFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$BaseListResponseToJson<T>(this, toJsonT);

  String? get message=>msg;
  bool? get isSuccess=>success;
}

///
/// Wrapper base response
///
@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class BaseResponse<T> {
  @JsonKey(name: 'Data')
  T? data;
  @JsonKey(name: 'Success')
  bool? success;
  @JsonKey(name: 'ErrorCode')
  int? errorCode;
  @JsonKey(name: 'Msg')
  String? msg;

  BaseResponse({this.data, this.success, this.errorCode, this.msg});

  factory BaseResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResponseFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$BaseResponseToJson<T>(this, toJsonT);

  String? get message=>msg;
  bool? get isSuccess=>success;
}
