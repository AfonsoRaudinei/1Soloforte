import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../domain/comparison_models.dart';
import '../application/comparison_services.dart';
import 'comparison_widgets.dart';

class ConclusaoCard extends StatelessWidget {
  final Conclusao conclusao;
  final Function() onChanged;
  final Function() onRemove;

  const ConclusaoCard({
    super.key,
    required this.conclusao,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CONCLUSÃO', style: AppTypography.sectionTitle),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onRemove,
                ),
              ],
            ),
            TextFormField(
              initialValue: conclusao.texto,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Escreva a conclusão do relatório...',
                border: InputBorder.none,
              ),
              style: AppTypography.bodyText,
              onChanged: (v) {
                conclusao.texto = v;
                onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ROICard extends StatelessWidget {
  final ROI roi;
  final double area;
  final Function() onChanged;
  final Function() onRemove;

  const ROICard({
    super.key,
    required this.roi,
    required this.area,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final roiPercent = ROICalculator.calcularROI(roi.investimento, roi.retorno);
    final retornoTotal = ROICalculator.calcularRetornoTotal(roi.investimento, roi.retorno, area);
    
    Color roiColor = AppColors.textSecondary;
    if (roiPercent > 0) roiColor = AppColors.success;
    if (roiPercent < 0) roiColor = AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CÁLCULO DE ROI', style: AppTypography.sectionTitle),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: roi.investimento == 0 ? '' : roi.investimento.toString(),
                    decoration: const InputDecoration(labelText: 'Investimento R\$/ha', isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      roi.investimento = double.tryParse(v) ?? 0;
                      onChanged();
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    initialValue: roi.retorno == 0 ? '' : roi.retorno.toString(),
                    decoration: const InputDecoration(labelText: 'Retorno R\$/ha', isDense: true),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      roi.retorno = double.tryParse(v) ?? 0;
                      onChanged();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDisplay('ROI %', '${roiPercent.toStringAsFixed(1)}%', roiColor),
                _buildDisplay('RETORNO TOTAL', retornoTotal, AppColors.iosBlue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        Text(value, style: AppTypography.roiValue.copyWith(color: color)),
      ],
    );
  }
}
