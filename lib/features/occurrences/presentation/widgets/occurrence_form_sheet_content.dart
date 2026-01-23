import 'package:flutter/material.dart';

class OccurrenceFormSheetContent extends StatefulWidget {
  final Map<String, double> currentLocation;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const OccurrenceFormSheetContent({
    Key? key,
    this.currentLocation = const {'lat': -23.5505, 'lng': -46.6333},
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<OccurrenceFormSheetContent> createState() =>
      _OccurrenceFormSheetContentState();
}

class _OccurrenceFormSheetContentState
    extends State<OccurrenceFormSheetContent> {
  // State
  String _selectedType = 'outros';
  String _selectedSeverity = 'media';
  double _severityPercent = 50.0;
  String _notes = '';
  List<String> _photos = []; // In a real app, this might be File paths or URLs
  bool _isSaving = false;

  // Data Definitions
  final List<Map<String, dynamic>> _types = [
    {
      'value': 'planta-daninha',
      'label': 'Planta Daninha',
      'icon': Icons.grass, // Sprout equivalent
      'color': Color(0xFF10B981), // Green
      'bgColor': Color(0xFFECFDF5),
    },
    {
      'value': 'doencas',
      'label': 'Doenças',
      'icon': Icons.warning_amber_rounded, // ShieldAlert equivalent
      'color': Color(0xFFEF4444), // Red
      'bgColor': Color(0xFFFEF2F2),
    },
    {
      'value': 'inseto',
      'label': 'Inseto/Praga',
      'icon': Icons.pest_control, // Bug equivalent
      'color': Color(0xFFF59E0B), // Orange
      'bgColor': Color(0xFFFFFBEB),
    },
    {
      'value': 'nutricional',
      'label': 'Nutricional',
      'icon': Icons.water_drop, // Droplets equivalent
      'color': Color(0xFF84CC16), // Lime
      'bgColor': Color(0xFFF7FEE7),
    },
    {
      'value': 'outros',
      'label': 'Outros',
      'icon': Icons.assignment, // ClipboardList equivalent
      'color': Color(0xFF0057FF), // Blue
      'bgColor': Color(0xFFEFF6FF),
    },
  ];

  final List<Map<String, dynamic>> _severities = [
    {
      'value': 'baixa',
      'label': 'Baixa',
      'color': Color(0xFF10B981),
      'basePercent': 25.0,
    },
    {
      'value': 'media',
      'label': 'Média',
      'color': Color(0xFFF59E0B),
      'basePercent': 50.0,
    },
    {
      'value': 'alta',
      'label': 'Alta',
      'color': Color(0xFFEF4444),
      'basePercent': 75.0,
    },
  ];

  // Helper to get current type color
  Color get _currentColor {
    final type = _types.firstWhere(
      (t) => t['value'] == _selectedType,
      orElse: () => _types.last,
    );
    return type['color'] as Color;
  }

  // Helper to get current severity color
  Color get _severityColor {
    if (_severityPercent < 33) return Color(0xFF10B981);
    if (_severityPercent < 66) return Color(0xFFF59E0B);
    return Color(0xFFEF4444);
  }

  void _handleSave() {
    setState(() => _isSaving = true);

    // Simulate delay or preparation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final data = {
          'tipo': _selectedType,
          'severidade': _selectedSeverity,
          'intensidade': _severityPercent,
          'notas': _notes,
          'fotos': _photos,
          'localizacao': widget.currentLocation,
          'data': DateTime.now().toIso8601String(),
        };
        widget.onSave(data);
        setState(() => _isSaving = false);
      }
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle (Optional for BottomSheet feel)
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
                  'Nova Ocorrência',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827), // Gray 900
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Registre uma ocorrência identificada no campo',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- TYPE SECTION ---
                  _buildSectionTitle('Tipo', isRequired: true),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: _types
                        .map((type) => _buildTypeButton(type))
                        .toList(),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                  ),

                  // --- SEVERITY SECTION ---
                  _buildSectionTitle('Severidade', isRequired: true),
                  const SizedBox(height: 12),
                  Row(
                    children: _severities
                        .map(
                          (sev) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: _buildSeverityButton(sev),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Intensity Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Intensidade',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_severityPercent.round()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _severityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 24,
                    child: Stack(
                      children: [
                        // Gradient Track
                        Center(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF10B981), // Green
                                  Color(0xFFF59E0B), // Orange
                                  Color(0xFFEF4444), // Red
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Slider
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 20,
                            ),
                            activeTrackColor: Colors.transparent,
                            inactiveTrackColor: Colors.transparent,
                            thumbColor: Colors.white,
                            overlayColor: _severityColor.withOpacity(0.1),
                          ),
                          child: Slider(
                            value: _severityPercent,
                            min: 0,
                            max: 100,
                            onChanged: (val) {
                              setState(() {
                                _severityPercent = val;
                                // Auto-update severity category based on slider?
                                // User prompt implies connected logic but let's keep visual strict to React
                                // React code updates slider from buttons, but slider updates percentage only
                              });
                            },
                          ),
                        ),
                        // Custom Thumb Border (Visual trick: using a Container on top or rely on Theme)
                        // Flutter's Slider thumb doesn't hold a border easily without CustomShape.
                        // We will trust standard clean white thumb for now.
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                  ),

                  // --- PHOTOS SECTION ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Fotos'),
                      if (_photos.isNotEmpty)
                        Text(
                          '${_photos.length} de 9 fotos',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_photos.isEmpty)
                    _buildEmptyPhotoState()
                  else
                    _buildPhotoGrid(),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                  ),

                  // --- NOTES SECTION ---
                  _buildSectionTitle('Observações'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextField(
                      maxLines: 3,
                      onChanged: (val) => _notes = val,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Descreva os detalhes da ocorrência...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        contentPadding: const EdgeInsets.all(12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- LOCATION CARD ---
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Localização GPS',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.currentLocation['lat']!.toStringAsFixed(4)}, ${widget.currentLocation['lng']!.toStringAsFixed(4)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily:
                                    'RobotoMono', // Assuming standard monospace safely
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- FOOTER ---
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
                    onPressed: _isSaving ? null : widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[200]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.grey[700],
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: _currentColor.withOpacity(0.6),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.check, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Salvar',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
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

  Widget _buildSectionTitle(String title, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
        if (isRequired) const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _buildTypeButton(Map<String, dynamic> type) {
    final isSelected = _selectedType == type['value'];
    final color = type['color'] as Color;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type['value']),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
              border: isSelected
                  ? Border.all(
                      color: color,
                      width: 2,
                    ) // External ring effect simulated
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Icon(
                    type['icon'],
                    color: isSelected ? Colors.white : color,
                    size: 24,
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            type['label'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? color : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityButton(Map<String, dynamic> sev) {
    final isSelected = _selectedSeverity == sev['value'];
    final color = sev['color'] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeverity = sev['value'];
          _severityPercent = sev['basePercent'];
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : const Color(0xFFF9FAFB), // gray-50
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              sev['label'],
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPhotoState() {
    return GestureDetector(
      onTap: () {
        // In real usage, verify permissions and open camera
        setState(() {
          // Simulate adding photos for preview
          _photos.add('https://picsum.photos/200');
        });
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
          ), // Dashed border needs CustomPainter, typically solid is fine for MVP or use package
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[50]!.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Color(0xFF0057FF),
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Adicionar Fotos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tire fotos para documentar a ocorrência',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            // IA Scanner Button Overlay
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Scanner IA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _photos.length + (_photos.length < 9 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _photos.length) {
          // Add Button
          return GestureDetector(
            onTap: () {
              setState(() {
                _photos.add(
                  'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/200',
                );
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                color: Colors
                    .grey[50], // Blue-ish tint on hover not easy in mobile
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Adicionar',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        final photo = _photos[index];
        return Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  photo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => setState(() => _photos.removeAt(index)),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
