import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';
import 'package:soloforte_app/shared/widgets/custom_text_input.dart';
import 'package:intl/intl.dart';

class VisitReportScreen extends ConsumerStatefulWidget {
  const VisitReportScreen({super.key});

  @override
  ConsumerState<VisitReportScreen> createState() => _VisitReportScreenState();
}

class _VisitReportScreenState extends ConsumerState<VisitReportScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _produtorController = TextEditingController();
  final _propriedadeController = TextEditingController();
  final _areaController = TextEditingController();
  final _cultivarController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _recomendacoesController = TextEditingController();
  final _tecnicoController = TextEditingController();

  // State
  DateTime _date = DateTime.now();
  DateTime? _plantioDate;
  String? _selectedStage;
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedNutrients = {};
  String _occurrenceType = 'sazonal';
  bool _soilSample = false;

  final Map<String, Map<String, dynamic>> _stages = {
    'VE': {
      'icon': '🌱',
      'name': 'VE - Emergência',
      'description': 'Cotilédones rompem o solo',
      'dap': '0 DAP',
    },
    'VC': {
      'icon': '🌿',
      'name': 'VC - Cotilédones',
      'description': 'Cotilédones totalmente abertos',
      'dap': '3 DAP',
    },
    'V1': {
      'icon': '🍃',
      'name': 'V1 - 1ª Trifoliolada',
      'description': 'Primeira folha trifoliolada',
      'dap': '8 DAP',
    },
    'R1': {
      'icon': '🌸',
      'name': 'R1 - Florescimento',
      'description': 'Uma flor aberta',
      'dap': '35-45 DAP',
    },
    'R5.1': {
      'icon': '🫛',
      'name': 'R5.1 - Início Enchimento',
      'description': 'Grãos com 10% de granação',
      'dap': '80-90 DAP',
    },
    'R8': {
      'icon': '🌾',
      'name': 'R8 - Maturação Plena',
      'description': '95% das vagens maduras',
      'dap': '115+ DAP',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Relatório de Visita'),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Gerando PDF...')));
            },
            icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
            label: const Text('PDF', style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSection(
                    title: 'Informações da Visita',
                    children: [
                      CustomTextInput(
                        label: 'Produtor',
                        controller: _produtorController,
                      ),
                      const SizedBox(height: 12),
                      CustomTextInput(
                        label: 'Propriedade',
                        controller: _propriedadeController,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(
                              label: 'Data',
                              value: _date,
                              onChanged: (d) => setState(() => _date = d),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextInput(
                              label: 'Área (ha)',
                              controller: _areaController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextInput(
                        label: 'Cultivar',
                        controller: _cultivarController,
                      ),
                      const SizedBox(height: 12),
                      _buildDatePicker(
                        label: 'Data de Plantio',
                        value: _plantioDate ?? DateTime.now(),
                        onChanged: (d) => setState(() => _plantioDate = d),
                        hint: _plantioDate == null ? 'Selecione' : null,
                      ),
                      if (_plantioDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'DAP: ${DateTime.now().difference(_plantioDate!).inDays} dias',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  _buildSection(
                    title: 'Estádio Fenológico',
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Estádio',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _selectedStage,
                        items: _stages.entries.map((e) {
                          return DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value['name']),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => _selectedStage = v),
                      ),
                      if (_selectedStage != null)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[50]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _stages[_selectedStage]!['icon'],
                                style: const TextStyle(fontSize: 48),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _stages[_selectedStage]!['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _stages[_selectedStage]!['description'],
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _stages[_selectedStage]!['dap'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  _buildSection(
                    title: 'Categoria',
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildCategoryItem(
                            'doenca',
                            'Doença',
                            '🦠',
                            Colors.green,
                          ),
                          _buildCategoryItem(
                            'insetos',
                            'Insetos',
                            '🐛',
                            Colors.red,
                          ),
                          _buildCategoryItem(
                            'ervas',
                            'Ervas',
                            '🌾',
                            Colors.orange,
                          ),
                          _buildCategoryItem(
                            'nutrientes',
                            'Nutrientes',
                            'Ⓝ',
                            Colors.grey,
                          ),
                          _buildCategoryItem('agua', 'Água', '💧', Colors.cyan),
                        ],
                      ),
                    ],
                  ),

                  if (_selectedCategories.contains('nutrientes'))
                    _buildSection(
                      title: 'Nutrientes Deficientes',
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              ['N', 'P', 'K', 'Ca', 'Mg', 'S', 'B', 'Zn', 'Mn']
                                  .map(
                                    (n) => FilterChip(
                                      label: Text(n),
                                      selected: _selectedNutrients.contains(n),
                                      onSelected: (sel) {
                                        setState(() {
                                          if (sel) {
                                            _selectedNutrients.add(n);
                                          } else {
                                            _selectedNutrients.remove(n);
                                          }
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),

                  _buildSection(
                    title: 'Observações e Recomendações',
                    children: [
                      CustomTextInput(
                        label: 'Observações',
                        controller: _observacoesController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      CustomTextInput(
                        label: 'Recomendações',
                        controller: _recomendacoesController,
                        maxLines: 4,
                      ),
                    ],
                  ),

                  _buildSection(
                    title: 'Detalhes Finais',
                    children: [
                      CustomTextInput(
                        label: 'Técnico Responsável',
                        controller: _tecnicoController,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            'Tipo de Ocorrência:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              children: [
                                _buildRadioOption('sazonal', 'Sazonal'),
                                _buildRadioOption('permanente', 'Permanente'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        title: const Text('Coleta de Amostra de Solo'),
                        value: _soilSample,
                        onChanged: (v) =>
                            setState(() => _soilSample = v ?? false),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Salvar Relatório',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Relatório salvo com sucesso!'),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime value,
    required ValueChanged<DateTime> onChanged,
    String? hint,
  }) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2030),
        );
        if (d != null) onChanged(d);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(hint ?? DateFormat('dd/MM/yyyy').format(value)),
      ),
    );
  }

  Widget _buildCategoryItem(String id, String label, String icon, Color color) {
    final isSelected = _selectedCategories.contains(id);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategories.remove(id);
          } else {
            _selectedCategories.add(id);
          }
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
              ],
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value, String label) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _occurrenceType = value),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: _occurrenceType,
                onChanged: (v) => setState(() => _occurrenceType = v!),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
