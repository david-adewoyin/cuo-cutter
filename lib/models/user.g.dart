// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    fullName: json['full_name'] as String,
    email: json['email'] as String,
    tagline: json['tagline'] as String,
    storeName: json['store_name'] as String,
    bio: json['bio'] as String,
    location: json['location'] as String,
    password: json['password'] as String,
    subUsers: (json['sub_users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    employees: (json['employees'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isLoggedIn: json['is_logged_in'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('full_name', instance.fullName);
  writeNotNull('email', instance.email);
  writeNotNull('store_name', instance.storeName);
  writeNotNull('tagline', instance.tagline);
  writeNotNull('bio', instance.bio);
  writeNotNull('password', instance.password);
  writeNotNull('location', instance.location);
  writeNotNull('is_logged_in', instance.isLoggedIn);
  writeNotNull(
      'sub_users', instance.subUsers?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'employees', instance.employees?.map((e) => e?.toJson())?.toList());
  return val;
}
