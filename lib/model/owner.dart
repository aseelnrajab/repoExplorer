import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner.freezed.dart';

@freezed
abstract class Owner with _$Owner {
  const factory Owner({
    required String login,
    required String avatarUrl,
  }) = _Owner;

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      login: json['login'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
    );
  }
}
