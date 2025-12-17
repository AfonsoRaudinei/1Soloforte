import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

// --- DATA STRUCTURES (Adapted from JS) ---

const Map<String, dynamic> _stages = {
  'VE': {
    'icon': '🌱',
    'name': 'VE - Emergência',
    'description': 'Cotilédones rompem o solo',
    'dap': '0 DAP',
    'attention': [
      'Absorção de água: mínimo 50% do peso',
      'Temperatura ideal: 20-30°C',
    ],
  },
  'VC': {
    'icon': '🌿',
    'name': 'VC - Cotilédones',
    'description': 'Cotilédones totalmente abertos',
    'dap': '3 DAP',
    'attention': [
      'Uso de reservas dos cotilédones',
      'Cuidado com plantas daninhas',
    ],
  },
  'V1': {
    'icon': '🍃',
    'name': 'V1 - 1ª Trifoliolada',
    'description': '1ª folha trifoliolada desenvolvida',
    'dap': '8 DAP',
    'attention': ['Monitorar lagarta e pulgão', 'Fixação de N₂ iniciando'],
  },
  'V2': {
    'icon': '🍃',
    'name': 'V2 - 2ª Trifoliolada',
    'description': '2ª folha trifoliolada',
    'dap': '13 DAP',
    'attention': [
      'Crescimento vegetativo intenso',
      'Aumento demanda nutricional',
    ],
  },
  'V3': {
    'icon': '🍃',
    'name': 'V3 - 3ª Trifoliolada',
    'description': '3ª folha trifoliolada',
    'dap': '18 DAP',
    'attention': [
      'Período crítico competição daninhas',
      'Crescimento radicular ativo',
    ],
  },
  'V4': {
    'icon': '🍃',
    'name': 'V4 - 4ª Trifoliolada',
    'description': '4ª folha trifoliolada',
    'dap': '20-25 DAP',
    'attention': [
      'Máximo crescimento vegetativo',
      'Controle de lagartas e percevejos',
    ],
  },
  'R1': {
    'icon': '🌸',
    'name': 'R1 - Florescimento',
    'description': 'Uma flor aberta',
    'dap': '35-45 DAP',
    'attention': [
      'Início fase reprodutiva',
      'Déficit hídrico crítico',
      'Atenção ao Boro',
    ],
  },
  'R2': {
    'icon': '🌼',
    'name': 'R2 - Floração Plena',
    'description': 'Flor aberta no terço superior',
    'dap': '50-60 DAP',
    'attention': ['Máxima demanda hídrica', 'Monitorar desfolhadoras'],
  },
  'R3': {
    'icon': '🫘',
    'name': 'R3 - Formação Vagens',
    'description': 'Vagem com 1cm',
    'dap': '60-70 DAP',
    'attention': ['Monitoramento de percevejos intensificado'],
  },
  'R5.1': {
    'icon': '🫛',
    'name': 'R5.1 - Início Enchimento',
    'description': 'Grãos 10% de granação',
    'dap': '80-90 DAP',
    'attention': [
      'Máximo desenvolvimento foliar/raízes',
      'Translocação intensa',
    ],
  },
  'R7': {
    'icon': '🌾',
    'name': 'R7 - Início Maturação',
    'description': 'Uma vagem madura',
    'dap': '110-120 DAP',
    'attention': ['Início da senescência', 'Planejar dessecação'],
  },
  'R8': {
    'icon': '🌾',
    'name': 'R8 - Maturação Plena',
    'description': '95% vagens maduras',
    'dap': '115-130 DAP',
    'attention': ['Ponto de colheita', 'Umidade 13-15%'],
  },
};

const Map<String, dynamic> _categories = {
  'doenca': {
    'icon': '🦠',
    'title': 'Doença',
    'color': Color(0xFF34C759),
    'type': 'multi',
    'levels': [
      {'id': 'incidencia', 'name': 'Incidência'},
      {'id': 'severidade', 'name': 'Severidade'},
    ],
  },
  'insetos': {
    'icon': '🐛',
    'title': 'Insetos',
    'color': Color(0xFFFF2D55),
    'type': 'multi',
    'levels': [
      {'id': 'desfolha', 'name': 'Desfolha'},
      {'id': 'infestacao', 'name': 'Infestação'},
      {'id': 'acamamento', 'name': 'Acamamento'},
    ],
  },
  'ervas': {
    'icon': '🌾',
    'title': 'Ervas Daninhas',
    'color': Color(0xFFFF9500),
    'type': 'standard',
  },
  'nutrientes': {
    'icon': 'Ⓝ',
    'title': 'Nutrientes',
    'color': Color(0xFF8E8E93),
    'type': 'nutrients',
  },
  'agua': {
    'icon': '💧',
    'title': 'Água',
    'color': Color(0xFF30B0C7),
    'type': 'severity',
  }, // Custom type logic
};

const List<Map<String, String>> _nutrientsList = [
  {'id': 'N', 'name': 'Nitrogênio', 'symbol': 'N'},
  {'id': 'P', 'name': 'Fósforo', 'symbol': 'P'},
  {'id': 'K', 'name': 'Potássio', 'symbol': 'K'},
  {'id': 'Ca', 'name': 'Cálcio', 'symbol': 'Ca'},
  {'id': 'Mg', 'name': 'Magnésio', 'symbol': 'Mg'},
  {'id': 'S', 'name': 'Enxofre', 'symbol': 'S'},
  {'id': 'B', 'name': 'Boro', 'symbol': 'B'},
  {'id': 'Zn', 'name': 'Zinco', 'symbol': 'Zn'},
];

class ActiveVisitScreen extends StatefulWidget {
  const ActiveVisitScreen({super.key});

  @override
  State<ActiveVisitScreen> createState() => _ActiveVisitScreenState();
}

class _ActiveVisitScreenState extends State<ActiveVisitScreen> {
  // Form Controllers
  final _produtorCtrl = TextEditingController();
  final _propriedadeCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _cultivarCtrl = TextEditingController();
  final _obsCtrl = TextEditingController();
  final _recCtrl = TextEditingController();
  final _tecnicoCtrl = TextEditingController();
  final _locationCtrl = TextEditingController(
    text: "-23.5505, -46.6333",
  ); // Mock Location

  DateTime _visitDate = DateTime.now();
  DateTime? _plantDate;
  int _dap = 0;

  String? _selectedStageKey;

  // Creating a set of selected categories
  final Set<String> _selectedCategories = {};

  // Storing severity/values: categoryId -> { subKey: value }
  final Map<String, Map<String, String>> _problemsData = {};
  // Storing nutrients
  final Set<String> _selectedNutrients = {};

  final List<Map<String, dynamic>> _photos = [];

  @override
  void initState() {
    super.initState();
    _calculateDAP();
  }

  void _calculateDAP() {
    if (_plantDate != null) {
      setState(() {
        _dap = _visitDate.difference(_plantDate!).inDays;
      });
    }
  }

  void _toggleCategory(String key) {
    setState(() {
      if (_selectedCategories.contains(key)) {
        _selectedCategories.remove(key);
        _problemsData.remove(key); // Clear data when deselected
        if (key == 'nutrients') _selectedNutrients.clear();
      } else {
        _selectedCategories.add(key);
      }
    });
  }

  void _setSeverity(String catKey, String subKey, String value) {
    setState(() {
      if (!_problemsData.containsKey(catKey)) {
        _problemsData[catKey] = {};
      }
      _problemsData[catKey]![subKey] = value;
    });
  }

  void _toggleNutrient(String nutrientId) {
    setState(() {
      if (_selectedNutrients.contains(nutrientId)) {
        _selectedNutrients.remove(nutrientId);
      } else {
        _selectedNutrients.add(nutrientId);
      }
    });
  }

  void _addMockPhoto() {
    setState(() {
      _photos.add({
        'id': DateTime.now().toString(),
        'type': 'Geral',
        'category': 'Geral',
        'image': 'assets/images/mock_farm_1.jpg', // Placeholder
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Visita em Andamento'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Logic to finish/save
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Visita Salva! PDF gerado.')),
              );
              context.pop();
            },
            icon: const Icon(Icons.save_alt, size: 18),
            label: const Text('Salvar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoSection(),
            const SizedBox(height: 16),
            _buildPhenologySection(),
            const SizedBox(height: 16),
            _buildCategoriesSection(),
            if (_selectedCategories.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildProblemsSection(),
            ],
            const SizedBox(height: 16),
            _buildPhotosSection(),
            const SizedBox(height: 16),
            _buildTextSection('Observações', _obsCtrl, 'Observações gerais...'),
            const SizedBox(height: 16),
            _buildTextSection(
              'Recomendações',
              _recCtrl,
              'Recomendações técnicas...',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Informações da Visita'),
        _buildCard(
          child: Column(
            children: [
              _buildRowInput('Produtor', _produtorCtrl),
              const Divider(height: 24),
              _buildRowInput('Propriedade', _propriedadeCtrl),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _visitDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (d != null) setState(() => _visitDate = d);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Data', style: TextStyle(fontSize: 16)),
                          Text(
                            DateFormat('dd/MM/yyyy').format(_visitDate),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildRowInput(
                'Área (ha)',
                _areaCtrl,
                keyboardType: TextInputType.number,
              ),
              const Divider(height: 24),
              _buildRowInput('Cultivar', _cultivarCtrl),
              const Divider(height: 24),
              Row(
                children: [
                  const Text('Plantio', style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _plantDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (d != null) {
                        setState(() {
                          _plantDate = d;
                          _calculateDAP();
                        });
                      }
                    },
                    child: Text(
                      _plantDate == null
                          ? 'Selecionar'
                          : DateFormat('dd/MM/yyyy').format(_plantDate!),
                      style: TextStyle(
                        fontSize: 16,
                        color: _plantDate == null ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              if (_dap > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'DAP: $_dap dias',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const Divider(height: 24),
              _buildRowInput('Técnico', _tecnicoCtrl),
              const Divider(height: 24),
              _buildRowInput('Local (GPS)', _locationCtrl, readOnly: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRowInput(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            readOnly: readOnly,
            textAlign: TextAlign.end,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Digite...',
              hintStyle: TextStyle(color: Colors.grey),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhenologySection() {
    final stage = _selectedStageKey != null ? _stages[_selectedStageKey] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Estádio Fenológico'),
        _buildCard(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStageKey,
                hint: const Text('Selecione o estádio'),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: _stages.keys.map((key) {
                  return DropdownMenuItem(
                    value: key,
                    child: Text(_stages[key]['name']),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedStageKey = v),
              ),
              if (stage != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(stage['icon'], style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      Text(
                        stage['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        stage['description'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stage['dap'],
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
                if (stage['attention'] != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PONTOS DE ATENÇÃO',
                              style: TextStyle(
                                color: Colors.amber.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...(stage['attention'] as List).map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '• ',
                                  style: TextStyle(
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      color: Colors.amber.shade900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Categorias'),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            children: _categories.keys.map((key) {
              final cat = _categories[key];
              final isSelected = _selectedCategories.contains(key);

              return GestureDetector(
                onTap: () => _toggleCategory(key),
                child: Container(
                  width: 75,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: isSelected ? cat['color'] : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? cat['color']
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: (cat['color'] as Color).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            cat['icon'],
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat['title'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProblemsSection() {
    return Column(
      children: _selectedCategories.map((catKey) {
        final cat = _categories[catKey];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(cat['icon'], style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Text(
                      cat['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (cat['type'] == 'multi')
                  ...(cat['levels'] as List).map(
                    (level) => _buildSeveritySelector(
                      catKey,
                      level['id'],
                      level['name'],
                    ),
                  ),

                if (cat['type'] == 'standard')
                  _buildSeveritySelector(catKey, 'main', 'Severidade'),

                if (cat['type'] == 'nutrients')
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _nutrientsList.map((nut) {
                      final isSelected = _selectedNutrients.contains(nut['id']);
                      return ChoiceChip(
                        label: Text('${nut['name']} (${nut['symbol']})'),
                        selected: isSelected,
                        onSelected: (_) => _toggleNutrient(nut['id']!),
                        selectedColor: (cat['color'] as Color).withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? (cat['color'] as Color).withAlpha(255)
                              : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        avatar: isSelected
                            ? Icon(Icons.check, size: 16, color: cat['color'])
                            : null,
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeveritySelector(String catKey, String subKey, String label) {
    const options = ['Nenhum', 'Baixa', 'Média', 'Alta'];
    final currentVal = _problemsData[catKey]?[subKey];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: options.map((opt) {
              final isSelected = currentVal == opt;
              Color color = Colors.grey.shade100;
              Color textColor = Colors.black87;

              if (isSelected) {
                if (opt == 'Baixa') {
                  color = Colors.orange;
                  textColor = Colors.white;
                } else if (opt == 'Média') {
                  color = Colors.deepOrange;
                  textColor = Colors.white;
                } else if (opt == 'Alta') {
                  color = Colors.red;
                  textColor = Colors.white;
                } else {
                  color = Colors.green;
                  textColor = Colors.white;
                }
              }

              return Expanded(
                child: GestureDetector(
                  onTap: () => _setSeverity(catKey, subKey, opt),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Fotos'),
        _buildCard(
          child: Column(
            children: [
              InkWell(
                onTap: _addMockPhoto,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Adicionar Foto',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_photos.isNotEmpty) ...[
                const SizedBox(height: 16),
                ..._photos.map(
                  (p) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.white,
                            ), // Mock Image
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p['category'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    p['type'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _photos.remove(p);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextSection(
    String title,
    TextEditingController ctrl,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        _buildCard(
          child: TextField(
            controller: ctrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
