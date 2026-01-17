enum MarketingPlanLevel { bronze, prata, ouro }

enum MarketingBillingUnit { perPublication, perPeriod }

class MarketingPlan {
  final MarketingPlanLevel level;
  final String description;
  final double price;
  final MarketingBillingUnit unit;
  final bool isActive;

  const MarketingPlan({
    required this.level,
    required this.description,
    required this.price,
    required this.unit,
    required this.isActive,
  });

  MarketingPlan copyWith({
    MarketingPlanLevel? level,
    String? description,
    double? price,
    MarketingBillingUnit? unit,
    bool? isActive,
  }) {
    return MarketingPlan(
      level: level ?? this.level,
      description: description ?? this.description,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      isActive: isActive ?? this.isActive,
    );
  }
}
