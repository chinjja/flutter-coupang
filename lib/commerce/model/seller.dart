import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seller.g.dart';

@JsonSerializable()
@CopyWith()
class Seller extends Equatable {
  final String id;
  final String userId;
  final String name;

  const Seller({
    required this.id,
    required this.userId,
    required this.name,
  });

  @override
  List<Object?> get props => [id, userId, name];

  factory Seller.fromJson(Map<String, dynamic> json) {
    return _$SellerFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SellerToJson(this);
  }
}
