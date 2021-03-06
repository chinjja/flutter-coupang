import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@CopyWith()
class User extends Equatable {
  final String username;
  final String password;

  const User({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}
