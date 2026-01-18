import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';
import 'package:soloforte_app/features/marketing/data/marketing_publication_repository.dart';
// Compatibilidade com modelo legado
import 'package:soloforte_app/features/marketing/data/marketing_repository.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_map_post.dart';

/// Tela de edição completa de publicação de marketing
/// Rota: /#/map/marketing/edit?id=XYZ (edição) ou /#/map/marketing/edit (criação)
class PublicationEditorScreen extends ConsumerStatefulWidget {
  final String? publicationId;
  final double? initialLatitude;
  final double? initialLongitude;

  const PublicationEditorScreen({
    super.key,
    this.publicationId,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  ConsumerState<PublicationEditorScreen> createState() =>
      _PublicationEditorScreenState();
}

class _PublicationEditorScreenState
    extends ConsumerState<PublicationEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MarketingPublication? _publication;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasChanges = false;

  // Controllers para campos de texto
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productController = TextEditingController();
  final _campaignController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _areaNameController = TextEditingController();
  final _sellerNameController = TextEditingController();
  final _sellerPhoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _notesController = TextEditingController();

  // Controllers para comparações (dinâmicos)
  final Map<String, TextEditingController> _labelControllers = {};
  final Map<String, TextEditingController> _productivityControllers = {};
  final Map<String, TextEditingController> _ndviControllers = {};
  final Map<String, TextEditingController> _biomassControllers = {};

  String _selectedInvestmentLevel = 'prata';
  String _highlightMetric = 'productivity';
  bool _showPercentage = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPublication();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _productController.dispose();
    _campaignController.dispose();
    _clientNameController.dispose();
    _areaNameController.dispose();
    _sellerNameController.dispose();
    _sellerPhoneController.dispose();
    _companyNameController.dispose();
    _notesController.dispose();
    _labelControllers.values.forEach((c) => c.dispose());
    _productivityControllers.values.forEach((c) => c.dispose());
    _ndviControllers.values.forEach((c) => c.dispose());
    _biomassControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  Future<void> _loadPublication() async {
    final repository = ref.read(marketingPublicationRepositoryProvider);
    final legacyRepository = MarketingRepository();

    if (widget.publicationId != null) {
      // Modo edição: carregar publicação existente
      var publication = await repository.getById(widget.publicationId!);

      // Fallback: buscar no repositório legado e converter
      if (publication == null) {
        final legacyPosts = await legacyRepository.getMapPosts();
        final legacyPost = legacyPosts
            .where((p) => p.id == widget.publicationId)
            .firstOrNull;

        if (legacyPost != null) {
          // Converter MarketingMapPost legado para MarketingPublication
          publication = _convertFromLegacy(legacyPost);
        }
      }

      if (publication != null) {
        _publication = publication;
        _populateFields(publication);
      }
    } else if (widget.initialLatitude != null &&
        widget.initialLongitude != null) {
      // Modo criação: criar nova publicação
      _publication = MarketingPublication.create(
        latitude: widget.initialLatitude!,
        longitude: widget.initialLongitude!,
      );
      _initializeComparisonControllers();
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// Converte um MarketingMapPost legado para MarketingPublication
  MarketingPublication _convertFromLegacy(MarketingMapPost legacy) {
    // Converter fotos
    final photos = legacy.photos
        .map(
          (p) => PublicationPhoto(
            id: p.path.hashCode.toString(),
            path: p.path,
            caption: p.caption,
            isCover: p.isCover,
          ),
        )
        .toList();

    // Determinar tipo
    final type = legacy.type == 'resultado'
        ? PublicationType.resultado
        : legacy.type == 'antes-depois'
        ? PublicationType.antesDepois
        : PublicationType.caseSucesso;

    return MarketingPublication(
      id: legacy.id,
      latitude: legacy.latitude,
      longitude: legacy.longitude,
      title: legacy.title,
      clientName: legacy.client,
      areaName: legacy.area,
      notes: legacy.notes,
      product: legacy.product,
      investmentLevel: legacy.investmentLevel ?? 'prata',
      type: type,
      photos: photos,
      createdAt: legacy.createdAt,
      comparisons: [
        ComparisonEntry.create(label: 'Antes', order: 0),
        ComparisonEntry.create(label: 'Depois', order: 1),
      ],
    );
  }

  void _populateFields(MarketingPublication publication) {
    _titleController.text = publication.title ?? '';
    _descriptionController.text = publication.description ?? '';
    _productController.text = publication.product ?? '';
    _campaignController.text = publication.campaign ?? '';
    _clientNameController.text = publication.clientName ?? '';
    _areaNameController.text = publication.areaName ?? '';
    _sellerNameController.text = publication.sellerName ?? '';
    _sellerPhoneController.text = publication.sellerPhone ?? '';
    _companyNameController.text = publication.companyName ?? '';
    _notesController.text = publication.notes ?? '';
    _selectedInvestmentLevel = publication.investmentLevel;
    _highlightMetric = publication.highlightMetric ?? 'productivity';
    _showPercentage = publication.showPercentage;

    _initializeComparisonControllers();
  }

  void _initializeComparisonControllers() {
    if (_publication == null) return;

    for (final comparison in _publication!.comparisons) {
      _labelControllers[comparison.id] = TextEditingController(
        text: comparison.label,
      );
      _productivityControllers[comparison.id] = TextEditingController(
        text: comparison.productivity?.toString() ?? '',
      );
      _ndviControllers[comparison.id] = TextEditingController(
        text: comparison.ndvi?.toString() ?? '',
      );
      _biomassControllers[comparison.id] = TextEditingController(
        text: comparison.biomass?.toString() ?? '',
      );
    }
  }

  Future<void> _save() async {
    if (_publication == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Atualizar campos da publicação
      final updatedComparisons = _publication!.comparisons.map((c) {
        return c.copyWith(
          label: _labelControllers[c.id]?.text ?? c.label,
          productivity: double.tryParse(
            _productivityControllers[c.id]?.text ?? '',
          ),
          ndvi: double.tryParse(_ndviControllers[c.id]?.text ?? ''),
          biomass: double.tryParse(_biomassControllers[c.id]?.text ?? ''),
        );
      }).toList();

      _publication = _publication!.copyWith(
        title: _titleController.text.isNotEmpty ? _titleController.text : null,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
        product: _productController.text.isNotEmpty
            ? _productController.text
            : null,
        campaign: _campaignController.text.isNotEmpty
            ? _campaignController.text
            : null,
        clientName: _clientNameController.text.isNotEmpty
            ? _clientNameController.text
            : null,
        areaName: _areaNameController.text.isNotEmpty
            ? _areaNameController.text
            : null,
        sellerName: _sellerNameController.text.isNotEmpty
            ? _sellerNameController.text
            : null,
        sellerPhone: _sellerPhoneController.text.isNotEmpty
            ? _sellerPhoneController.text
            : null,
        companyName: _companyNameController.text.isNotEmpty
            ? _companyNameController.text
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        investmentLevel: _selectedInvestmentLevel,
        highlightMetric: _highlightMetric,
        showPercentage: _showPercentage,
        comparisons: updatedComparisons,
      );

      final repository = ref.read(marketingPublicationRepositoryProvider);
      await repository.save(_publication!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Publicação salva com sucesso'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop(_publication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao salvar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _delete() async {
    if (_publication == null || widget.publicationId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Publicação'),
        content: const Text(
          'Tem certeza que deseja excluir esta publicação? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final repository = ref.read(marketingPublicationRepositoryProvider);
      await repository.delete(_publication!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Publicação excluída'),
            backgroundColor: AppColors.warning,
          ),
        );
        context.pop(null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao excluir: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickPhotosForComparison(int index) async {
    if (_publication == null) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) return;

    final newPhotos = result.files
        .where((f) => f.path != null)
        .map(
          (f) => PublicationPhoto.create(
            path: f.path!,
            order: _publication!.comparisons[index].photos.length,
          ),
        )
        .toList();

    setState(() {
      final comparison = _publication!.comparisons[index];
      final updatedComparison = comparison.copyWith(
        photos: [...comparison.photos, ...newPhotos],
      );
      final updatedList = List<ComparisonEntry>.from(_publication!.comparisons);
      updatedList[index] = updatedComparison;
      _publication = _publication!.copyWith(comparisons: updatedList);
      _hasChanges = true;
    });
  }

  void _removePhotoFromComparison(int compIndex, int photoIndex) {
    if (_publication == null) return;

    setState(() {
      final comparison = _publication!.comparisons[compIndex];
      final updatedPhotos = List<PublicationPhoto>.from(comparison.photos)
        ..removeAt(photoIndex);
      final updatedComparison = comparison.copyWith(photos: updatedPhotos);
      final updatedList = List<ComparisonEntry>.from(_publication!.comparisons);
      updatedList[compIndex] = updatedComparison;
      _publication = _publication!.copyWith(comparisons: updatedList);
      _hasChanges = true;
    });
  }

  void _addComparison() {
    if (_publication == null) return;

    final newComparison = ComparisonEntry.create(
      label: 'Item ${_publication!.comparisons.length + 1}',
      order: _publication!.comparisons.length,
    );

    _labelControllers[newComparison.id] = TextEditingController(
      text: newComparison.label,
    );
    _productivityControllers[newComparison.id] = TextEditingController();
    _ndviControllers[newComparison.id] = TextEditingController();
    _biomassControllers[newComparison.id] = TextEditingController();

    setState(() {
      _publication = _publication!.copyWith(
        comparisons: [..._publication!.comparisons, newComparison],
      );
      _hasChanges = true;
    });
  }

  void _removeComparison(int index) {
    if (_publication == null || _publication!.comparisons.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Mínimo de 2 itens para comparação')),
      );
      return;
    }

    final compId = _publication!.comparisons[index].id;
    _labelControllers[compId]?.dispose();
    _labelControllers.remove(compId);
    _productivityControllers[compId]?.dispose();
    _productivityControllers.remove(compId);
    _ndviControllers[compId]?.dispose();
    _ndviControllers.remove(compId);
    _biomassControllers[compId]?.dispose();
    _biomassControllers.remove(compId);

    setState(() {
      final updatedList = List<ComparisonEntry>.from(_publication!.comparisons)
        ..removeAt(index);
      _publication = _publication!.copyWith(comparisons: updatedList);
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isNewPublication = widget.publicationId == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () {
            if (_hasChanges) {
              _showDiscardDialog();
            } else {
              context.pop();
            }
          },
        ),
        title: Text(
          isNewPublication ? 'Nova Publicação' : 'Editar Publicação',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isNewPublication)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: _delete,
            ),
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Salvar',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Dados'),
            Tab(text: 'Comparativo'),
            Tab(text: 'Resultado'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _publication == null
          ? _buildErrorState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDadosTab(),
                _buildComparativoTab(),
                _buildResultadoTab(),
              ],
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          const Text('Publicação não encontrada'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDadosTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seção: Informações do Case
          _buildSectionCard(
            title: 'Informações do Case',
            icon: Icons.info_outline,
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Título',
                hint: 'Ex: Case de Sucesso - Fazenda São João',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Descrição',
                hint: 'Descreva o case...',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _productController,
                label: 'Produto',
                hint: 'Ex: SoloForte Premium',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _campaignController,
                label: 'Campanha/Safra',
                hint: 'Ex: Safra 2024/25',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Seção: Cliente e Área
          _buildSectionCard(
            title: 'Cliente e Área',
            icon: Icons.location_on_outlined,
            children: [
              _buildTextField(
                controller: _clientNameController,
                label: 'Nome do Produtor/Cliente',
                hint: 'Ex: José da Silva',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _areaNameController,
                label: 'Local/Talhão',
                hint: 'Ex: Talhão Norte - 50ha',
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.gps_fixed, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Lat: ${_publication?.latitude.toStringAsFixed(6)}\nLng: ${_publication?.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Seção: Vendedor/Consultor
          _buildSectionCard(
            title: 'Vendedor/Consultor',
            icon: Icons.person_outline,
            children: [
              _buildTextField(
                controller: _sellerNameController,
                label: 'Nome',
                hint: 'Ex: Maria Consultora',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _sellerPhoneController,
                label: 'Telefone',
                hint: 'Ex: (11) 99999-9999',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _companyNameController,
                label: 'Empresa',
                hint: 'Ex: Agro Solutions',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Seção: Configurações
          _buildSectionCard(
            title: 'Configurações do Card',
            icon: Icons.settings_outlined,
            children: [
              const Text(
                'Nível de Destaque',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              _buildInvestmentSelector(),
            ],
          ),
          const SizedBox(height: 20),

          // Seção: Observações
          _buildSectionCard(
            title: 'Observações',
            icon: Icons.note_outlined,
            children: [
              _buildTextField(
                controller: _notesController,
                label: 'Notas internas',
                hint: 'Anotações adicionais...',
                maxLines: 4,
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildComparativoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com botão de adicionar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Itens de Comparação',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: _addComparison,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Adicionar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione itens para comparar (ex: Antes/Depois, Testemunha/Tratamento)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // Lista de comparações
          if (_publication != null)
            ...List.generate(
              _publication!.comparisons.length,
              (index) => _buildComparisonCard(index),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(int index) {
    final comparison = _publication!.comparisons[index];
    final canRemove = _publication!.comparisons.length > 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _labelControllers[comparison.id],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nome do item...',
                      isDense: true,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    onChanged: (_) => _hasChanges = true,
                  ),
                ),
                if (canRemove)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: AppColors.error,
                    onPressed: () => _removeComparison(index),
                  ),
              ],
            ),
          ),

          // Fotos
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fotos',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPhotoGrid(comparison.photos, index),
              ],
            ),
          ),

          // Métricas
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Métricas',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricField(
                        controller: _productivityControllers[comparison.id]!,
                        label: 'Produtividade',
                        suffix: 'sc/ha',
                        icon: Icons.trending_up,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricField(
                        controller: _ndviControllers[comparison.id]!,
                        label: 'NDVI',
                        suffix: '',
                        icon: Icons.satellite_alt,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildMetricField(
                  controller: _biomassControllers[comparison.id]!,
                  label: 'Biomassa',
                  suffix: 't/ha',
                  icon: Icons.grass,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid(List<PublicationPhoto> photos, int compIndex) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Fotos existentes
        ...photos.asMap().entries.map((entry) {
          final photoIndex = entry.key;
          final photo = entry.value;
          return _buildPhotoTile(photo, compIndex, photoIndex);
        }),
        // Botão de adicionar
        _buildAddPhotoButton(() => _pickPhotosForComparison(compIndex)),
      ],
    );
  }

  Widget _buildPhotoTile(
    PublicationPhoto photo,
    int compIndex,
    int photoIndex,
  ) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(photo.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removePhotoFromComparison(compIndex, photoIndex),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: const Icon(
          Icons.add_photo_alternate_outlined,
          color: AppColors.primary,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildResultadoTab() {
    if (_publication == null || _publication!.comparisons.length < 2) {
      return const Center(
        child: Text('Adicione pelo menos 2 itens de comparação'),
      );
    }

    final gain = _publication!.calculateProductivityGain();

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview do resultado
          _buildSectionCard(
            title: 'Preview do Card',
            icon: Icons.preview_outlined,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      _showPercentage
                          ? '${gain >= 0 ? '+' : ''}${gain.toStringAsFixed(1)}%'
                          : '${_publication!.comparisons.last.productivity ?? 0} sc/ha',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _highlightMetric == 'productivity'
                          ? 'Ganho de Produtividade'
                          : _highlightMetric == 'ndvi'
                          ? 'Variação NDVI'
                          : 'Variação Biomassa',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildComparisonLabel(
                          _publication!.comparisons.first.label,
                          _publication!.comparisons.first.productivity,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                        _buildComparisonLabel(
                          _publication!.comparisons.last.label,
                          _publication!.comparisons.last.productivity,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Configurações de exibição
          _buildSectionCard(
            title: 'Configurações de Exibição',
            icon: Icons.tune_outlined,
            children: [
              // Métrica destacada
              const Text(
                'Métrica Principal',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              _buildMetricSelector(),
              const SizedBox(height: 16),

              // Toggle percentual
              SwitchListTile(
                title: const Text('Mostrar percentual'),
                subtitle: const Text('Exibir ganho em % vs valor absoluto'),
                value: _showPercentage,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    _showPercentage = value;
                    _hasChanges = true;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildComparisonLabel(String label, double? value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (value != null)
          Text(
            '${value.toStringAsFixed(0)} sc/ha',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildMetricSelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(
          value: 'productivity',
          label: Text('Produtividade'),
          icon: Icon(Icons.trending_up, size: 18),
        ),
        ButtonSegment(
          value: 'ndvi',
          label: Text('NDVI'),
          icon: Icon(Icons.satellite_alt, size: 18),
        ),
        ButtonSegment(
          value: 'biomass',
          label: Text('Biomassa'),
          icon: Icon(Icons.grass, size: 18),
        ),
      ],
      selected: {_highlightMetric},
      onSelectionChanged: (values) {
        setState(() {
          _highlightMetric = values.first;
          _hasChanges = true;
        });
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      onChanged: (_) => _hasChanges = true,
    );
  }

  Widget _buildMetricField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon: Icon(icon, size: 20, color: AppColors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      onChanged: (_) => _hasChanges = true,
    );
  }

  Widget _buildInvestmentSelector() {
    final levels = [
      {'key': 'bronze', 'label': 'Bronze', 'color': const Color(0xFFCD7F32)},
      {'key': 'prata', 'label': 'Prata', 'color': const Color(0xFFC0C0C0)},
      {'key': 'ouro', 'label': 'Ouro', 'color': const Color(0xFFFFD700)},
      {
        'key': 'diamante',
        'label': 'Diamante',
        'color': const Color(0xFFB9F2FF),
      },
    ];

    return Wrap(
      spacing: 8,
      children: levels.map((level) {
        final isSelected = _selectedInvestmentLevel == level['key'];
        return ChoiceChip(
          label: Text(level['label'] as String),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedInvestmentLevel = level['key'] as String;
                _hasChanges = true;
              });
            }
          },
          selectedColor: (level['color'] as Color).withOpacity(0.3),
          avatar: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: level['color'] as Color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Descartar alterações?'),
        content: const Text(
          'Você tem alterações não salvas. Deseja descartá-las?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuar editando'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }
}
