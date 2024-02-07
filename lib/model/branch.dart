import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch.freezed.dart';

@freezed
abstract class Branch with _$Branch {
  const factory Branch({
    required String name,
    required bool protected,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      name: json['name'] as String? ?? '',
      protected: json['protected'],
    );
  }
}
