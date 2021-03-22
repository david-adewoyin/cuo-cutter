// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return Employee(
    fullName: json['full_name'] as String,
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$EmployeeToJson(Employee instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('full_name', instance.fullName);
  writeNotNull('email', instance.email);
  return val;
}
