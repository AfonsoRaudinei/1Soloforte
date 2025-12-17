import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/occurrences/domain/occurrence_model.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_provider.dart';
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

  const NewOccurrenceScreen({
    super.key,
    this.initialOccurrence,
    this.initialTitle,
    this.initialDescription,
    this.initialType,
    this.initialImagePath,
    this.initialSeverity,
  });

  @override
  ConsumerState<NewOccurrenceScreen> createState() =>
      _NewOccurrenceScreenState();
}

class _NewOccurrenceScreenState extends ConsumerState<NewOccurrenceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'pest';
  double _severity = 0.5;
  String _selectedArea = 'Talhão Norte'; // Mock default
  bool _isLoading = false;

  double? _latitude;
  double? _longitude;
  bool _isGettingLocation = false;
  final List<File> _capturedImages = [];
  final ImagePicker _picker = ImagePicker();

  // State
  List<String> _existingImages = [];
  // Mock Areas
  final List<String> _areas = [
    'Talhão Norte',
    'Lavoura Sul',
    'Área Teste',
    'Borda Oeste',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialOccurrence != null) {
      final occ = widget.initialOccurrence!;
      _titleController.text = occ.title;
      _descriptionController.text = occ.description;
      _selectedType = occ.type;
      _severity = occ.severity;
      _selectedArea = occ.areaName;
      _latitude = occ.latitude;
      _longitude = occ.longitude;
      _existingImages = List.from(occ.images);
    } else {
      // Pre-fill from arguments if available
      if (widget.initialTitle != null)
        _titleController.text = widget.initialTitle!;
      if (widget.initialDescription != null)
        _descriptionController.text = widget.initialDescription!;
      if (widget.initialType != null) _selectedType = widget.initialType!;
      if (widget.initialSeverity != null) _severity = widget.initialSeverity!;
      if (widget.initialImagePath != null) {
        _capturedImages.add(File(widget.initialImagePath!));
      }

      _getCurrentLocation();
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

  void _showImageSourceActionSheet(BuildContext context) {
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
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
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

              // Title
              CustomTextInput(
                label: 'Título',
                hint: 'Ex: Lagarta na folha',
                controller: _titleController,
                validator: (val) => val == null || val.isEmpty
                    ? 'Por favor, insira um título'
                    : null,
              ),
              SizedBox(height: AppSpacing.md),

              // Type Selector
              Text('Tipo', style: AppTypography.label),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _TypeChip(
                      label: 'Praga',
                      value: 'pest',
                      groupValue: _selectedType,
                      onChanged: (val) => setState(() => _selectedType = val),
                      icon: Icons.bug_report,
                    ),
                    const SizedBox(width: 8),
                    _TypeChip(
                      label: 'Doença',
                      value: 'disease',
                      groupValue: _selectedType,
                      onChanged: (val) => setState(() => _selectedType = val),
                      icon: Icons.coronavirus,
                    ),
                    const SizedBox(width: 8),
                    _TypeChip(
                      label: 'Deficiência',
                      value: 'deficiency',
                      groupValue: _selectedType,
                      onChanged: (val) => setState(() => _selectedType = val),
                      icon: Icons.spa,
                    ),
                    const SizedBox(width: 8),
                    _TypeChip(
                      label: 'Daninha',
                      value: 'weed',
                      groupValue: _selectedType,
                      onChanged: (val) => setState(() => _selectedType = val),
                      icon: Icons.grass,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              // Area Selector
              Text('Área Afetada', style: AppTypography.label),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedArea,
                    isExpanded: true,
                    items: _areas.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedArea = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              // Location Section
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
              SizedBox(height: AppSpacing.lg),

              // Severity Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Severidade', style: AppTypography.label),
                  Text(
                    '${(_severity * 100).toInt()}%',
                    style: AppTypography.h4.copyWith(
                      color: _getSeverityColor(_severity),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _severity,
                onChanged: (val) => setState(() => _severity = val),
                activeColor: _getSeverityColor(_severity),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Leve', style: AppTypography.caption),
                  Text('Crítica', style: AppTypography.caption),
                ],
              ),
              SizedBox(height: AppSpacing.lg),

              // Description
              CustomTextInput(
                label: 'Descrição Detalhada',
                hint: 'Descreva os sintomas observados...',
                controller: _descriptionController,
                maxLines: 4,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Insira uma descrição' : null,
              ),
              SizedBox(height: AppSpacing.xxl),

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

    setState(() => _isLoading = true);

    try {
      final finalImages = [
        ..._existingImages,
        ..._capturedImages.map((e) => e.path),
      ];

      final occurrenceData = Occurrence(
        id: widget.initialOccurrence?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        type: _selectedType,
        severity: _severity,
        areaName: _selectedArea,
        date: widget.initialOccurrence?.date ?? DateTime.now(),
        status: widget.initialOccurrence?.status ?? 'active',
        images: finalImages,
        latitude: _latitude ?? -23.5505,
        longitude: _longitude ?? -46.6333,
        timeline:
            widget.initialOccurrence?.timeline ??
            [
              TimelineEvent(
                id: const Uuid().v4(),
                title: 'Ocorrência Registrada',
                description: 'Identificação inicial do problema.',
                date: DateTime.now(),
                type: 'create',
                authorName: 'Usuário Atual',
              ),
            ],
      );

      if (widget.initialOccurrence != null) {
        await ref
            .read(occurrencesProvider.notifier)
            .updateOccurrence(occurrenceData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ocorrência atualizada com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        await ref
            .read(occurrencesProvider.notifier)
            .addOccurrence(occurrenceData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ocorrência registrada com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao registrar ocorrência'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final Function(String) onChanged;
  final IconData icon;

  const _TypeChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onChanged(value);
      },
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      showCheckmark: false,
    );
  }
}
