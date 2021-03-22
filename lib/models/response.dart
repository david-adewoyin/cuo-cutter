import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

//UserResponseError is used to contruct errors relating to user
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ResponseError {
  @JsonKey(required: true)
  int code;
  @JsonKey(required: true)
  String message;
  @JsonKey(required: true)
  String desc;
  String field;
  ResponseError(
      {@required this.code,
      @required this.message,
      @required this.desc,
      this.field});

  factory ResponseError.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseErrorToJson(this);
}
