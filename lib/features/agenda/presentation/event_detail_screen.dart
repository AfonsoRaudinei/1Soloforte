import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
import 'package:soloforte_app/features/agenda/presentation/extensions/event_type_extension.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/agenda/presentation/agenda_controller.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final Event event;
  final String? returnToClientId;

  const EventDetailScreen({
    super.key,
    required this.event,
    this.returnToClientId,
  });

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  late Event _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    // ╔═════════════════════════════╗
    // ║ Informações                 ║
    // ╠═════════════════════════════╣
    // ...
    // ASCII style suggests structured boxes with headers.

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for contrast
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // [←]
          onPressed: () {
            if (widget.returnToClientId != null) {
              context.go('/map/clients/${widget.returnToClientId}');
              return;
            }
            context.pop();
          },
        ),
        title: Text(_event.title),
        actions: [
          TextButton.icon(
            // [✏️ Editar]
            onPressed: () {
              if (widget.returnToClientId != null) {
                context.push(
                  '/dashboard/calendar/new',
                  extra: {
                    'event': _event,
                    'clientId': widget.returnToClientId,
                  },
                );
                return;
              }
              context.push('/dashboard/calendar/new', extra: _event);
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Editar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // • VISITA TÉCNICA (Type Header)
            Row(
              children: [
                Icon(_event.type.icon, size: 16, color: _event.type.color),
                const SizedBox(width: 8),
                Text(
                  _event.type.label.toUpperCase(),
                  style: AppTypography.label.copyWith(
                    color: _event.type.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Box: Informações
            // ║ 📅 28/Outubro/2025
            // ║ 🕐 09:00 - 11:00 (2h)
            // ║ 👤 João Silva
            // ║ 📍 Talhão Norte - 45.3 ha
            // ║ 🏡 Fazenda Boa Vista
            _buildAsciiBox(
              title: 'Informações',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoLine(
                    Icons.calendar_today,
                    DateFormat(
                      "dd/MMMM/yyyy",
                      'pt_BR',
                    ).format(_event.startTime),
                  ),
                  _buildInfoLine(
                    Icons.access_time,
                    '${DateFormat('HH:mm').format(_event.startTime)} - ${DateFormat('HH:mm').format(_event.endTime)} (${_event.endTime.difference(_event.startTime).inHours}h)',
                  ),
                  _buildInfoLine(
                    Icons.person,
                    _event.clientName ?? 'João Silva (Mock)',
                  ), // Producer not in Event model yet, mocking
                  _buildInfoLine(Icons.location_on, _event.location),
                  _buildInfoLine(Icons.home, 'Fazenda Boa Vista (Mock)'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Box: Objetivo (Description)
            if (_event.description.isNotEmpty)
              _buildAsciiBox(
                title: 'Objetivo',
                content: Text(
                  _event.description,
                  style: AppTypography.bodyMedium,
                ),
              ),
            if (_event.description.isNotEmpty) const SizedBox(height: 16),

            // Box: Checklist (Mock)
            // ║ ☐ Inspeção visual
            // ║ ☐ Coleta de amostras
            _buildAsciiBox(
              title: 'Checklist de Atividades',
              content: Column(
                children: [
                  _buildCheckItem('Inspeção visual'),
                  _buildCheckItem('Coleta de amostras'),
                  _buildCheckItem('Fotos das áreas afetadas'),
                  _buildCheckItem('Medição de severidade'),
                  _buildCheckItem('Recomendação escrita'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Box: Clima Previsto (Mock)
            // ║ ☀️ Ensolarado, 28°C
            // ║ 💨 Vento: 8 km/h
            // ║ 🌧️ Chuva: 0%
            _buildAsciiBox(
              title: 'Clima Previsto',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoLine(Icons.wb_sunny, 'Ensolarado, 28°C'),
                  _buildInfoLine(Icons.air, 'Vento: 8 km/h'),
                  _buildInfoLine(Icons.water_drop, 'Chuva: 0%'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Bom para aplicação',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Box: Notificações (Mock)
            // ║ 🔔 1 hora antes
            // ║ 🔔 30 min antes (rota)
            _buildAsciiBox(
              title: 'Notificações',
              content: Column(
                children: [
                  _buildInfoLine(Icons.notifications_active, '1 hora antes'),
                  _buildInfoLine(
                    Icons.notifications_active,
                    '30 min antes (rota)',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Actions
            // [🚗 Ver Rota] [📞 Ligar]
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.directions_car, size: 16),
                    label: const Text('Ver Rota'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('Ligar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // [✓ Iniciar Visita]
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/check-in');
                },
                icon: const Icon(Icons.check),
                label: const Text('Iniciar Visita'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // [🗑️ Cancelar Evento]
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _deleteEvent,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Cancelar Evento',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteEvent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Evento'),
        content: const Text('Deseja realmente excluir este evento?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sim, Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Optimistic delete or wait?
      // State is async, but we can just fire and forget or await.
      // Awaiting specifically.
      await ref.read(agendaControllerProvider.notifier).deleteEvent(_event.id);

      if (mounted) {
        // Go back to Agenda
        // context.pop(); // This pops the Detail screen.
        // Assuming we came from Agenda list -> Detail.
        // Or if deep link, we might want to go explicit.
        // Requirement: "Retornar para a Agenda"
        // If I pop, I go back to previous screen. If previous was Map, it's weird.
        // But usually flow is Agenda -> Detail.
        // Safety: context.go('/map/calendar');
        context.pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento excluído com sucesso.')),
        );
      }
    }
  }

  Widget _buildAsciiBox({required String title, required Widget content}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
            ),
            child: Text(
              title,
              style: AppTypography.h4.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(padding: const EdgeInsets.all(12), child: content),
        ],
      ),
    );
  }

  Widget _buildInfoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTypography.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_box_outline_blank,
            size: 18,
            color: Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTypography.bodyMedium)),
        ],
      ),
    );
  }
}
