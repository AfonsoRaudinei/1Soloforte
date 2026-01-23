class ComparisonModel {
  final String id;
  // Layout: 1 = 1 image, 2 = 2 images
  int photoLayout;

  // Side A
  String? labelA;
  String? photoA;
  String? cultureA;
  String? observationsA;

  // Side B
  String? labelB;
  String? photoB;
  String? cultureB;
  String? observationsB;

  ComparisonModel({
    required this.id,
    this.photoLayout = 2,
    this.labelA = 'Produto A',
    this.photoA,
    this.cultureA,
    this.observationsA,
    this.labelB = 'Produto B',
    this.photoB,
    this.cultureB,
    this.observationsB,
  });
}
