import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/visits/domain/entities/visit.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';
import 'package:go_router/go_router.dart';

class CheckOutModal extends ConsumerStatefulWidget {
  final Visit visit;

  const CheckOutModal({super.key, required this.visit});

  @override
  ConsumerState<CheckOutModal> createState() => _CheckOutModalState();
}

class _CheckOutModalState extends ConsumerState<CheckOutModal> {
  final TextEditingController _notesController = TextEditingController();
  bool _generateReport = true;
  bool _sendToClient = false;
  bool _scheduleNext = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleCheckOut() {
    // In a real app, pass boolean flags to the controller/usecase
    ref
        .read(visitControllerProvider.notifier)
        .checkOut(notes: _notesController.text);

    context.pop(); // Close modal

    // Show Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Visita finalizada com sucesso! Relatório gerado.'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'Ver',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to report or history
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final duration = DateTime.now().difference(widget.visit.checkInTime);
    final durationStr =
        "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.red50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flag_outlined,
                  color: AppColors.red600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Finalizar Visita',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSummaryRow(Icons.person, widget.visit.client.name),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  Icons.place,
                  widget.visit.areaName ?? 'Área não definida',
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(Icons.timer, 'Duração total: $durationStr'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Notes
          Text(
            'Observações finais & Recomendações',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: 'Digite aqui...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Checkboxes
          _buildCheckbox(
            'Gerar relatório automático',
            _generateReport,
            (v) => setState(() => _generateReport = v!),
          ),
          _buildCheckbox(
            'Enviar para cliente (WhatsApp/Email)',
            _sendToClient,
            (v) => setState(() => _sendToClient = v!),
          ),
          _buildCheckbox(
            'Agendar próxima visita (Follow-up)',
            _scheduleNext,
            (v) => setState(() => _scheduleNext = v!),
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleCheckOut,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Finalizar e Salvar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
