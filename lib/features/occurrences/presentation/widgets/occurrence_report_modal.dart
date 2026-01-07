import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';

class OccurrenceReportModal extends StatefulWidget {
  const OccurrenceReportModal({super.key});

  @override
  State<OccurrenceReportModal> createState() => _OccurrenceReportModalState();
}

class _OccurrenceReportModalState extends State<OccurrenceReportModal> {
  // Form Controllers
  final _produtorController = TextEditingController();
  final _propriedadeController = TextEditingController();
  final _areaController = TextEditingController();
  final _cultivarController = TextEditingController();
  final _tecnicoController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _recomendacoesController = TextEditingController();
  final _coordinatesController = TextEditingController();

  // State Variables
  DateTime _selectedDate = DateTime.now();
  DateTime? _plantingDate;
  int _dap = 0;
  String? _selectedStage;

  final Set<String> _selectedCategories = {};
  final Set<String> _selectedNutrients = {};
  final Map<String, dynamic> _severityData = {}; // Stores slider values
  final Map<String, String> _categoryNotes = {};

  String _occurrenceType = 'sazonal'; // sazonal | permanente
  bool _soilSample = false;

  // Mock Data for Stages (Converted from JS object)
  final Map<String, Map<String, dynamic>> _stages = {
    'VE': {
      'name': 'VE - Emergência',
      'desc': 'Cotilédones rompem o solo',
      'dap': '0 DAP',
      'icon': Icons.grass,
    },
    'VC': {
      'name': 'VC - Cotilédones',
      'desc': 'Cotilédones totalmente abertos',
      'dap': '3 DAP',
      'icon': Icons.spa,
    },
    'V1': {
      'name': 'V1 - 1ª Trifoliolada',
      'desc': 'Primeira folha trifoliolada',
      'dap': '8 DAP',
      'icon': Icons.eco,
    },
    'V2': {
      'name': 'V2 - 2ª Trifoliolada',
      'desc': 'Segunda folha trifoliolada',
      'dap': '16 DAP',
      'icon': Icons.eco,
    },
    'R1': {
      'name': 'R1 - Florescimento',
      'desc': 'Uma flor aberta',
      'dap': '25 DAP',
      'icon': Icons.local_florist,
    },
    'R5.1': {
      'name': 'R5.1 - Início Ench.',
      'desc': 'Grãos com 10% de granação',
      'dap': '95 DAP',
      'icon': Icons.grain,
    },
    'R8': {
      'name': 'R8 - Maturação',
      'desc': '95% das vagens maduras',
      'dap': '110 DAP',
      'icon': Icons.agriculture,
    },
    // Add others as needed...
  };

  final Map<String, Map<String, dynamic>> _categories = {
    'doenca': {
      'title': 'Doença',
      'color': Color(0xFF34C759),
      'icon': Icons.coronavirus,
      'type': 'multi',
      'levels': ['Incidência', 'Severidade'],
    },
    'insetos': {
      'title': 'Insetos',
      'color': Color(0xFFFF2D55),
      'icon': Icons.pest_control,
      'type': 'multi',
      'levels': ['Desfolha', 'Infestação', 'Acamamento'],
    },
    'ervas': {
      'title': 'Ervas Daninhas',
      'color': Color(0xFFFF9500),
      'icon': Icons.grass,
      'type': 'standard',
    },
    'nutrientes': {
      'title': 'Nutrientes',
      'color': Color(0xFF8E8E93),
      'icon': Icons.science,
      'type': 'nutrients',
    },
    'agua': {
      'title': 'Água',
      'color': Color(0xFF30B0C7),
      'icon': Icons.water_drop,
      'type': 'water',
    },
  };

  void _calculateDAP() {
    if (_plantingDate != null) {
      setState(() {
        _dap = _selectedDate.difference(_plantingDate!).inDays;
      });
    }
  }

  void _toggleCategory(String key) {
    setState(() {
      HapticFeedback.lightImpact();
      if (_selectedCategories.contains(key)) {
        _selectedCategories.remove(key);
      } else {
        _selectedCategories.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7), // Apple-like gray background
        appBar: AppBar(
          backgroundColor: const Color(0xFF1C1C1E),
          foregroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Relatório de Visita Agrícola',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                // TODO: Implement PDF Export
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exportando PDF... (Simulado)')),
                );
              },
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.blueAccent,
                size: 20,
              ),
              label: const Text(
                'PDF',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.print, color: Colors.blueAccent),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              _buildSection(
                title: 'Informações da Visita',
                child: _buildVisitInfoForm(),
              ),
              _buildSection(
                title: 'Estádio Fenológico',
                child: _buildPhenologyForm(),
              ),
              _buildSection(title: 'Categoria', child: _buildCategoriesGrid()),
              if (_selectedCategories.isNotEmpty)
                _buildDynamicProblemSections(),
              _buildSection(
                title: 'Observações - Geral',
                child: _buildTextArea(_observacoesController),
              ),
              _buildSection(
                title: 'Recomendações Técnicas',
                child: _buildTextArea(_recomendacoesController),
              ),
              _buildSection(
                title: 'Localização & Responsável',
                child: _buildLocationForm(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Relatório salvo com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          label: const Text('Salvar Relatório'),
          icon: const Icon(Icons.save),
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF86868B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }

  // --- Forms & Inputs ---

  Widget _buildVisitInfoForm() {
    return Column(
      children: [
        _buildTextInput('Produtor', _produtorController, 'Nome do produtor'),
        _buildDivider(),
        _buildTextInput(
          'Propriedade',
          _propriedadeController,
          'Nome da fazenda',
        ),
        _buildDivider(),
        _buildDateInput('Data da Visita', _selectedDate, (d) {
          setState(() {
            _selectedDate = d;
            _calculateDAP();
          });
        }),
        _buildDivider(),
        _buildTextInput(
          'Área (ha)',
          _areaController,
          '0.00',
          keyboardType: TextInputType.number,
        ),
        _buildDivider(),
        _buildTextInput('Cultivar', _cultivarController, 'Ex: TMG 7062'),
        _buildDivider(),
        _buildDateInput('Data Plantio', _plantingDate, (d) {
          setState(() {
            _plantingDate = d;
            _calculateDAP();
          });
        }, placeholder: 'Selecionar'),
        if (_plantingDate != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "DAP Calculado: ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$_dap dias",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhenologyForm() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: InputBorder.none),
          initialValue: _selectedStage,
          hint: const Text('Selecione o estádio'),
          items: _stages.entries.map((e) {
            return DropdownMenuItem(value: e.key, child: Text(e.value['name']));
          }).toList(),
          onChanged: (v) => setState(() => _selectedStage = v),
        ),
        if (_selectedStage != null) ...[
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade50, Colors.white],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                Icon(
                  _stages[_selectedStage]!['icon'],
                  size: 60,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 10),
                Text(
                  _stages[_selectedStage]!['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _stages[_selectedStage]!['desc'],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _stages[_selectedStage]!['dap'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoriesGrid() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      alignment: WrapAlignment.center,
      children: _categories.entries.map((e) {
        final isSelected = _selectedCategories.contains(e.key);
        return GestureDetector(
          onTap: () => _toggleCategory(e.key),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: isSelected ? e.value['color'] : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (e.value['color'] as Color).withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  e.value['icon'],
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                e.value['title'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDynamicProblemSections() {
    return Column(
      children: _selectedCategories.map((catKey) {
        final cat = _categories[catKey]!;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: cat['color'],
                      radius: 16,
                      child: Icon(cat['icon'], size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      cat['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                    if (cat['type'] == 'multi')
                      ...(cat['levels'] as List<String>)
                          .map((level) => _buildSeveritySlider(catKey, level))
                          ,
                    if (cat['type'] == 'standard')
                      _buildSeveritySlider(catKey, 'Severidade'),
                    if (cat['type'] == 'water') _buildWaterSlider(catKey),
                    if (cat['type'] == 'nutrients') _buildNutrientsGrid(),

                    const SizedBox(height: 15),
                    _buildTextArea(
                      TextEditingController(text: _categoryNotes[catKey] ?? ''),
                      hint: 'Anotações sobre ${cat['title'].toLowerCase()}...',
                      onChanged: (text) => _categoryNotes[catKey] = text,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- Sliders & Custom Inputs ---

  Widget _buildSeveritySlider(String catKey, String label) {
    String key = '${catKey}_$label';
    double value = _severityData[key] ?? 0.0;

    // Labels mapping
    String getLabel(double v) {
      if (v == 0) return 'Nenhum';
      if (v == 1) return 'Baixa';
      if (v == 2) return 'Média';
      if (v == 3) return 'Alta';
      return '';
    }

    Color getColor(double v) {
      if (v == 0) return Colors.grey;
      if (v == 1) return Colors.green;
      if (v == 2) return Colors.orange;
      return Colors.red;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: getColor(value).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                getLabel(value),
                style: TextStyle(
                  color: getColor(value),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 3,
          divisions: 3,
          activeColor: getColor(value),
          label: getLabel(value),
          onChanged: (v) => setState(() => _severityData[key] = v),
        ),
      ],
    );
  }

  Widget _buildWaterSlider(String catKey) {
    double value =
        _severityData[catKey] ?? 0.0; // 0=Adequado, 1=Seco, 2=Excesso
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Status Hídrico',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              value == 0 ? 'Adequado' : (value == 1 ? 'Seco' : 'Excesso'),
              style: TextStyle(
                color: value == 0 ? Colors.green : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 2,
          divisions: 2,
          onChanged: (v) => setState(() => _severityData[catKey] = v),
        ),
      ],
    );
  }

  Widget _buildNutrientsGrid() {
    final nutrients = [
      'N',
      'P',
      'K',
      'Ca',
      'Mg',
      'S',
      'B',
      'Zn',
      'Fe',
      'Mn',
      'Cu',
      'Mo',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: nutrients.map((n) {
        final isSelected = _selectedNutrients.contains(n);
        return GestureDetector(
          onTap: () => setState(() {
            isSelected
                ? _selectedNutrients.remove(n)
                : _selectedNutrients.add(n);
          }),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              n,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextInput(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.end,
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput(
    String label,
    DateTime? date,
    Function(DateTime) onSelect, {
    String placeholder = '',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (d != null) onSelect(d);
              },
              child: Text(
                date != null
                    ? DateFormat('dd/MM/yyyy').format(date)
                    : placeholder,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 16,
                  color: date != null ? Colors.black : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea(
    TextEditingController controller, {
    String hint = 'Digite aqui...',
    Function(String)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        maxLines: 3,
        onChanged: onChanged,
        decoration: InputDecoration.collapsed(hintText: hint),
      ),
    );
  }

  Widget _buildLocationForm() {
    return Column(
      children: [
        _buildTextInput('Técnico', _tecnicoController, 'Nome do responsável'),
        _buildDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const SizedBox(
                width: 100,
                child: Text("Coordenadas", style: TextStyle(fontSize: 16)),
              ),
              Expanded(
                child: TextField(
                  controller: _coordinatesController,
                  textAlign: TextAlign.end,
                  readOnly: true,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Toque para capturar',
                    hintStyle: TextStyle(
                      color: Colors.blue.withValues(alpha: 0.8),
                    ),
                  ),
                  onTap: () {
                    // Simulating Geo Location
                    setState(() {
                      _coordinatesController.text = "-12.9837, -38.4922";
                    });
                    HapticFeedback.heavyImpact();
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.location_on, color: Colors.blue, size: 18),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Sazonal', style: TextStyle(fontSize: 14)),
                value: 'sazonal',
                groupValue: _occurrenceType,
                onChanged: (v) => setState(() => _occurrenceType = v!),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Permanente', style: TextStyle(fontSize: 14)),
                value: 'permanente',
                groupValue: _occurrenceType,
                onChanged: (v) => setState(() => _occurrenceType = v!),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        CheckboxListTile(
          title: const Text('Amostra de Solo Coletada'),
          value: _soilSample,
          onChanged: (v) => setState(() => _soilSample = v!),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.grey.shade200);
}
