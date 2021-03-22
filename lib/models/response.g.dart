// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseError _$ResponseErrorFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['code', 'message', 'desc']);
  return ResponseError(
    code: json['code'] as int,
    message: json['message'] as String,
    desc: json['desc'] as String,
    field: json['field'] as String,
  );
}

Map<String, dynamic> _$ResponseErrorToJson(ResponseError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'desc': instance.desc,
      'field': instance.field,
    };
