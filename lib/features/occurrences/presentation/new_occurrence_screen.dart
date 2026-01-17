import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_controller.dart';
import 'package:soloforte_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:soloforte_app/core/services/analytics_service.dart';
import 'package:soloforte_app/shared/widgets/custom_text_input.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewOccurrenceScreen extends ConsumerStatefulWidget {
  final Occurrence? initialOccurrence;
  // Pre-filled data from other sources (e.g. Scanner)
  final String? initialTitle;
  final String? initialDescription;
  final String? initialType;
  final String? initialImagePath;
  final double? initialSeverity;
  // Pre-filled coordinates from map pin selection
  final double? initialLatitude;
  final double? initialLongitude;
  // Recurrence: creates new occurrence from existing, copying only technical data
  final Occurrence? recurrentFrom;
  final String? clientId;

  const NewOccurrenceScreen({
    super.key,
    this.initialOccurrence,
    this.initialTitle,
    this.initialDescription,
    this.initialType,
    this.initialImagePath,
    this.initialSeverity,
    this.initialLatitude,
    this.initialLongitude,
    this.recurrentFrom,
    this.clientId,
  });

  @override
  ConsumerState<NewOccurrenceScreen> createState() =>
      _NewOccurrenceScreenState();
}

class _NewOccurrenceScreenState extends ConsumerState<NewOccurrenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // New State variables
  String _phenologicalStage = 'VE - Emergência';
  final Map<String, double> _categorySeverities = {};
  final _techRecommendationController = TextEditingController();
  final _techResponsibleController = TextEditingController();
  String _temporalType = 'Sazonal';
  bool _hasSoilSample = false;

  final List<String> _validCategories = [
    'Doença',
    'Insetos',
    'Ervas daninhas',
    'Nutrientes',
    'Água',
  ];

  final List<String> _phenologicalStages = [
    'VE - Emergência',
    'VC - Cotilédones',
    'V1 - 1ª Trifoliolada',
    'V2 - 2ª Trifoliolada',
    'V3 - 3ª Trifoliolada',
    'V4 - 4ª Trifoliolada',
    'V5 - 5ª Trifoliolada',
    'R1 - Florescimento',
    'R2 - Floração Plena',
    'R3 - Vagens 1cm',
    'R4 - Vagens 2cm',
    'R5.1 - Início Enchimento',
    'R5.3 - 50% Enchimento',
    'R5.5 - 100% Enchimento',
    'R6 - Grãos Formados',
    'R7 - Início Maturação',
    'R8 - Maturação Plena',
  ];

  // Legacy/Helper
  String _selectedArea = 'Talhão Norte';
  bool _isLoading = false;
  String? _clientId;

  double? _latitude;
  double? _longitude;
  bool _isGettingLocation = false;
  final List<File> _capturedImages = [];
  final ImagePicker _picker = ImagePicker();

  // State
  List<String> _existingImages = [];
  final Map<String, List<File>> _capturedCategoryImages = {};
  final Map<String, List<String>> _existingCategoryImages = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialOccurrence != null) {
      final occ = widget.initialOccurrence!;
      _clientId = occ.clientId;
      _titleController.text = occ.title;
      _descriptionController.text = occ.description;
      // Map legacy type if needed, but rely on new categories
      // _selectedType = occ.type;
      // _severity = occ.severity;
      _selectedArea = occ.areaName;
      _latitude = occ.latitude;
      _longitude = occ.longitude;
      _existingImages = List.from(occ.images);

      // Load new fields
      _phenologicalStage = occ.phenologicalStage;
      _categorySeverities.addAll(occ.categorySeverities);
      _techRecommendationController.text = occ.technicalRecommendation;
      _techResponsibleController.text = occ.technicalResponsible;
      _temporalType = occ.temporalType;
      _hasSoilSample = occ.hasSoilSample;

      // Load category images
      if (occ.categoryImages.isNotEmpty) {
        _existingCategoryImages.addAll(occ.categoryImages);
      }
    } else if (widget.recurrentFrom != null) {
      // RECURRENCE: Copy only technical data, NOT images/location/status/date/timeline
      final src = widget.recurrentFrom!;
      _clientId = src.clientId;

      // Technical data to copy
      _phenologicalStage = src.phenologicalStage;
      _categorySeverities.addAll(src.categorySeverities);
      _techRecommendationController.text = src.technicalRecommendation;
      _techResponsibleController.text = src.technicalResponsible;
      _temporalType = src.temporalType;
      _hasSoilSample = src.hasSoilSample;
      _selectedArea = src.areaName;
      _descriptionController.text = 'Recorrência de: ${src.title}';

      // DO NOT copy: id, date, status, images, categoryImages, location, timeline
      // Get current location for new occurrence
      _getCurrentLocation();
    } else {
      _clientId = widget.clientId;
      // Pre-fill from arguments if available
      if (widget.initialTitle != null) {
        _titleController.text = widget.initialTitle!;
      }
      if (widget.initialDescription != null) {
        _descriptionController.text = widget.initialDescription!;
      }
      // if (widget.initialType != null) _selectedType = widget.initialType!;
      // if (widget.initialSeverity != null) _severity = widget.initialSeverity!;
      if (widget.initialImagePath != null) {
        _capturedImages.add(File(widget.initialImagePath!));
      }

      // Use pre-filled coordinates from map pin selection if available
      if (widget.initialLatitude != null && widget.initialLongitude != null) {
        _latitude = widget.initialLatitude;
        _longitude = widget.initialLongitude;
      } else {
        _getCurrentLocation();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Serviço de localização desativado';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Permissão de localização negada';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Permissão de localização permanentemente negada';
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao obter GPS: $e')));
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _capturedImages.add(File(picked.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context, [String? category]) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () {
                Navigator.pop(ctx);
                if (category != null) {
                  _pickCategoryImage(category, ImageSource.camera);
                } else {
                  _pickImage(ImageSource.camera);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(ctx);
                if (category != null) {
                  _pickCategoryImage(category, ImageSource.gallery);
                } else {
                  _pickImage(ImageSource.gallery);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCategoryImage(String category, ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          if (!_capturedCategoryImages.containsKey(category)) {
            _capturedCategoryImages[category] = [];
          }
          _capturedCategoryImages[category]!.add(File(picked.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialOccurrence != null
              ? 'Editar Ocorrência'
              : 'Nova Ocorrência',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photos Section
              if (_capturedImages.isEmpty)
                GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo,
                            size: 32,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicionar Fotos',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        _existingImages.length + _capturedImages.length + 1,
                    itemBuilder: (context, index) {
                      // Logic to handle mixed list (existing + captured + add button)
                      final totalItems =
                          _existingImages.length + _capturedImages.length;

                      if (index == totalItems) {
                        // Add Button
                        return GestureDetector(
                          onTap: () => _showImageSourceActionSheet(context),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 32,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }

                      // Determine if it's existing or captured
                      ImageProvider imageProvider;
                      VoidCallback onDelete;

                      if (index < _existingImages.length) {
                        final url = _existingImages[index];
                        if (url.startsWith('http')) {
                          imageProvider = NetworkImage(url);
                        } else {
                          imageProvider = FileImage(File(url));
                        }
                        onDelete = () {
                          setState(() {
                            _existingImages.removeAt(index);
                          });
                        };
                      } else {
                        final capturedIndex = index - _existingImages.length;
                        imageProvider = FileImage(
                          _capturedImages[capturedIndex],
                        );
                        onDelete = () {
                          setState(() {
                            _capturedImages.removeAt(capturedIndex);
                          });
                        };
                      }

                      return Stack(
                        children: [
                          Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 12,
                            child: GestureDetector(
                              onTap: onDelete,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              SizedBox(height: AppSpacing.lg),

              // Estádio Fenológico
              Text('Estádio Fenológico', style: AppTypography.label),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _phenologicalStage,
                    isExpanded: true,
                    items: _phenologicalStages.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => _phenologicalStage = newValue);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              // Categorias e Severidade
              Text('Categorias da Ocorrência', style: AppTypography.label),
              const SizedBox(height: 8),
              ..._validCategories.map((category) {
                final isSelected = _categorySeverities.containsKey(category);
                final severity = _categorySeverities[category] ?? 0.5;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.withOpacity(0.05)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade200,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _categorySeverities[category] = 0.5;
                                } else {
                                  _categorySeverities.remove(category);
                                  // Optional: Clean up images if deselected? Keeping for now to avoid data loss.
                                }
                              });
                            },
                          ),
                          Text(category, style: AppTypography.bodyMedium),
                        ],
                      ),
                      if (isSelected) ...[
                        Row(
                          children: [
                            Text('Severidade', style: AppTypography.caption),
                            Expanded(
                              child: Slider(
                                value: severity,
                                onChanged: (val) {
                                  setState(() {
                                    _categorySeverities[category] = val;
                                  });
                                },
                                activeColor: _getSeverityColor(severity),
                              ),
                            ),
                            Text(
                              '${(severity * 100).toInt()}%',
                              style: AppTypography.bodySmall.copyWith(
                                color: _getSeverityColor(severity),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Category Photos UI
                        Container(
                          height: 80,
                          margin: const EdgeInsets.only(top: 8),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // Add Button for Category
                              GestureDetector(
                                onTap: () => _showImageSourceActionSheet(
                                  context,
                                  category,
                                ),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),

                              // Existing Category Images
                              if (_existingCategoryImages.containsKey(category))
                                ..._existingCategoryImages[category]!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final url = entry.value;
                                      return Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: _buildSafeImageThumbnail(
                                                url,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _existingCategoryImages[category]!
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),

                              // Captured Category Images
                              if (_capturedCategoryImages.containsKey(category))
                                ..._capturedCategoryImages[category]!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                      final index = entry.key;
                                      final file = entry.value;
                                      return Stack(
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: _buildSafeFileThumbnail(
                                                file,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _capturedCategoryImages[category]!
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              SizedBox(height: AppSpacing.lg),

              // Observações Gerais
              CustomTextInput(
                label: 'Observações Gerais',
                hint: 'Descreva os detalhes da ocorrência...',
                controller: _descriptionController,
                maxLines: 3,
              ),
              SizedBox(height: AppSpacing.lg),

              // Recomendações Técnicas
              CustomTextInput(
                label: 'Recomendações Técnicas',
                hint: 'Insira as recomendações para manejo...',
                controller: _techRecommendationController,
                maxLines: 3,
              ),
              SizedBox(height: AppSpacing.lg),

              // Responsável Técnico
              CustomTextInput(
                label: 'Responsável Técnico',
                hint: 'Nome do responsável',
                controller: _techResponsibleController,
              ),
              SizedBox(height: AppSpacing.lg),

              // Tipo de Ocorrência
              Text('Tipo de Ocorrência', style: AppTypography.label),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Sazonal'),
                      value: 'Sazonal',
                      groupValue: _temporalType,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _temporalType = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Permanente'),
                      value: 'Permanente',
                      groupValue: _temporalType,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _temporalType = val!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),

              // Amostra de Solo
              SwitchListTile(
                title: Text(
                  'Amostra de Solo Coletada?',
                  style: AppTypography.bodyMedium,
                ),
                value: _hasSoilSample,
                onChanged: (val) => setState(() => _hasSoilSample = val),
                activeThumbColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(height: AppSpacing.lg),

              // Location Section (Reused Visuals)
              Text('Localização (GPS)', style: AppTypography.label),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: _latitude != null
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_latitude != null && _longitude != null) ...[
                            Text(
                              'Lat: ${_latitude!.toStringAsFixed(6)}',
                              style: AppTypography.bodySmall,
                            ),
                            Text(
                              'Lng: ${_longitude!.toStringAsFixed(6)}',
                              style: AppTypography.bodySmall,
                            ),
                          ] else
                            Text(
                              'Obtendo localização...',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (_isGettingLocation)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        onPressed: _getCurrentLocation,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Atualizar GPS',
                      ),
                  ],
                ),
              ),

              // Submit Button
              PrimaryButton(
                text: widget.initialOccurrence != null
                    ? 'Salvar Alterações'
                    : 'Registrar Ocorrência',
                isLoading: _isLoading,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(double value) {
    if (value < 0.3) return AppColors.success;
    if (value < 0.7) return AppColors.warning;
    return AppColors.error;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_clientId == null || _clientId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um cliente para registrar a ocorrência.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Check for Demo Mode
    final authState = ref.read(authStateProvider).value;
    if (authState?.isDemo == true) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Modo Demonstração',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Dados não são salvos neste modo.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.blueGrey,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context); // Close form
      }
      return;
    }

    // Logger would be used here if imported, for now just print is safe or assume import
    // LoggerService.i('Submitting occurrence: ${_titleController.text}');

    try {
      // Prepare category images
      final Map<String, List<String>> finalCategoryImages = {};

      // Merge existing
      _existingCategoryImages.forEach((key, value) {
        finalCategoryImages[key] = List.from(value);
      });

      // Merge captured
      _capturedCategoryImages.forEach((key, value) {
        if (!finalCategoryImages.containsKey(key)) {
          finalCategoryImages[key] = [];
        }
        finalCategoryImages[key]!.addAll(value.map((e) => e.path));
      });

      final finalImages = [
        ..._existingImages,
        ..._capturedImages.map((e) => e.path),
      ];

      final occurrenceData = Occurrence(
        id: widget.initialOccurrence?.id ?? const Uuid().v4(),
        title: _categorySeverities.isNotEmpty
            ? _categorySeverities.keys.join(', ')
            : 'Ocorrência', // Default title if not using text input
        description: _descriptionController.text,
        type: _categorySeverities.isNotEmpty
            ? (_categorySeverities.containsKey('Doença')
                  ? 'disease'
                  : _categorySeverities.containsKey('Insetos')
                  ? 'pest'
                  : _categorySeverities.containsKey('Ervas daninhas')
                  ? 'weed'
                  : _categorySeverities.containsKey('Nutrientes')
                  ? 'deficiency'
                  : 'other')
            : 'other',
        severity: _categorySeverities.isNotEmpty
            ? _categorySeverities.values.reduce(
                (a, b) => a > b ? a : b,
              ) // Max severity
            : 0.0,
        areaName: _selectedArea,
        clientId: _clientId!,
        date: widget.initialOccurrence?.date ?? DateTime.now(),
        status: widget.initialOccurrence?.status ?? 'active',
        images: finalImages,
        latitude: _latitude ?? -23.5505,
        longitude: _longitude ?? -46.6333,
        phenologicalStage: _phenologicalStage,
        categorySeverities: _categorySeverities,
        categoryImages: finalCategoryImages,
        technicalRecommendation: _techRecommendationController.text,
        technicalResponsible: _techResponsibleController.text,
        temporalType: _temporalType,
        hasSoilSample: _hasSoilSample,
        timeline: _buildTimeline(),
      );

      if (widget.initialOccurrence != null) {
        await ref
            .read(occurrenceControllerProvider.notifier)
            .updateOccurrence(occurrenceData);
      } else {
        await ref
            .read(occurrenceControllerProvider.notifier)
            .addOccurrence(occurrenceData);
      }

      if (mounted) {
        // GOLD RULE UX: What happened? Where saved? What now?
        final message = widget.initialOccurrence != null
            ? 'Atualizado com sucesso!'
            : 'Salvo em "Ocorrências"';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Sincronizando com a nuvem...',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2), // Give time to read
          ),
        );

        // Wait slightly for UX feeling of completion
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          ref.read(analyticsServiceProvider).logEvent('occurrence_saved');
          context.pop(true);
        }
      }
    } catch (e) {
      // LoggerService.e('Error saving occurrence', error: e, stackTrace: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro crítico: $e'),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Tentar Novamente',
              textColor: Colors.white,
              onPressed: _submitForm,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Builds a safe image thumbnail with error handling for both file paths and network URLs.
  /// Handles kIsWeb to avoid File operations on web platform.
  Widget _buildSafeImageThumbnail(String pathOrUrl, {double size = 80}) {
    final isNetwork =
        pathOrUrl.startsWith('http') || pathOrUrl.startsWith('https');

    if (isNetwork) {
      return Image.network(
        pathOrUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(size),
      );
    }

    // On web, file paths don't work - show placeholder
    if (kIsWeb) {
      return _buildImagePlaceholder(size);
    }

    return Image.file(
      File(pathOrUrl),
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildImagePlaceholder(size),
    );
  }

  Widget _buildSafeFileThumbnail(File file, {double size = 80}) {
    if (kIsWeb) {
      return _buildImagePlaceholder(size);
    }
    return Image.file(
      file,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildImagePlaceholder(size),
    );
  }

  Widget _buildImagePlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 24),
      ),
    );
  }

  /// Builds the timeline for the occurrence based on context:
  /// - Edit: Appends "Editada" event to existing timeline
  /// - Recurrence: Creates new timeline with "Recorrência" event
  /// - Create: Creates new timeline with "Registrada" event
  List<TimelineEvent> _buildTimeline() {
    final now = DateTime.now();

    if (widget.initialOccurrence != null) {
      // EDIT: Append edit event to existing timeline
      return [
        ...widget.initialOccurrence!.timeline,
        TimelineEvent(
          id: const Uuid().v4(),
          title: 'Ocorrência Editada',
          description: 'Dados da ocorrência atualizados.',
          date: now,
          type: 'edit',
          authorName: 'Usuário',
        ),
      ];
    } else if (widget.recurrentFrom != null) {
      // RECURRENCE: New timeline with recurrence event
      return [
        TimelineEvent(
          id: const Uuid().v4(),
          title: 'Ocorrência Recorrente',
          description: 'Criada a partir de: ${widget.recurrentFrom!.title}',
          date: now,
          type: 'recurrence',
          authorName: 'Usuário',
        ),
      ];
    } else {
      // CREATE: New timeline
      return [
        TimelineEvent(
          id: const Uuid().v4(),
          title: 'Ocorrência Registrada',
          description: 'Identificação inicial do problema.',
          date: now,
          type: 'create',
          authorName: 'Usuário',
        ),
      ];
    }
  }
}
