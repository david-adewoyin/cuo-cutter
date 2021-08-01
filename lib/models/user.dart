import 'package:cuo_cutter/storage/storage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(
    explicitToJson: true, fieldRename: FieldRename.snake, includeIfNull: false)
class User {
  final String fullName;
  final String email;
  final String storeName;
  final String tagline;
  final String bio;
  final String password;
  final String location;
  final bool isLoggedIn;
  final List<User> subUsers;
  final List<User> employees;

  User({
    this.fullName,
    this.email,
    this.tagline,
    this.storeName,
    this.bio,
    this.location,
    this.password,
    this.subUsers,
    this.employees,
    this.isLoggedIn = false,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
