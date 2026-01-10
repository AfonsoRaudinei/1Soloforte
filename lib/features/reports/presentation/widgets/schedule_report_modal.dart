import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/reports/domain/report_history.dart';
import 'package:soloforte_app/features/reports/domain/report_configuration.dart';
import 'package:soloforte_app/features/reports/application/report_history_provider.dart';
import 'package:soloforte_app/shared/widgets/app_card.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';

/// Modal para criar/editar agendamento de relatório
class ScheduleReportModal extends ConsumerStatefulWidget {
  final ReportSchedule? existingSchedule;
  final ReportConfiguration? configuration;

  const ScheduleReportModal({
    super.key,
    this.existingSchedule,
    this.configuration,
  });

  @override
  ConsumerState<ScheduleReportModal> createState() =>
      _ScheduleReportModalState();
}

class _ScheduleReportModalState extends ConsumerState<ScheduleReportModal> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  late TextEditingController _emailsController;

  ScheduleFrequency _selectedFrequency = ScheduleFrequency.weekly;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  int _selectedDayOfWeek = 5; // Sexta-feira
  int _selectedDayOfMonth = 1;
  bool _isActive = true;
  ReportTemplate _selectedTemplate = ReportTemplate.weekly;

  @override
  void initState() {
    super.initState();

    if (widget.existingSchedule != null) {
      final schedule = widget.existingSchedule!;
      _titleController = TextEditingController(text: schedule.title);
      _notesController = TextEditingController(text: schedule.notes ?? '');
      _emailsController = TextEditingController(
        text: schedule.emailRecipients?.join(', ') ?? '',
      );
      _selectedFrequency = schedule.frequency;
      _isActive = schedule.isActive;
      _selectedTemplate = schedule.template;

      // Extrair hora do nextRunAt
      _selectedTime = TimeOfDay(
        hour: schedule.nextRunAt.hour,
        minute: schedule.nextRunAt.minute,
      );
    } else {
      _titleController = TextEditingController();
      _notesController = TextEditingController();
      _emailsController = TextEditingController();

      if (widget.configuration != null) {
        _selectedTemplate =
            widget.configuration!.template ?? ReportTemplate.weekly;
        _titleController.text =
            'Relatório ${_selectedTemplate.name} - Agendado';
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _emailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 24),
                  _buildTemplateSection(),
                  const SizedBox(height: 24),
                  _buildFrequencySection(),
                  const SizedBox(height: 24),
                  _buildTimeSection(),
                  const SizedBox(height: 24),
                  _buildEmailSection(),
                  const SizedBox(height: 24),
                  _buildNotesSection(),
                  const SizedBox(height: 24),
                  _buildActiveSwitch(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.schedule, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existingSchedule != null
                      ? 'Editar Agendamento'
                      : 'Novo Agendamento',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: 4),
                Text(
                  'Configure a geração automática de relatórios',
                  style: AppTypography.caption.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Título', style: AppTypography.h3),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Ex: Relatório Semanal - Fazenda São João',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tipo de Relatório', style: AppTypography.h3),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ReportTemplate.values.map((template) {
            final isSelected = _selectedTemplate == template;
            return GestureDetector(
              onTap: () => setState(() => _selectedTemplate = template),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? template.color.withValues(alpha: 0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? template.color : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      template.icon,
                      size: 20,
                      color: isSelected ? template.color : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      template.name,
                      style: TextStyle(
                        color: isSelected ? template.color : Colors.grey[700],
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequência', style: AppTypography.h3),
        const SizedBox(height: 12),
        ...ScheduleFrequency.values.map((frequency) {
          return RadioListTile<ScheduleFrequency>(
            value: frequency,
            groupValue: _selectedFrequency,
            onChanged: (value) {
              setState(() => _selectedFrequency = value!);
            },
            title: Row(
              children: [
                Icon(frequency.icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(frequency.name),
              ],
            ),
            subtitle: Text(_getFrequencyDescription(frequency)),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          );
        }),

        // Opções específicas por frequência
        if (_selectedFrequency == ScheduleFrequency.weekly)
          _buildWeeklyOptions(),
        if (_selectedFrequency == ScheduleFrequency.monthly)
          _buildMonthlyOptions(),
      ],
    );
  }

  Widget _buildWeeklyOptions() {
    final weekDays = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dia da semana:', style: AppTypography.bodySmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(7, (index) {
              final isSelected = _selectedDayOfWeek == index + 1;
              return ChoiceChip(
                label: Text(weekDays[index]),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedDayOfWeek = index + 1);
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.grey[700],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOptions() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dia do mês:', style: AppTypography.bodySmall),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: _selectedDayOfMonth,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            items: List.generate(28, (index) {
              return DropdownMenuItem(
                value: index + 1,
                child: Text('Dia ${index + 1}'),
              );
            }),
            onChanged: (value) {
              setState(() => _selectedDayOfMonth = value!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Horário', style: AppTypography.h3),
        const SizedBox(height: 12),
        InkWell(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  _selectedTime.format(context),
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Destinatários (Email)', style: AppTypography.h3),
        const SizedBox(height: 8),
        TextField(
          controller: _emailsController,
          decoration: InputDecoration(
            hintText: 'email1@exemplo.com, email2@exemplo.com',
            helperText: 'Separe múltiplos emails com vírgula',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
            prefixIcon: const Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Observações', style: AppTypography.h3),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: 'Notas adicionais sobre este agendamento...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildActiveSwitch() {
    return AppCard(
      child: SwitchListTile(
        value: _isActive,
        onChanged: (value) => setState(() => _isActive = value),
        title: Text('Agendamento Ativo', style: AppTypography.bodySmall),
        subtitle: Text(
          _isActive
              ? 'O relatório será gerado automaticamente'
              : 'Agendamento pausado',
          style: AppTypography.caption,
        ),
        activeThumbColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: PrimaryButton(
              text: widget.existingSchedule != null
                  ? 'Salvar'
                  : 'Criar Agendamento',
              onPressed: _saveSchedule,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveSchedule() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um título')),
      );
      return;
    }

    final now = DateTime.now();
    final nextRun = _calculateNextRun(now);

    final emails = _emailsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final schedule = ReportSchedule(
      id:
          widget.existingSchedule?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      template: _selectedTemplate,
      configuration: widget.configuration ?? ReportConfiguration(),
      frequency: _selectedFrequency,
      nextRunAt: nextRun,
      lastRunAt: widget.existingSchedule?.lastRunAt,
      isActive: _isActive,
      emailRecipients: emails.isEmpty ? null : emails,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    if (widget.existingSchedule != null) {
      // Atualizar existente (implementar no provider)
      ref
          .read(reportHistoryProvider)
          .deleteSchedule(widget.existingSchedule!.id);
    }

    ref.read(reportHistoryProvider).addSchedule(schedule);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.existingSchedule != null
              ? 'Agendamento atualizado!'
              : 'Agendamento criado com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  DateTime _calculateNextRun(DateTime from) {
    final now = DateTime(
      from.year,
      from.month,
      from.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    switch (_selectedFrequency) {
      case ScheduleFrequency.daily:
        return now.isAfter(from) ? now : now.add(const Duration(days: 1));

      case ScheduleFrequency.weekly:
        var next = now;
        while (next.weekday != _selectedDayOfWeek || !next.isAfter(from)) {
          next = next.add(const Duration(days: 1));
        }
        return next;

      case ScheduleFrequency.monthly:
        var next = DateTime(
          now.year,
          now.month,
          _selectedDayOfMonth,
          _selectedTime.hour,
          _selectedTime.minute,
        );
        if (!next.isAfter(from)) {
          next = DateTime(
            now.year,
            now.month + 1,
            _selectedDayOfMonth,
            _selectedTime.hour,
            _selectedTime.minute,
          );
        }
        return next;

      case ScheduleFrequency.custom:
        return now.add(const Duration(days: 1));
    }
  }

  String _getFrequencyDescription(ScheduleFrequency frequency) {
    switch (frequency) {
      case ScheduleFrequency.daily:
        return 'Todos os dias no horário especificado';
      case ScheduleFrequency.weekly:
        return 'Uma vez por semana';
      case ScheduleFrequency.monthly:
        return 'Uma vez por mês';
      case ScheduleFrequency.custom:
        return 'Configuração personalizada';
    }
  }
}
