// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Client _$ClientFromJson(Map<String, dynamic> json) => _Client(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  cpfCnpj: json['cpfCnpj'] as String?,
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  lastActivity: DateTime.parse(json['lastActivity'] as String),
  avatarUrl: json['avatarUrl'] as String?,
  notes: json['notes'] as String?,
  farmIds:
      (json['farmIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ClientToJson(_Client instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'cpfCnpj': instance.cpfCnpj,
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'type': instance.type,
  'status': instance.status,
  'lastActivity': instance.lastActivity.toIso8601String(),
  'avatarUrl': instance.avatarUrl,
  'notes': instance.notes,
  'farmIds': instance.farmIds,
};
