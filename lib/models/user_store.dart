import 'package:cuo_cutter/models/store.dart';
import 'package:cuo_cutter/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_store.g.dart';

enum EmpState {
  @JsonKey(name: "suspended")
  suspended,
  @JsonKey(name: "active")
  active,
}

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class Employee {
  String fullName;
  String id;
  @JsonKey(defaultValue: EmpState.active)
  EmpState state;
  String email;

  Employee({
    @required this.fullName,
    @required this.email,
  });
  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class UserStore {
  @JsonKey(required: true)
  final String storeName;
  final String tagline;
  final String location;
  final List<Employee> employees;
  final List<Store> substores;

  UserStore({
    this.tagline,
    this.storeName,
    this.location,
    this.substores,
    this.employees,
  });
  factory UserStore.fromJson(Map<String, dynamic> json) =>
      _$UserStoreFromJson(json);
  Map<String, dynamic> toJson() => _$UserStoreToJson(this);
}
