import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Ajuda'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFaqItem(
              'Como funciona o modo offline?',
              'O modo offline permite que você acesse seus mapas e dados mesmo sem internet. Os dados são sincronizados automaticamente quando a conexão for restabelecida.',
            ),
            const SizedBox(height: 12),
            _buildFaqItem(
              'Como alterar configurações?',
              'Acesse o menu Configurações no canto superior direito do mapa. Lá você pode ajustar preferências de conta, tema, idioma e dados.',
            ),
            const SizedBox(height: 12),
            _buildFaqItem(
              'Como funcionam ocorrências e alertas?',
              'As ocorrências permitem registrar problemas no campo com geolocalização. Alertas são gerados automaticamente baseados na gravidade da ocorrência.',
            ),
            const SizedBox(height: 12),
            _buildFaqItem(
              'Problemas comuns de sincronização',
              'Verifique se você está conectado à internet. Se o problema persistir, tente fazer logout e login novamente para forçar uma nova sincronização.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            answer,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
