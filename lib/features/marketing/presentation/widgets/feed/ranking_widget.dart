import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class RankingWidget extends StatelessWidget {
  const RankingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🏆 Top Produtores',
                style: AppTypography.h4.copyWith(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Semanal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          _buildRankItem(1, 'Fazenda Esperança', '120k pts', '🥇'),
          SizedBox(height: AppSpacing.sm),
          _buildRankItem(2, 'Agro Silva', '98k pts', '🥈'),
          SizedBox(height: AppSpacing.sm),
          _buildRankItem(3, 'Grupo Vanguarda', '85k pts', '🥉'),
        ],
      ),
    );
  }

  Widget _buildRankItem(int rank, String name, String points, String badge) {
    return Row(
      children: [
        Text(badge, style: const TextStyle(fontSize: 20)),
        SizedBox(width: AppSpacing.sm),
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.white,
          child: Text(
            name[0],
            style: const TextStyle(fontSize: 10, color: AppColors.primary),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          points,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
