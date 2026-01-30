import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:soloforte_app/core/services/logger_service.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/clients/domain/client_model.dart';
import 'package:soloforte_app/features/clients/presentation/clients_controller.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';
import 'package:soloforte_app/features/occurrences/presentation/providers/occurrence_controller.dart';
import 'package:soloforte_app/shared/widgets/custom_text_input.dart';
import 'package:soloforte_app/shared/widgets/primary_button.dart';

// -----------------------------------------------------------------------------
// 1. CONTRATOS E DTOs (Inputs & Outputs Explícitos)
// -----------------------------------------------------------------------------

/// Dados imutáveis de entrada para o formulário.
/// Define TUDO que o formulário precisa para nascer.
@immutable
class OccurrenceFormInput {
  final String? initialId; // Se edição
  final String? clientId;
  final String? visitId;
  final String? title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final List<String> existingImages; // URLs
  final List<Client> availableClients;
  final bool isVisitLocked; // Se true, não deixa trocar cliente/visita

  // Dados técnicos específicos
  final String phenologicalStage;
  final Map<String, double> categorySeverities;
  final Map<String, List<String>> existingCategoryImages;
  final String technicalRecommendation;
  final String technicalResponsible;
  final String temporalType;
  final bool hasSoilSample;

  const OccurrenceFormInput({
    this.initialId,
    this.clientId,
    this.visitId,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.existingImages = const [],
    this.availableClients = const [],
    this.isVisitLocked = false,
    this.phenologicalStage = 'VE - Emergência',
    this.categorySeverities = const {},
    this.existingCategoryImages = const {},
    this.technicalRecommendation = '',
    this.technicalResponsible = '',
    this.temporalType = 'Sazonal',
    this.hasSoilSample = false,
  });

  // Factory para criar a partir de uma Occurrence existente (Edição/Recorrência)
  factory OccurrenceFormInput.fromOccurrence(
    Occurrence occ,
    List<Client> clients, {
    bool isRecurrence = false,
    String? visitId,
  }) {
    if (isRecurrence) {
      // Na recorrência, copiamos apenas dados técnicos, limpamos IDs e imagens
      return OccurrenceFormInput(
        availableClients: clients,
        clientId: occ.clientId, // Mantém cliente original
        visitId: visitId, // Usa novo visitId se fornecido
        isVisitLocked: visitId != null,
        title: occ.title, // Sugestão, usuário pode mudar
        description: 'Recorrência de: ${occ.title}',
        // Dados técnicos preservados
        phenologicalStage: occ.phenologicalStage,
        categorySeverities: occ.categorySeverities,
        technicalRecommendation: occ.technicalRecommendation,
        technicalResponsible: occ.technicalResponsible,
        temporalType: occ.temporalType,
        hasSoilSample: occ.hasSoilSample,
        // Limpa location e imagens
        latitude: null,
        longitude: null,
        existingImages: const [],
        existingCategoryImages: const {},
      );
    }

    // Edição completa
    return OccurrenceFormInput(
      initialId: occ.id,
      clientId: occ.clientId,
      visitId: occ.visitId,
      title: occ.title,
      description: occ.description,
      latitude: occ.latitude,
      longitude: occ.longitude,
      existingImages: occ.images,
      availableClients: clients,
      isVisitLocked: occ.visitId != null, // Se tem visita, trava
      phenologicalStage: occ.phenologicalStage,
      categorySeverities: occ.categorySeverities,
      existingCategoryImages: occ.categoryImages,
      technicalRecommendation: occ.technicalRecommendation,
      technicalResponsible: occ.technicalResponsible,
      temporalType: occ.temporalType,
      hasSoilSample: occ.hasSoilSample,
    );
  }
}

/// Resultado puro do formulário.
/// Não depende de models de domínio complexos, apenas dados primitivos/estruturados.
@immutable
class OccurrenceFormOutput {
  final String? id; // Null se criação
  final String clientId;
  final String? visitId;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> existingImagesToKeep;
  final List<File> newImages;

  // Dados técnicos
  final String phenologicalStage;
  final Map<String, double> categorySeverities;
  final Map<String, List<File>> newCategoryImages;
  final Map<String, List<String>> existingCategoryImagesToKeep;
  final String technicalRecommendation;
  final String technicalResponsible;
  final String temporalType;
  final bool hasSoilSample;

  const OccurrenceFormOutput({
    this.id,
    required this.clientId,
    this.visitId,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.existingImagesToKeep,
    required this.newImages,
    required this.phenologicalStage,
    required this.categorySeverities,
    required this.newCategoryImages,
    required this.existingCategoryImagesToKeep,
    required this.technicalRecommendation,
    required this.technicalResponsible,
    required this.temporalType,
    required this.hasSoilSample,
  });
}

// -----------------------------------------------------------------------------
// 2. SMART WIDGET (Container / Controller de Tela)
// Responsável por: Dependências Externas (Riverpod, GPS, Navigation)
// -----------------------------------------------------------------------------

class NewOccurrenceScreen extends ConsumerStatefulWidget {
  final Occurrence? initialOccurrence;
  final String? initialTitle;
  final String? initialDescription;
  final String? initialImagePath;
  final double? initialLatitude;
  final double? initialLongitude;
  final Occurrence? recurrentFrom;
  final String? clientId;
  final String? visitId;

  final String? initialType;
  final double? initialSeverity;

  const NewOccurrenceScreen({
    super.key,
    this.initialOccurrence,
    this.initialTitle,
    this.initialDescription,
    this.initialImagePath,
    this.initialType,
    this.initialSeverity,
    this.initialLatitude,
    this.initialLongitude,
    this.recurrentFrom,
    this.clientId,
    this.visitId,
  });

  @override
  ConsumerState<NewOccurrenceScreen> createState() =>
      _NewOccurrenceScreenState();
}

class _NewOccurrenceScreenState extends ConsumerState<NewOccurrenceScreen> {
  // Estado de carregamento inicial (infra)
  bool _isLoadingParams = true;
  OccurrenceFormInput? _formInput;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _prepareFormInput();
  }

  Future<void> _prepareFormInput() async {
    try {
      // 1. Carregar dependências globais (Clientes)
      final clients = await ref.read(clientsControllerProvider.future);

      // 2. Construir Input baseado nos parâmetros
      if (widget.initialOccurrence != null) {
        // Edição
        _formInput = OccurrenceFormInput.fromOccurrence(
          widget.initialOccurrence!,
          clients,
        );
      } else if (widget.recurrentFrom != null) {
        // Recorrência
        _formInput = OccurrenceFormInput.fromOccurrence(
          widget.recurrentFrom!,
          clients,
          isRecurrence: true,
          visitId: widget.visitId,
        );
      } else {
        // Criação Nova
        _formInput = OccurrenceFormInput(
          clientId: widget.clientId,
          visitId: widget.visitId,
          title: widget.initialTitle,
          description: widget.initialDescription,
          latitude: widget.initialLatitude,
          longitude: widget.initialLongitude,
          isVisitLocked: widget.visitId != null,
          availableClients: clients,
          categorySeverities: widget.initialType != null
              ? {widget.initialType!: widget.initialSeverity ?? 0.5}
              : const {},
        );
      }

      // Se imagem inicial via argumento (ex: de outra tela), tratar aqui se necessário
      // Mas o Input oficial não aceita File direto, apenas lógica interna do form.
      // Para simplificar, não passamos o arquivo inicial no input puro, ou adaptamos o form.
      // Vamos manter simples: se veio imagem externa, o form terá que lidar com "arquivos iniciais".
    } catch (e, s) {
      LoggerService.e('Error preparing form', error: e, stackTrace: s);
      _errorMessage = 'Falha ao carregar dados iniciais: $e';
    } finally {
      if (mounted) setState(() => _isLoadingParams = false);
    }
  }

  // Ações de Infraestrutura (Injetadas no Form)

  Future<Map<String, double>?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'GPS desativado';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw 'Permissão negada';
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Permissão negada permanentemente';
      }

      final pos = await Geolocator.getCurrentPosition();
      return {'lat': pos.latitude, 'long': pos.longitude};
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro GPS: $e')));
      return null;
    }
  }

  Future<File?> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    return picked != null ? File(picked.path) : null;
  }

  Future<void> _handleSubmit(OccurrenceFormOutput output) async {
    // Aqui converte Output -> Domain Entity -> Chama Repository
    // Isolamento: O Form não sabe salvar. O Container sabe.
    try {
      final isEdit = output.id != null;
      final severity = _calculateOverallSeverity(output.categorySeverities);

      // Upload de imagens seria feito aqui ou no repository.
      // Para manter simples, assumimos que o repository lida com List<File>.
      // Mas o entity espera List<String> (URLs).
      // O ideal é o Controller fazer upload e pegar URLs.

      // Mock de upload (retorna path local como URL por enquanto)
      final allNewImagePaths = output.newImages.map((f) => f.path).toList();
      final finalImages = [...output.existingImagesToKeep, ...allNewImagePaths];

      // Mapear imagens de categoria
      final finalCategoryImages = <String, List<String>>{};
      // (Lógica simplificada de upload de categorias omitida para brevidade - assumindo paths locais)
      output.existingCategoryImagesToKeep.forEach(
        (k, v) => finalCategoryImages[k] = v,
      );
      output.newCategoryImages.forEach((k, files) {
        finalCategoryImages[k] = [
          ...?finalCategoryImages[k],
          ...files.map((f) => f.path),
        ];
      });

      final occurrence = Occurrence(
        id: output.id ?? const Uuid().v4(),
        clientId: output.clientId,
        visitId: output.visitId,
        title: output.title,
        description: output.description,
        type: 'Técnica', // Fixo ou derivado
        severity: severity,
        areaName: 'Talhão Padrão', // Falta input, simplificado
        date: DateTime.now(),
        status: 'open',
        images: finalImages,
        latitude: output.latitude,
        longitude: output.longitude,
        phenologicalStage: output.phenologicalStage,
        categorySeverities: output.categorySeverities,
        categoryImages: finalCategoryImages,
        technicalRecommendation: output.technicalRecommendation,
        technicalResponsible: output.technicalResponsible,
        temporalType: output.temporalType,
        hasSoilSample: output.hasSoilSample,
      );

      // Salvar via Riverpod
      if (isEdit) {
        await ref
            .read(occurrenceControllerProvider.notifier)
            .updateOccurrence(occurrence);
      } else {
        await ref
            .read(occurrenceControllerProvider.notifier)
            .addOccurrence(occurrence);
      }

      if (mounted) Navigator.pop(context);
    } catch (e, s) {
      LoggerService.e('Submit failed', error: e, stackTrace: s);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  double _calculateOverallSeverity(Map<String, double> severities) {
    if (severities.isEmpty) return 0.0;
    // Média ou Max? Max é mais seguro para riscos.
    return severities.values.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingParams) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _formInput!.initialId != null
              ? 'Editar Ocorrência'
              : 'Nova Ocorrência',
        ),
      ),
      body: OccurrenceForm(
        key: ValueKey(_formInput!.initialId), // Reconstrói se mudar ID
        input: _formInput!,
        initialNewImage: widget.initialImagePath != null
            ? File(widget.initialImagePath!)
            : null,
        onGetLocation: _getCurrentLocation,
        onPickImage: _pickImage,
        onSubmit: _handleSubmit,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. DUMB WIDGET (Formulário Isolado)
// Responsável por: Validação, Estado de Campos, UX Imediata
// -----------------------------------------------------------------------------

class OccurrenceForm extends StatefulWidget {
  final OccurrenceFormInput input;
  final File? initialNewImage; // Imagem avulsa vinda de fora
  final Future<Map<String, double>?> Function() onGetLocation;
  final Future<File?> Function(ImageSource source) onPickImage;
  final Future<void> Function(OccurrenceFormOutput output) onSubmit;

  const OccurrenceForm({
    super.key,
    required this.input,
    this.initialNewImage,
    required this.onGetLocation,
    required this.onPickImage,
    required this.onSubmit,
  });

  @override
  State<OccurrenceForm> createState() => _OccurrenceFormState();
}

class _OccurrenceFormState extends State<OccurrenceForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers (Estado Local)
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _techRecCtrl;
  late final TextEditingController _techRespCtrl;

  // Estado de Valores
  String? _clientId;
  String? _phenologicalStage;
  String? _temporalType;
  bool _hasSoilSample = false;
  Map<String, double> _severities = {};

  // Estado de Arquivos/Locais
  List<String> _existingImages = [];
  final List<File> _newImages = [];
  Map<String, List<String>> _existingCatImages = {};
  final Map<String, List<File>> _newCatImages = {};

  double? _latitude;
  double? _longitude;

  bool _isSubmitting = false;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final i = widget.input;
    _titleCtrl = TextEditingController(text: i.title);
    _descCtrl = TextEditingController(text: i.description);
    _techRecCtrl = TextEditingController(text: i.technicalRecommendation);
    _techRespCtrl = TextEditingController(text: i.technicalResponsible);

    _clientId = i.clientId;
    _phenologicalStage = i.phenologicalStage;
    _temporalType = i.temporalType;
    _hasSoilSample = i.hasSoilSample;
    _severities = Map.from(i.categorySeverities);

    _latitude = i.latitude;
    _longitude = i.longitude;

    _existingImages = List.from(i.existingImages);
    _existingCatImages = Map.from(i.existingCategoryImages);

    // Se veio imagem avulsa externa
    if (widget.initialNewImage != null) {
      _newImages.add(widget.initialNewImage!);
    }

    // Se não tem localização, tenta buscar (único side-effect permitido no init se necessário)
    if (_latitude == null || _longitude == null) {
      _requestLocation();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _techRecCtrl.dispose();
    _techRespCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestLocation() async {
    setState(() => _isLocating = true);
    final loc = await widget.onGetLocation();
    if (mounted) {
      setState(() {
        _isLocating = false;
        if (loc != null) {
          _latitude = loc['lat'];
          _longitude = loc['long'];
        }
      });
    }
  }

  Future<void> _handleAddImage({String? category}) async {
    // Mostra bottom sheet local ou chama picker direto?
    // Vamos chamar direto para simplificar, em app real mostraria modal
    final file = await widget.onPickImage(ImageSource.camera);
    if (file != null && mounted) {
      setState(() {
        if (category != null) {
          _newCatImages.putIfAbsent(category, () => []).add(file);
        } else {
          _newImages.add(file);
        }
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_clientId == null && !widget.input.isVisitLocked) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um cliente')));
      return;
    }
    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Localização obrigatória')));
      return;
    }

    setState(() => _isSubmitting = true);

    final output = OccurrenceFormOutput(
      id: widget.input.initialId,
      clientId: _clientId!,
      visitId: widget.input.visitId,
      title: _titleCtrl.text,
      description: _descCtrl.text,
      latitude: _latitude!,
      longitude: _longitude!,
      existingImagesToKeep: _existingImages,
      newImages: _newImages,
      phenologicalStage: _phenologicalStage ?? 'VE - Emergência',
      categorySeverities: _severities,
      existingCategoryImagesToKeep: _existingCatImages,
      newCategoryImages: _newCatImages,
      technicalRecommendation: _techRecCtrl.text,
      technicalResponsible: _techRespCtrl.text,
      temporalType: _temporalType ?? 'Sazonal',
      hasSoilSample: _hasSoilSample,
    );

    await widget.onSubmit(output);

    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. Cliente ---
            _buildClientDropdown(),
            SizedBox(height: AppSpacing.lg),

            // --- 2. Fotos Principais ---
            _buildPhotoSection(),
            SizedBox(height: AppSpacing.lg),

            // --- 3. Localização ---
            _buildLocationSection(),
            SizedBox(height: AppSpacing.md),

            // --- 4. Inputs Básicos ---
            CustomTextInput(
              label: 'Título',
              controller: _titleCtrl,
              validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
            ),
            SizedBox(height: AppSpacing.md),
            CustomTextInput(
              label: 'Descrição',
              controller: _descCtrl,
              maxLines: 2,
            ),
            SizedBox(height: AppSpacing.lg),

            // --- 5. Dados Técnicos ---
            _buildSectionHeader('Dados Técnicos'),
            SizedBox(height: AppSpacing.md),
            _buildPhenologicalDropdown(),
            SizedBox(height: AppSpacing.md),
            _buildCategoriesSection(),
            SizedBox(height: AppSpacing.md),

            CustomTextInput(
              label: 'Recomendação Técnica',
              controller: _techRecCtrl,
              hint: 'Ex: Aplicação de fungicida...',
              maxLines: 3,
            ),
            SizedBox(height: AppSpacing.lg),

            // --- 6. Rodapé ---
            PrimaryButton(
              text: 'Salvar Ocorrência',
              isLoading: _isSubmitting,
              onPressed: _submit,
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // --- Sub-Widgets de UI (Private) ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(color: AppColors.primary),
    );
  }

  Widget _buildClientDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _clientId,
      decoration: const InputDecoration(
        labelText: 'Cliente',
        border: OutlineInputBorder(),
      ),
      items: widget.input.availableClients
          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
          .toList(),
      onChanged: widget.input.isVisitLocked
          ? null
          : (v) => setState(() => _clientId = v),
      validator: (v) => v == null ? 'Obrigatório' : null,
    );
  }

  Widget _buildPhotoSection() {
    // Simplificado para brevidade - Lista Horizontal de Fotos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fotos', style: AppTypography.label),
        SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () => _handleAddImage(),
                child: Container(
                  width: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.add_a_photo),
                ),
              ),
              ..._existingImages.map((url) => _imageThumb(url, isFile: false)),
              ..._newImages.map((file) => _imageThumb(file.path, isFile: true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageThumb(String path, {required bool isFile}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 8),
      color: Colors.black12,
      child: isFile
          ? Image.file(File(path), fit: BoxFit.cover)
          : Image.network(path, fit: BoxFit.cover),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: _latitude != null
                ? Text(
                    'Lat: ${_latitude!.toStringAsFixed(6)}\nLong: ${_longitude!.toStringAsFixed(6)}',
                    style: AppTypography.bodySmall,
                  )
                : const Text('Localização não capturada'),
          ),
          if (!_isLocating)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _requestLocation,
            )
          else
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildPhenologicalDropdown() {
    const stages = [
      'VE - Emergência',
      'V1 - 1ª Trifoliolada',
      'R1 - Florescimento',
      'R8 - Maturação Plena',
    ];
    // Garantir que o valor atual esteja na lista, senão fallback
    final effectiveValue = stages.contains(_phenologicalStage)
        ? _phenologicalStage
        : stages.first;

    return DropdownButtonFormField<String>(
      initialValue: effectiveValue,
      decoration: const InputDecoration(
        labelText: 'Estádio Fenológico',
        border: OutlineInputBorder(),
      ),
      items: stages
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
      onChanged: (v) => setState(() => _phenologicalStage = v),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = ['Doença', 'Insetos', 'Ervas daninhas', 'Nutrientes'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categorias', style: AppTypography.label),
        ...categories.map((cat) {
          final isSelected = _severities.containsKey(cat);
          return CheckboxListTile(
            title: Text(cat),
            value: isSelected,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _severities[cat] = 0.5; // Default severity
                } else {
                  _severities.remove(cat);
                }
              });
            },
            subtitle: isSelected
                ? Slider(
                    value: _severities[cat]!,
                    onChanged: (v) => setState(() => _severities[cat] = v),
                  )
                : null,
          );
        }),
      ],
    );
  }
}
