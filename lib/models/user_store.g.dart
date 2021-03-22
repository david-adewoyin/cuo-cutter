// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) {
  return Employee(
    fullName: json['full_name'] as String,
    email: json['email'] as String,
  )
    ..id = json['id'] as String
    ..state = _$enumDecodeNullable(_$EmpStateEnumMap, json['state']) ??
        EmpState.active;
}

Map<String, dynamic> _$EmployeeToJson(Employee instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('full_name', instance.fullName);
  writeNotNull('id', instance.id);
  writeNotNull('state', _$EmpStateEnumMap[instance.state]);
  writeNotNull('email', instance.email);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EmpStateEnumMap = {
  EmpState.suspended: 'suspended',
  EmpState.active: 'active',
};

UserStore _$UserStoreFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['store_name']);
  return UserStore(
    tagline: json['tagline'] as String,
    storeName: json['store_name'] as String,
    location: json['location'] as String,
    substores: (json['substores'] as List)
        ?.map(
            (e) => e == null ? null : Store.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    employees: (json['employees'] as List)
        ?.map((e) =>
            e == null ? null : Employee.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserStoreToJson(UserStore instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('store_name', instance.storeName);
  writeNotNull('tagline', instance.tagline);
  writeNotNull('location', instance.location);
  writeNotNull(
      'employees', instance.employees?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'substores', instance.substores?.map((e) => e?.toJson())?.toList());
  return val;
}
