import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Remove unused Router import since we don't navigate out
// import 'package:go_router/go_router.dart';

import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  // State
  String? _tipo;
  String? _pagina;
  final TextEditingController _mensagemController = TextEditingController();
  bool _enviado = false;

  // Constants
  final List<String> _paginas = [
    'Dashboard',
    'Login',
    'Relatórios',
    'Agenda',
    'Clima',
    'Clientes',
    'Configurações',
    'Outro',
  ];

  @override
  void dispose() {
    _mensagemController.dispose();
    super.dispose();
  }

  void _handleEnviar() {
    if (_tipo != null && _mensagemController.text.isNotEmpty) {
      setState(() {
        _enviado = true;
      });

      // Reset after 3 seconds
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _enviado = false;
            _tipo = null;
            _pagina = null;
            _mensagemController.clear();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _enviado ? _buildSuccessView() : _buildContent();
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 672,
          ), // max-w-2xl equivalent
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Column(
                  children: [
                    Text('Feedback', style: AppTypography.h2),
                    const SizedBox(height: 8),
                    Text(
                      'Ajude-nos a melhorar o SoloForte',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // 1. ESTATÍSTICAS DE FEEDBACK
              _buildStatsGrid(),
              const SizedBox(height: AppSpacing.xl),

              // 2. FORMULÁRIO DE FEEDBACK
              _buildFeedbackForm(),
              const SizedBox(height: AppSpacing.xl),

              // 4. PROBLEMAS RESOLVIDOS
              _buildResolvedIssues(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.1, // Adjust based on visual need
      children: [
        _buildStatCard(
          icon: Icons.bug_report,
          color: AppColors.error, // Red
          bgCollor: AppColors.error.withValues(alpha: 0.1),
          count: '12',
          label: 'Bug',
        ),
        _buildStatCard(
          icon: Icons.lightbulb,
          color: AppColors.warning, // Yellow/Amber
          bgCollor: AppColors.warning.withValues(alpha: 0.1),
          count: '28',
          label: 'Sugestão',
        ),
        _buildStatCard(
          icon: Icons.favorite,
          color: AppColors.success, // Green
          bgCollor: AppColors.success.withValues(alpha: 0.1),
          count: '45',
          label: 'Elogios',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required Color bgCollor,
    required String count,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgCollor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(count, style: AppTypography.h3),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm() {
    final isBug = _tipo == 'Bug';
    final isSugestao = _tipo == 'Sugestão';

    String labelText = 'Sua mensagem';
    String hintText = 'Compartilhe sua experiência...';
    if (isBug) {
      labelText = 'Descreva o problema';
      hintText = 'Detalhe o problema encontrado...';
    } else if (isSugestao) {
      labelText = 'Sua sugestão';
      hintText = 'Como podemos melhorar?';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tipo de Feedback
          Text('Tipo de Feedback', style: AppTypography.label),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: _tipo,
            items: [
              _buildDropdownItem('Bug', Icons.bug_report, AppColors.error),
              _buildDropdownItem(
                'Sugestão',
                Icons.lightbulb,
                AppColors.warning,
              ),
              _buildDropdownItem('Elogios', Icons.favorite, AppColors.success),
            ],
            onChanged: (val) {
              setState(() {
                _tipo = val;
                // Reset page if switching away from Bug
                if (val != 'Bug') _pagina = null;
              });
            },
            decoration: const InputDecoration(hintText: 'Selecione o tipo'),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Página com Problema (Condicional)
          if (isBug) ...[
            Text('Página com Problema', style: AppTypography.label),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _pagina,
              items: _paginas
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _pagina = val),
              decoration: const InputDecoration(hintText: 'Selecione a página'),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Mensagem
          Text(labelText, style: AppTypography.label),
          const SizedBox(height: 8),
          TextField(
            controller: _mensagemController,
            maxLines: null,
            minLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: hintText,
              alignLabelWithHint: true,
            ),
            onChanged: (_) => setState(() {}), // Refresh for disable logic
          ),
          const SizedBox(height: AppSpacing.lg),

          // Botão Enviar
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: (_tipo != null && _mensagemController.text.isNotEmpty)
                  ? _handleEnviar
                  : null,
              icon: const Icon(Icons.send, size: 20),
              label: const Text('Enviar Feedback'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0057FF), // Primary blue
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(
    String value,
    IconData icon,
    Color color,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildResolvedIssues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Problemas Resolvidos', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.md),
        _buildResolvedCard(
          title: 'Carregamento do mapa otimizado',
          description: 'Resolvido problema de lentidão no carregamento',
          footer: 'Baseado em 8 feedbacks',
        ),
        _buildResolvedCard(
          title: 'Nova funcionalidade de filtros',
          description: 'Adicionado filtros avançados nos relatórios',
          footer: 'Baseado em 15 sugestões',
        ),
        _buildResolvedCard(
          title: 'Melhorias na interface',
          description: 'Interface mais intuitiva e responsiva',
          footer: 'Baseado em 12 feedbacks',
        ),
      ],
    );
  }

  Widget _buildResolvedCard({
    required String title,
    required String description,
    required String footer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  footer,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              color: AppColors.success,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text('Obrigado!', style: AppTypography.h2),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Seu feedback foi enviado com sucesso. Ele é muito importante para nós!',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
