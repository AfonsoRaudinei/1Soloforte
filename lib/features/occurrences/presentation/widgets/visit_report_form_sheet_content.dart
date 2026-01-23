import 'package:flutter/material.dart';

/// 📝 VISIT REPORT FORM SHEET CONTENT
///
/// Widget isolado para exibição dentro de Bottom Sheet.
/// Não usa Scaffold, AppBar ou navegação.
///
/// Comportamento:
/// - Cálculo automático de DAP (Dias Após Plantio)
/// - Exibição condicional de estádio fenológico
/// - Seleção múltipla de categorias
/// - Renderização dinâmica de problemas com sliders de severidade
class VisitReportFormSheetContent extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const VisitReportFormSheetContent({
    Key? key,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<VisitReportFormSheetContent> createState() =>
      _VisitReportFormSheetContentState();
}

class _VisitReportFormSheetContentState
    extends State<VisitReportFormSheetContent> {
  // Form State
  final TextEditingController _produtorController = TextEditingController();
  final TextEditingController _propriedadeController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cultivarController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();
  final TextEditingController _recomendacoesController =
      TextEditingController();
  final TextEditingController _tecnicoController = TextEditingController();

  DateTime? _dataVisita;
  DateTime? _dataPlantio;
  String? _selectedStage;
  int? _dapValue;

  // Categories
  final Set<String> _selectedCategories = {};
  final Map<String, Map<String, String>> _severityData = {};

  // Data Definitions
  final Map<String, Map<String, dynamic>> _stages = {
    'VE': {
      'name': 'VE - Emergência',
      'description': 'Cotilédones rompem o solo',
      'dap': '0 DAP',
      'attention': [
        'Absorção de água: mínimo 50% do peso da semente',
        'Temperatura ideal do solo: 20-30°C',
      ],
    },
    'VC': {
      'name': 'VC - Cotilédones',
      'description': 'Cotilédones totalmente abertos',
      'dap': '3 DAP',
      'attention': [
        'Planta utiliza reservas dos cotilédones',
        'Controle de plantas daninhas crítico',
      ],
    },
    'V1': {
      'name': 'V1 - 1ª Trifoliolada',
      'description': 'Primeira folha trifoliolada desenvolvida',
      'dap': '8 DAP',
      'attention': [
        'Fotossíntese sustenta o crescimento',
        'Nova folha a cada 5 dias até V5',
      ],
    },
    'V2': {
      'name': 'V2 - 2ª Trifoliolada',
      'description': 'Segunda folha trifoliolada',
      'dap': '16 DAP',
      'attention': [
        'Crescimento vegetativo intenso',
        'Aumento da demanda nutricional',
      ],
    },
    'R1': {
      'name': 'R1 - Florescimento',
      'description': 'Uma flor aberta em qualquer nó',
      'dap': '25 DAP',
      'attention': [
        'Início da fase reprodutiva',
        'Déficit hídrico extremamente crítico',
      ],
    },
    'R2': {
      'name': 'R2 - Floração Plena',
      'description': 'Flor aberta no terço superior',
      'dap': '62 DAP',
      'attention': [
        'Pleno florescimento da cultura',
        'Máxima demanda hídrica (5-7 mm/dia)',
      ],
    },
    'R5.1': {
      'name': 'R5.1 - Início Enchimento',
      'description': 'Grãos com 10% de granação',
      'dap': '95 DAP',
      'attention': [
        'Máximo desenvolvimento de área foliar',
        'Fixação de N₂ no máximo',
      ],
    },
    'R8': {
      'name': 'R8 - Maturação Plena',
      'description': '95% das vagens maduras',
      'dap': '110 DAP',
      'attention': [
        'Maturação completa',
        'Umidade ideal para colheita: 13-15%',
      ],
    },
  };

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'doenca',
      'title': 'Doença',
      'icon': '🦠',
      'color': Color(0xFF34C759),
    },
    {
      'id': 'insetos',
      'title': 'Insetos',
      'icon': '🐛',
      'color': Color(0xFFFF2D55),
    },
    {
      'id': 'ervas',
      'title': 'Ervas daninhas',
      'icon': '🌿',
      'color': Color(0xFFFF9500),
    },
    {
      'id': 'nutrientes',
      'title': 'Nutrientes',
      'icon': '⚗️',
      'color': Color(0xFF8E8E93),
    },
    {'id': 'agua', 'title': 'Água', 'icon': '💧', 'color': Color(0xFF30B0C7)},
  ];

  @override
  void initState() {
    super.initState();
    _dataVisita = DateTime.now();
  }

  @override
  void dispose() {
    _produtorController.dispose();
    _propriedadeController.dispose();
    _areaController.dispose();
    _cultivarController.dispose();
    _observacoesController.dispose();
    _recomendacoesController.dispose();
    _tecnicoController.dispose();
    super.dispose();
  }

  void _calculateDAP() {
    if (_dataPlantio != null && _dataVisita != null) {
      final difference = _dataVisita!.difference(_dataPlantio!).inDays;
      setState(() {
        _dapValue = difference;
      });
    }
  }

  void _toggleCategory(String categoryId) {
    setState(() {
      if (_selectedCategories.contains(categoryId)) {
        _selectedCategories.remove(categoryId);
        _severityData.remove(categoryId);
      } else {
        _selectedCategories.add(categoryId);
        _severityData[categoryId] = {'main': 'nenhum'};
      }
    });
  }

  void _updateSeverity(String categoryId, double value) {
    final severities = ['nenhum', 'baixa', 'média', 'alta'];
    final severity = severities[value.round()];
    setState(() {
      if (!_severityData.containsKey(categoryId)) {
        _severityData[categoryId] = {};
      }
      _severityData[categoryId]!['main'] = severity;
    });
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'baixa':
        return const Color(0xFFFFF3CD);
      case 'média':
        return const Color(0xFFFFE5D0);
      case 'alta':
        return const Color(0xFFFFE0E0);
      default:
        return const Color(0xFFF0F0F0);
    }
  }

  Color _getSeverityTextColor(String severity) {
    switch (severity) {
      case 'baixa':
        return const Color(0xFF856404);
      case 'média':
        return const Color(0xFFCC5500);
      case 'alta':
        return const Color(0xFFD32F2F);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  void _handleSave() {
    widget.onSave({
      'produtor': _produtorController.text,
      'propriedade': _propriedadeController.text,
      'data': _dataVisita?.toIso8601String(),
      'area': _areaController.text,
      'cultivar': _cultivarController.text,
      'plantio': _dataPlantio?.toIso8601String(),
      'dap': _dapValue,
      'estadio': _selectedStage,
      'categorias': _selectedCategories.toList(),
      'severidades': _severityData,
      'observacoes': _observacoesController.text,
      'recomendacoes': _recomendacoesController.text,
      'tecnico': _tecnicoController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Relatório de Visita',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1F),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Documentação técnica da visita ao produtor',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SEÇÃO: Informações da Visita
                  _buildSection(
                    'INFORMAÇÕES DA VISITA',
                    Column(
                      children: [
                        _buildFormRow('Produtor', _produtorController, 'Nome'),
                        _buildFormRow(
                          'Propriedade',
                          _propriedadeController,
                          'Nome',
                        ),
                        _buildDateRow('Data', _dataVisita, (date) {
                          setState(() {
                            _dataVisita = date;
                            _calculateDAP();
                          });
                        }),
                        _buildFormRow(
                          'Área (ha)',
                          _areaController,
                          '0.00',
                          keyboardType: TextInputType.number,
                        ),
                        _buildFormRow(
                          'Cultivar',
                          _cultivarController,
                          'TMG 7062',
                        ),
                        _buildDateRow('Plantio', _dataPlantio, (date) {
                          setState(() {
                            _dataPlantio = date;
                            _calculateDAP();
                          });
                        }),
                        if (_dapValue != null)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'DAP: $_dapValue dias',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF007AFF),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SEÇÃO: Estádio Fenológico
                  _buildSection(
                    'ESTÁDIO FENOLÓGICO',
                    Column(
                      children: [
                        _buildStageSelect(),
                        if (_selectedStage != null) ...[
                          const SizedBox(height: 15),
                          _buildStageDisplay(),
                        ],
                        if (_selectedStage != null &&
                            _stages[_selectedStage]!['attention'] != null) ...[
                          const SizedBox(height: 15),
                          _buildAttentionPoints(),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SEÇÃO: Categorias
                  _buildSection('CATEGORIA', _buildCategoryGrid()),

                  // Problems Container (dinâmico)
                  ..._buildProblemsContainer(),

                  const SizedBox(height: 12),

                  // SEÇÃO: Observações
                  _buildSection(
                    'OBSERVAÇÕES',
                    _buildTextarea(
                      _observacoesController,
                      'Observações gerais sobre a lavoura...',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SEÇÃO: Recomendações
                  _buildSection(
                    'RECOMENDAÇÕES',
                    _buildTextarea(
                      _recomendacoesController,
                      'Recomendações técnicas...',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SEÇÃO: Responsável
                  _buildSection(
                    'RESPONSÁVEL',
                    _buildFormRow(
                      'Técnico',
                      _tecnicoController,
                      'Nome do técnico',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[200]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // HELPER WIDGETS
  // ========================================

  Widget _buildSection(String title, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF86868B),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildFormRow(
    String label,
    TextEditingController controller,
    String placeholder, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF1D1D1F), fontSize: 15),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Color(0xFF1D1D1F), fontSize: 15),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(
    String label,
    DateTime? value,
    Function(DateTime?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF1D1D1F), fontSize: 15),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: value ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  onChanged(date);
                }
              },
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  value != null
                      ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}'
                      : 'Selecione',
                  style: TextStyle(
                    color: value != null
                        ? const Color(0xFF1D1D1F)
                        : Colors.grey[400],
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextarea(TextEditingController controller, String placeholder) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: const TextStyle(color: Color(0xFF1D1D1F), fontSize: 15),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildStageSelect() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 100,
            child: Text(
              'Estádio',
              style: TextStyle(color: Color(0xFF1D1D1F), fontSize: 15),
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStage,
                hint: Text(
                  'Selecione',
                  style: TextStyle(color: Colors.grey[400], fontSize: 15),
                ),
                isExpanded: true,
                alignment: Alignment.centerRight,
                items: _stages.keys.map((key) {
                  return DropdownMenuItem(
                    value: key,
                    child: Text(
                      _stages[key]!['name'],
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStage = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageDisplay() {
    if (_selectedStage == null) return const SizedBox.shrink();
    final stage = _stages[_selectedStage!]!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFE), Color(0xFFF5F5F7)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌱', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            stage['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            stage['description'],
            style: const TextStyle(fontSize: 14, color: Color(0xFF86868B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              stage['dap'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttentionPoints() {
    if (_selectedStage == null) return const SizedBox.shrink();
    final attention = _stages[_selectedStage!]!['attention'] as List;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8E1), Color(0xFFFFF3CD)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFC107).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('⚠️', style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Text(
                'Pontos de Atenção',
                style: TextStyle(
                  color: Color(0xFF856404),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...attention.map((point) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(color: Color(0xFFFFC107), width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                point,
                style: const TextStyle(fontSize: 13, color: Color(0xFF856404)),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = _selectedCategories.contains(category['id']);

        return GestureDetector(
          onTap: () => _toggleCategory(category['id']),
          child: Column(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: isSelected
                      ? category['color']
                      : const Color(0xFFE8E8E8),
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (category['color'] as Color).withOpacity(
                              0.5,
                            ),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    category['icon'],
                    style: TextStyle(
                      fontSize: 32,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? const Color(0xFF1D1D1F)
                      : const Color(0xFF86868B),
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildProblemsContainer() {
    return _selectedCategories.map((categoryId) {
      final category = _categories.firstWhere((c) => c['id'] == categoryId);
      final severity = _severityData[categoryId]?['main'] ?? 'nenhum';
      final severityValue = [
        'nenhum',
        'baixa',
        'média',
        'alta',
      ].indexOf(severity).toDouble();

      return Container(
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          category['color'] as Color,
                          (category['color'] as Color).withOpacity(0.8),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        category['icon'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category['title'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1D1F),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Severidade',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getSeverityColor(severity),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          severity.substring(0, 1).toUpperCase() +
                              severity.substring(1),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _getSeverityTextColor(severity),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                      activeTrackColor: Colors.transparent,
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: Colors.white,
                      overlayColor: const Color(0xFF007AFF).withOpacity(0.1),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFF0F0F0),
                                Color(0xFFFFF3CD),
                                Color(0xFFFFE5D0),
                                Color(0xFFFFE0E0),
                              ],
                            ),
                          ),
                        ),
                        Slider(
                          value: severityValue,
                          min: 0,
                          max: 3,
                          divisions: 3,
                          onChanged: (value) {
                            _updateSeverity(categoryId, value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
