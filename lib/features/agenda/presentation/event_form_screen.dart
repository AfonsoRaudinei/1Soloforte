import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/features/agenda/presentation/extensions/event_type_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
import 'package:soloforte_app/features/agenda/presentation/agenda_controller.dart';
import 'package:uuid/uuid.dart';

class EventFormScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final Event? event;

  const EventFormScreen({super.key, this.initialDate, this.event});

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late DateTime _startDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  EventType _selectedType = EventType.technicalVisit;
  String? _selectedProducer;
  String? _selectedArea;
  String? _reminderOption = '1 hora antes';

  bool _activateReminder = false;
  bool _googleCalendar = false;
  bool _isRecurrent = false;

  bool _isLoading = false;

  final List<String> _producersMock = [
    'João Silva',
    'Maria Santos',
    'Pedro Oliveira',
  ];
  final List<String> _areasMock = ['Talhão Norte', 'Lavoura Sul', 'Área Nova'];
  final List<String> _reminderOptions = [
    '15 min antes',
    '30 min antes',
    '1 hora antes',
    '1 dia antes',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.event != null) {
      final e = widget.event!;
      _startDate = e.startTime;
      _startTime = TimeOfDay.fromDateTime(e.startTime);
      _endTime = TimeOfDay.fromDateTime(e.endTime);
      _titleController.text = e.title;
      _descriptionController.text = e.description;
      _selectedType = e.type;

      // Try to match location to area list, if not found, it waits as null or we could add it
      if (!_areasMock.contains(e.location)) {
        _areasMock.add(e.location);
      }
      _selectedArea = e.location;

      // Infer producer from title if possible or leave blank as we don't have producer field in Event yet
      // For now leave _selectedProducer null or default
    } else {
      final baseDate = widget.initialDate ?? DateTime.now();
      _startDate = baseDate;
      _startTime = TimeOfDay(hour: DateTime.now().hour + 1, minute: 0);
      _endTime = TimeOfDay(hour: DateTime.now().hour + 3, minute: 0);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final initialTime = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final startDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horário final deve ser após o inicial.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      if (widget.event != null) {
        // Edit existing event
        final updatedEvent = widget.event!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          startTime: startDateTime,
          endTime: endDateTime,
          type: _selectedType,
          location: _selectedArea ?? 'Não definido',
          updatedAt: DateTime.now(),
        );

        await ref
            .read(agendaControllerProvider.notifier)
            .updateEvent(updatedEvent);

        if (mounted) {
          context
              .pop(); // Returns to previous screen (Agenda or Weekly Planning)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Atividade atualizada com sucesso!')),
          );
        }
      } else {
        // Create new event
        final newEvent = Event(
          id: const Uuid().v4(),
          title: _titleController.text,
          description: _descriptionController.text,
          startTime: startDateTime,
          endTime: endDateTime,
          type: _selectedType,
          location: _selectedArea ?? 'Não definido',
          status: EventStatus.scheduled,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await ref.read(agendaControllerProvider.notifier).addEvent(newEvent);
        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Atividade salva com sucesso!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ┌─────────────────────────────────┐
    // │  [×]  Nova Atividade  [✓ Salvar]│
    // ├─────────────────────────────────┤

    final durationHours =
        (_endTime.hour - _startTime.hour) +
        (_endTime.minute - _startTime.minute) / 60;

    final isEditing = widget.event != null;
    final isInProgress = widget.event?.status == EventStatus.inProgress;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ), // [×]
        title: Text(isEditing ? 'Editar Atividade' : 'Nova Atividade'),
        actions: [
          TextButton.icon(
            // [✓ Salvar]
            onPressed: _isLoading ? null : _saveEvent,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Salvar'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tipo de Atividade *
            _buildLabel('Tipo de Atividade *'),
            IgnorePointer(
              ignoring: isInProgress,
              child: Opacity(
                opacity: isInProgress ? 0.5 : 1.0,
                child: DropdownButtonFormField<EventType>(
                  initialValue: _selectedType,
                  items: EventType.values
                      .map(
                        (t) => DropdownMenuItem(value: t, child: Text(t.label)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedType = v!),
                  decoration: _inputDecoration(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Título *
            _buildLabel('Título *'),
            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration(hint: 'Visita técnica lavoura'),
              validator: (v) => v?.isEmpty == true ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),

            // Produtor/Cliente *
            _buildLabel('Produtor/Cliente *'),
            IgnorePointer(
              ignoring: isInProgress,
              child: Opacity(
                opacity: isInProgress ? 0.5 : 1.0,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedProducer,
                  hint: const Text('Selecione...'),
                  items: _producersMock
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedProducer = v),
                  decoration: _inputDecoration(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Área/Talhão
            _buildLabel('Área/Talhão'),
            IgnorePointer(
              ignoring: isInProgress,
              child: Opacity(
                opacity: isInProgress ? 0.5 : 1.0,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedArea,
                  hint: const Text('Selecione...'),
                  items: _areasMock
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedArea = v),
                  decoration: _inputDecoration(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data *
            _buildLabel('Data *'),
            IgnorePointer(
              ignoring: isInProgress,
              child: Opacity(
                opacity: isInProgress ? 0.5 : 1.0,
                child: InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: _inputDecoration(
                      suffixIcon: Icons.calendar_today,
                    ),
                    child: Text(
                      DateFormat('dd/MMM/yyyy', 'pt_BR').format(_startDate),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Horário * (Start) às (End)
            _buildLabel('Horário *'),
            IgnorePointer(
              ignoring: isInProgress,
              child: Opacity(
                opacity: isInProgress ? 0.5 : 1.0,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(true),
                        child: InputDecorator(
                          decoration: _inputDecoration(
                            suffixIcon: Icons.arrow_drop_down,
                          ),
                          child: Text(_startTime.format(context)),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('às'),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(false),
                        child: InputDecorator(
                          decoration: _inputDecoration(
                            suffixIcon: Icons.arrow_drop_down,
                          ),
                          child: Text(_endTime.format(context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Duração: ${durationHours.toStringAsFixed(1)} horas',
                style: AppTypography.caption,
              ),
            ),
            const SizedBox(height: 16),

            // Descrição/Objetivo
            _buildLabel('Descrição/Objetivo'),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: _inputDecoration(hint: 'Avaliar infestação...'),
            ),
            const SizedBox(height: 24),

            // ☑️ Ativar lembrete
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ativar lembrete'),
              value: _activateReminder,
              onChanged: (v) => setState(() => _activateReminder = v!),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (_activateReminder)
              Padding(
                padding: const EdgeInsets.only(left: 12.0), // Indent slightly
                child: DropdownButtonFormField<String>(
                  initialValue: _reminderOption,
                  items: _reminderOptions
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _reminderOption = v),
                  decoration: _inputDecoration(),
                ),
              ),

            // ☑️ Adicionar ao Google Calendar
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Adicionar ao Google Calendar'),
              value: _googleCalendar,
              onChanged: (v) => setState(() => _googleCalendar = v!),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            // ☐ Evento recorrente
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Evento recorrente'),
              value: _isRecurrent,
              onChanged: (v) => setState(() => _isRecurrent = v!),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 32),

            // [Cancelar] [Salvar]
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint, IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
    );
  }
}
