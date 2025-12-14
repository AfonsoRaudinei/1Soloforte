// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentinel_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SentinelToken _$SentinelTokenFromJson(Map<String, dynamic> json) =>
    _SentinelToken(
      accessToken: json['access_token'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      receivedAt: (json['receivedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SentinelTokenToJson(_SentinelToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'receivedAt': instance.receivedAt,
    };
