import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm_model.freezed.dart';
part 'farm_model.g.dart';

@freezed
class Farm with _$Farm {
  const factory Farm({
    required String id,
    required String clientId,
    required String name,
    required String city,
    required String state,
    String? address,
    double? totalAreaHa,
    int? totalAreas,
    String? description,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Farm;

  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);
}
