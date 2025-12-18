import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/visits/presentation/visit_controller.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  const CheckOutScreen({super.key});

  @override
  ConsumerState<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
  final TextEditingController _notesController = TextEditingController();
  final Map<String, bool> _checklist = {
    'Verificação de pragas': false,
    'Monitoramento de lavoura': false,
    'Análise de solo': false,
    'Recomendação técnica': false,
    'Registro fotográfico': false,
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visitState = ref.watch(visitControllerProvider);

    return visitState.when(
      data: (visit) {
        if (visit == null) {
          return const Scaffold(
            body: Center(child: Text("Nenhuma visita ativa para check-out.")),
          );
        }

        final duration = DateTime.now().difference(visit.checkInTime);
        final durationStr =
            "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";

        return Scaffold(
          appBar: AppBar(
            title: const Text('Check-out da Visita'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Information
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Check-in realizado às ${DateTime.now().subtract(Duration(hours: 1, minutes: 45)).toString().substring(11, 16)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Tempo: $durationStr',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Talhão Norte',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(visit.client.name),
                            const Text(
                              'Visita técnica',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Text(
                  'Atividades Realizadas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: _checklist.keys.map((key) {
                      return CheckboxListTile(
                        value: _checklist[key],
                        onChanged: (val) {
                          setState(() {
                            _checklist[key] = val ?? false;
                          });
                        },
                        title: Text(key),
                        activeColor: AppColors.primary,
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Observations
                Text('Observações Finais', style: AppTypography.h3),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Digite as observações gerais da visita...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 24),

                // Next Action
                Text('Próxima Ação', style: AppTypography.h3),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(
                      value: 'follow_up_7',
                      child: Text('Follow-up em 7 dias'),
                    ),
                    DropdownMenuItem(
                      value: 'follow_up_14',
                      child: Text('Follow-up em 14 dias'),
                    ),
                    DropdownMenuItem(
                      value: 'application',
                      child: Text('Agendar Aplicação'),
                    ),
                    DropdownMenuItem(
                      value: 'harvest',
                      child: Text('Agendar Colheita'),
                    ),
                    DropdownMenuItem(
                      value: 'none',
                      child: Text('Nenhuma ação imediata'),
                    ),
                  ],
                  onChanged: (val) {},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Selecione a próxima ação'),
                ),
                const SizedBox(height: 24),

                // Footer Options
                CheckboxListTile(
                  value: true,
                  onChanged: (v) {},
                  title: const Text('Gerar relatório automático'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                CheckboxListTile(
                  value: true,
                  onChanged: (v) {},
                  title: const Text('Enviar para cliente'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                CheckboxListTile(
                  value: false,
                  onChanged: (v) {},
                  title: const Text('Agendar próxima visita'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),

                const SizedBox(height: 32),

                // Actions
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitCheckOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Encerrar Visita & Salvar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Erro: $e'))),
    );
  }

  bool _isSubmitting = false;

  Future<void> _submitCheckOut() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(visitControllerProvider.notifier)
          .checkOut(notes: _notesController.text, checklist: _checklist);

      if (mounted) {
        // Go back to Home/Dashboard.
        // Assuming /dashboard exists.
        // We popped ActiveVisit, now we are here.
        // A simple go/pop strategy.
        // Since we are likely pushed on top of ActiveVisit or replacing it?
        // Let's assume we replace or we navigate to root.
        context.go('/'); // Or dashboard

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Visita finalizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao finalizar: $e')));
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
