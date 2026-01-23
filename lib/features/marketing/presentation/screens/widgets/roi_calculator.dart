class RoiCalculator {
  /// Calcula o ROI baseado no investimento e retorno.
  /// Retorna o valor em porcentagem ou 0 se inválido.
  static double calculate({
    required double investment,
    required double returnVal,
  }) {
    if (investment <= 0) return 0.0;
    return ((returnVal - investment) / investment) * 100;
  }

  /// Formata o valor monetário (apenas visual, simplificado)
  static String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  /// Formata a porcentagem do ROI
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(2)}%';
  }
}
