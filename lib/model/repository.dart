import 'package:freezed_annotation/freezed_annotation.dart';

import 'owner.dart';

part 'repository.freezed.dart';

@freezed
abstract class Repository with _$Repository {
  const factory Repository({
    required String ownerUsername,
    required String fullName,
    required String description,
    required Owner owner,
  }) = _Repository;

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
        ownerUsername: json['name'] as String? ?? '',
        fullName: json['full_name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        owner: Owner.fromJson(json['owner'] as Map<String, dynamic>));
  }
}
