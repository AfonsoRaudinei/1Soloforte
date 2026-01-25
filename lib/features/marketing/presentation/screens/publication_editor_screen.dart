import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_publication.dart';
import 'package:soloforte_app/features/marketing/data/marketing_publication_repository.dart';
import 'package:soloforte_app/features/marketing/data/marketing_repository.dart';
import 'package:soloforte_app/features/marketing/domain/marketing_map_post.dart';

/// Tela de edição completa de publicação de marketing
/// Visual atualizado conforme design HTML fornecido.
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
    extends ConsumerState<PublicationEditorScreen> {
  MarketingPublication? _publication;
  bool _isLoading = true;
  bool _isSaving = false;

  // Estado visual
  String _selectedType = 'resultado'; // resultado, antes-depois, avaliacao
  String _selectedInvestmentLevel = 'silver'; // bronze, silver, gold

  // Controle de Seções Extras do modo Avaliação
  bool _showConclusion = false;
  bool _showROI = false;

  // Controllers para campos de texto
  // -- Título/Talhão/Info
  final _talhaoNameController =
      TextEditingController(); // Usado para nome talhão ou título
  final _talhaoSizeController = TextEditingController();
  final _produtorController = TextEditingController(); // clientName
  final _produtoController = TextEditingController(); // product
  final _localController = TextEditingController(); // areaName

  // -- Produtividade
  final _productivityValueController = TextEditingController();
  String _productivityUnit = 'sc/ha';

  // -- Ganhos (Antes/Depois)
  final _ganhoProdutividadeController = TextEditingController();
  final _economiaADController = TextEditingController();

  // -- Resultado
  final _qtyProduzidaController = TextEditingController();
  final _economiaResultadoController = TextEditingController();

  // -- Vendedor e Descrição
  final _vendedorNomeController = TextEditingController(); // sellerName
  final _vendedorTelController = TextEditingController(); // sellerPhone
  final _descricaoController = TextEditingController(); // description

  // -- ROI
  final _roiInvestimentoController = TextEditingController();
  final _roiRetornoController = TextEditingController();
  String _roiResult = '0%';

  // -- Conclusão
  final _conclusionController = TextEditingController();

  // Controllers para comparações (dinâmicos)
  // Mapeia comparison.id -> Controller
  final Map<String, TextEditingController> _compLabelControllers = {};
  final Map<String, TextEditingController> _compObsControllers = {};
  // Unused fields removed

  // Cores personalizadas do design
  static const Color kPrimary = Color(0xFF0057FF);
  static const Color kGray100 = Color(0xFFF5F5F7);
  static const Color kGray200 = Color(0xFFE5E5EA);
  static const Color kGray400 = Color(0xFFAEAEB2);
  static const Color kGray600 = Color(0xFF8E8E93);
  static const Color kGray900 = Color(0xFF1C1C1E);
  static const Color kBronze = Color(0xFFCD7F32);
  static const Color kSilver = Color(0xFFC0C0C0);
  static const Color kGold = Color(0xFFFFD700);

  @override
  void initState() {
    super.initState();
    _loadPublication();
  }

  @override
  void dispose() {
    _talhaoNameController.dispose();
    _talhaoSizeController.dispose();
    _produtorController.dispose();
    _produtoController.dispose();
    _localController.dispose();
    _productivityValueController.dispose();
    _ganhoProdutividadeController.dispose();
    _economiaADController.dispose();
    _qtyProduzidaController.dispose();
    _economiaResultadoController.dispose();
    _vendedorNomeController.dispose();
    _vendedorTelController.dispose();
    _descricaoController.dispose();
    _roiInvestimentoController.dispose();
    _roiRetornoController.dispose();
    _conclusionController.dispose();
    for (var c in _compLabelControllers.values) c.dispose();
    for (var c in _compObsControllers.values) c.dispose();
    super.dispose();
  }

  Future<void> _loadPublication() async {
    final repository = ref.read(marketingPublicationRepositoryProvider);

    if (widget.publicationId != null) {
      var publication = await repository.getById(widget.publicationId!);

      // Fallback para legado se não encontrar
      if (publication == null) {
        final legacyRepo = MarketingRepository();
        final legacyPosts = await legacyRepo.getMapPosts();
        final legacyPost = legacyPosts
            .where((p) => p.id == widget.publicationId)
            .firstOrNull;
        if (legacyPost != null) {
          publication = _convertFromLegacy(legacyPost);
        }
      }

      if (publication != null) {
        _publication = publication;
        _populateFields(publication);
      }
    } else {
      // Nova publicação
      _publication = MarketingPublication.create(
        latitude: widget.initialLatitude ?? 0.0,
        longitude: widget.initialLongitude ?? 0.0,
      );
      _selectedType = 'resultado';
      _initializeComparisonControllers();
    }

    setState(() {
      _isLoading = false;
    });
  }

  MarketingPublication _convertFromLegacy(MarketingMapPost legacy) {
    // Lógica de conversão mantida
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
      areaName: legacy.area, // Local
      notes: legacy.notes,
      product: legacy.product,
      investmentLevel: legacy.investmentLevel ?? 'silver',
      type: type,
      photos: legacy.photos
          .map(
            (p) => PublicationPhoto(
              id: p.path.hashCode.toString(),
              path: p.path,
              isCover: p.isCover,
            ),
          )
          .toList(),
      createdAt: legacy.createdAt,
      comparisons: [],
    );
  }

  void _populateFields(MarketingPublication pub) {
    // Popular campos básicos
    _selectedType = _getTypeString(pub.type);
    _selectedInvestmentLevel = pub.investmentLevel;

    _produtorController.text = pub.clientName ?? '';
    _produtoController.text = pub.product ?? '';
    _localController.text = pub.areaName ?? ''; // Usando areaName como Local

    // Tentar extrair dados extras das notas ou usar campos padrões
    // Assumindo que pub.title guarda o "Nome do Talhão" no modo Avaliação
    _talhaoNameController.text = pub.title ?? '';
    _vendedorNomeController.text = pub.sellerName ?? '';
    _vendedorTelController.text = pub.sellerPhone ?? '';
    _descricaoController.text = pub.description ?? '';
    _conclusionController.text = pub.notes ?? '';

    // Configurar comparações
    _initializeComparisonControllers();
  }

  String _getTypeString(PublicationType type) {
    switch (type) {
      case PublicationType.resultado:
        return 'resultado';
      case PublicationType.antesDepois:
        return 'antes-depois';
      case PublicationType.caseSucesso:
      default:
        return 'avaliacao';
    }
  }

  void _initializeComparisonControllers() {
    if (_publication == null) return;
    for (final c in _publication!.comparisons) {
      _compLabelControllers[c.id] = TextEditingController(text: c.label);
      // Aqui poderíamos ter mais campos no ComparisonEntry para guardar obs, cultura, etc.
      // Por enquanto, vamos manter simples ou usar campos existentes
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_publication == null)
      return const Scaffold(
        body: Center(child: Text("Publicação não encontrada")),
      );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  _buildTypeSection(),
                  _buildVisibilitySection(),

                  // Seção Dinâmica baseada no Tipo
                  if (_selectedType == 'antes-depois') ...[
                    _buildPhotosSectionAntesDepois(),
                  ] else if (_selectedType == 'resultado') ...[
                    _buildResultPhotoSection(),
                  ] else if (_selectedType == 'avaliacao') ...[
                    _buildAvaliacaoSection(),
                  ],

                  if (_selectedType !=
                      'avaliacao') // No visual original o avaliacao esconde produtividade
                    _buildProductivitySection(),

                  if (_selectedType == 'antes-depois') ...[
                    _buildGainsSection(),
                  ],

                  if (_selectedType == 'resultado') ...[
                    _buildResultFieldsSection(),
                  ],

                  _buildInfoSection(),

                  _buildSellerSection(),
                  _buildDescriptionSection(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  // --- WIDGETS DE SEÇÃO ---

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.95),
        border: Border(bottom: BorderSide(color: kGray200, width: 0.5)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: kPrimary),
                onPressed: () => context.pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 40), // Spacer placeholder
            ],
          ),
          const Text(
            'Novo Case',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              color: kGray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    bool hidden = false,
  }) {
    if (hidden) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGray200, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kGray600,
              letterSpacing: -0.08,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTypeSection() {
    return _buildSection(
      title: 'Tipo',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kGray100,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedType,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: kGray400),
            items: const [
              DropdownMenuItem(value: 'resultado', child: Text('Resultado')),
              DropdownMenuItem(
                value: 'antes-depois',
                child: Text('Antes/Depois'),
              ),
              DropdownMenuItem(
                value: 'avaliacao',
                child: Text('Avaliação/Campo'),
              ),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedType = val);
            },
            style: const TextStyle(
              fontSize: 17,
              color: kGray900,
              fontFamily: 'SF Pro Display',
            ),
            dropdownColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return _buildSection(
      title: 'Visibilidade',
      child: Row(
        children: [
          _buildSizeBtn('Bronze', 'bronze', kBronze),
          const SizedBox(width: 10),
          _buildSizeBtn('Prata', 'silver', kSilver),
          const SizedBox(width: 10),
          _buildSizeBtn('Ouro', 'gold', kGold),
        ],
      ),
    );
  }

  Widget _buildSizeBtn(String label, String value, Color activeColor) {
    final isActive = _selectedInvestmentLevel == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedInvestmentLevel = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isActive ? activeColor : kGray100,
            borderRadius: BorderRadius.circular(14),
            gradient: isActive
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [activeColor, activeColor.withValues(alpha: 0.8)],
                  )
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          transform: isActive
              ? Matrix4.diagonal3Values(1.05, 1.05, 1)
              : Matrix4.identity(),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? (value == 'silver' || value == 'gold'
                          ? const Color(0xFF2C2C2C)
                          : Colors.white)
                    : kGray600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- SEÇÕES DE FOTO ---

  Widget _buildPhotosSectionAntesDepois() {
    // Pegar fotos 0 e 1, ou placeholders
    PublicationPhoto? photoAntes = _getPhotoByOrder(0);
    PublicationPhoto? photoDepois = _getPhotoByOrder(1);

    return _buildSection(
      title: 'Fotos',
      child: Row(
        children: [
          Expanded(child: _buildPhotoBox('Antes', photoAntes, 0)),
          const SizedBox(width: 12),
          Expanded(child: _buildPhotoBox('Depois', photoDepois, 1)),
        ],
      ),
    );
  }

  Widget _buildResultPhotoSection() {
    PublicationPhoto? photoResult = _getPhotoByOrder(0);
    return _buildSection(
      title: 'Foto',
      child: _buildPhotoBox('Adicionar foto', photoResult, 0, isTall: true),
    );
  }

  Widget _buildPhotoBox(
    String label,
    PublicationPhoto? photo,
    int order, {
    bool isTall = false,
  }) {
    return GestureDetector(
      onTap: () => _pickPhoto(order),
      child: AspectRatio(
        aspectRatio: isTall ? 9 / 16 : 1,
        child: Container(
          constraints: isTall ? const BoxConstraints(maxHeight: 280) : null,
          decoration: BoxDecoration(
            color: kGray100,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: photo != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(photo.path),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removePhoto(order),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    if (!isTall)
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              label.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: kGray900.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kGray600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  PublicationPhoto? _getPhotoByOrder(int order) {
    if (_publication == null) return null;
    try {
      return _publication!.photos.firstWhere(
        (p) => _publication!.photos.indexOf(p) == order,
      ); // Simplificação, ideal ter campo order
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickPhoto(int index) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final newPhoto = PublicationPhoto.create(path: path);

      setState(() {
        final currentPhotos = List<PublicationPhoto>.from(_publication!.photos);
        if (index < currentPhotos.length) {
          currentPhotos[index] = newPhoto;
        } else {
          currentPhotos.add(newPhoto); // Append simple logic
        }
        _publication = _publication!.copyWith(photos: currentPhotos);
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      final currentPhotos = List<PublicationPhoto>.from(_publication!.photos);
      if (index < currentPhotos.length) {
        currentPhotos.removeAt(index);
        _publication = _publication!.copyWith(photos: currentPhotos);
      }
    });
  }

  // --- SEÇÃO AVALIAÇÃO ---

  Widget _buildAvaliacaoSection() {
    return _buildSection(
      title: 'Talhão',
      child: Column(
        children: [
          _buildInput(
            _talhaoNameController,
            label: 'Nome do Talhão',
            placeholder: 'Ex: Talhão Norte',
          ),
          const SizedBox(height: 16),
          _buildInput(
            _talhaoSizeController,
            label: 'Tamanho (ha)',
            placeholder: '0.00',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          // Lista de Comparações
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _publication!.comparisons.length,
            itemBuilder: (_, index) {
              return _buildComparisonItem(index);
            },
          ),

          if (_showConclusion) _buildConclusionItem(),

          if (_showROI) _buildROIItem(),

          // Botão Adicionar
          const SizedBox(height: 16),
          _buildAddMenuBtn(),
        ],
      ),
    );
  }

  Widget _buildAddMenuBtn() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'avaliacao') _addComparison();
        if (value == 'conclusao') setState(() => _showConclusion = true);
        if (value == 'roi') setState(() => _showROI = true);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: kGray200,
            style: BorderStyle.none,
          ), // Simplificado
        ),
        // Custom dashed border implementation is tricky in standard flutter without packages,
        // using simple outline for now or custom painter if strict.
        // Using Dashed Border placeholder style:
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: kGray400,
            style: BorderStyle.none,
          ), // Placeholder
          // To maintain design fidelity, standard border dashed is not native.
        ),
        child: const Center(
          child: Text(
            '+ Adicionar',
            style: TextStyle(color: kPrimary, fontSize: 17),
          ),
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'avaliacao', child: Text('Avaliação')),
        const PopupMenuItem(value: 'conclusao', child: Text('Conclusão')),
        const PopupMenuItem(value: 'roi', child: Text('ROI')),
      ],
    );
  }

  void _addComparison() {
    final newItem = ComparisonEntry.create(
      label: 'Avaliação',
      order: _publication!.comparisons.length,
    );
    setState(() {
      _publication = _publication!.copyWith(
        comparisons: [..._publication!.comparisons, newItem],
      );
    });
  }

  Widget _buildComparisonItem(int index) {
    // Layout logic: 1 or 2 photos.

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kGray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avaliação ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        var list = List<ComparisonEntry>.from(
                          _publication!.comparisons,
                        );
                        list.removeAt(index);
                        _publication = _publication!.copyWith(
                          comparisons: list,
                        );
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Grid 2 Columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildSmallLabel('Produto A'),
                    const SizedBox(height: 8),
                    _buildPhotoBoxSimple('Foto A'),
                    const SizedBox(height: 8),
                    _buildDropdownSmall(['Soja', 'Milho'], 'Cultura'),
                    const SizedBox(height: 8),
                    _buildTextAreaSimple('Observações...'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildSmallLabel('Produto B'),
                    const SizedBox(height: 8),
                    _buildPhotoBoxSimple('Foto B'),
                    const SizedBox(height: 8),
                    _buildDropdownSmall(['Soja', 'Milho'], 'Cultura'),
                    const SizedBox(height: 8),
                    _buildTextAreaSimple('Observações...'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConclusionItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kPrimary, Color(0xFF0046CC)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Conclusão',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => setState(() => _showConclusion = false),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _conclusionController,
            maxLines: 4,
            decoration: InputDecoration(
              fillColor: Colors.white.withValues(alpha: 0.95),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              hintText: 'Digite a conclusão do case...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildROIItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF34C759), Color(0xFF30D158)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ROI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => setState(() => _showROI = false),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Investimento (R\$)',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    _buildInputSmall(_roiInvestimentoController),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Retorno (R\$)',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    _buildInputSmall(_roiRetornoController),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'ROI',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _roiResult,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- COMPONENTES AUXILIARES ---

  Widget _buildSmallLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: kGray600,
        ),
      ),
    );
  }

  Widget _buildPhotoBoxSimple(String label) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kGray200, style: BorderStyle.solid),
      ),
      child: Center(
        child: Text(label, style: const TextStyle(color: kGray400)),
      ),
    );
  }

  Widget _buildDropdownSmall(List<String> items, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGray200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 13)),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {},
        ),
      ),
    );
  }

  Widget _buildTextAreaSimple(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGray200),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 13, color: kGray400),
        ),
        maxLines: 3,
        minLines: 2,
      ),
    );
  }

  Widget _buildInputSmall(TextEditingController ctrl) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: (_) {
          // Calc ROI
          double i = double.tryParse(_roiInvestimentoController.text) ?? 0;
          double r = double.tryParse(_roiRetornoController.text) ?? 0;
          if (i > 0) {
            setState(
              () => _roiResult = '${(((r - i) / i) * 100).toStringAsFixed(1)}%',
            );
          }
        },
      ),
    );
  }

  // --- OUTRAS SEÇÕES (Informações, Produtividade...) ---

  Widget _buildInfoSection() {
    return _buildSection(
      title: 'Informações',
      child: Column(
        children: [
          _buildInput(
            _produtorController,
            label: 'Produtor / Fazenda',
            placeholder: 'Ex: Fazenda Santa Rita',
          ),
          const SizedBox(height: 16),
          _buildInput(
            _produtoController,
            label: 'Produto Utilizado',
            placeholder: 'Ex: Soja Olimpo',
          ),
          const SizedBox(height: 16),
          _buildInput(
            _localController,
            label: 'Localização',
            placeholder: 'Jataizinho - PR',
          ),
        ],
      ),
    );
  }

  Widget _buildProductivitySection() {
    return _buildSection(
      title: 'Produtividade',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildInput(
              _productivityValueController,
              label: 'Valor',
              placeholder: '80',
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unidade',
                  style: TextStyle(fontSize: 13, color: kGray600),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: kGray100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _productivityUnit,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'sc/ha', child: Text('sc/ha')),
                        DropdownMenuItem(
                          value: 'ton/ha',
                          child: Text('ton/ha'),
                        ),
                        DropdownMenuItem(value: 'kg/ha', child: Text('kg/ha')),
                      ],
                      onChanged: (v) => setState(() => _productivityUnit = v!),
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

  Widget _buildGainsSection() {
    return _buildSection(
      title: 'Ganhos',
      child: Column(
        children: [
          _buildInput(
            _ganhoProdutividadeController,
            label: 'Ganho de Produtividade',
            placeholder: '+38%',
          ),
          const SizedBox(height: 16),
          _buildInput(
            _economiaADController,
            label: 'Economia Gerada',
            placeholder: 'R\$ 22.000',
          ),
        ],
      ),
    );
  }

  Widget _buildResultFieldsSection() {
    return _buildSection(
      title: 'Resultado',
      child: Column(
        children: [
          _buildInput(
            _qtyProduzidaController,
            label: 'Quantidade Produzida',
            placeholder: '120',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildInput(
            _economiaResultadoController,
            label: 'Economia (opcional)',
            placeholder: 'R\$ 22.000',
          ),
        ],
      ),
    );
  }

  Widget _buildSellerSection() {
    return _buildSection(
      title: 'Vendedor',
      child: Column(
        children: [
          _buildInput(
            _vendedorNomeController,
            label: 'Nome',
            placeholder: 'Carlos Silva',
          ),
          const SizedBox(height: 16),
          _buildInput(
            _vendedorTelController,
            label: 'Telefone',
            placeholder: '(43) 99876-5432',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildSection(
      title: 'Descrição (opcional)',
      child: TextField(
        controller: _descricaoController,
        maxLines: 4,
        decoration: const InputDecoration(
          filled: true,
          fillColor: kGray100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Descreva o case...',
          hintStyle: TextStyle(color: kGray400),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller, {
    required String label,
    String? placeholder,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: kGray600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: kGray100,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
            hintText: placeholder,
            hintStyle: const TextStyle(color: kGray400),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          style: const TextStyle(fontSize: 17, color: kGray900),
        ),
      ],
    );
  }

  // --- FOOTER ---

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.95),
        border: Border(top: BorderSide(color: kGray200, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              style: TextButton.styleFrom(
                backgroundColor: kGray100,
                foregroundColor: kGray900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextButton(
              onPressed: _isSaving
                  ? null
                  : () {
                      // Publicar action
                      _save();
                    },
              style: TextButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Publicar',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ACTIONS ---

  Future<void> _save() async {
    if (_publication == null) return;
    setState(() => _isSaving = true);

    try {
      // Map controllers back to object
      PublicationType type = PublicationType.resultado;
      if (_selectedType == 'antes-depois') type = PublicationType.antesDepois;
      if (_selectedType == 'avaliacao') type = PublicationType.caseSucesso;

      _publication = _publication!.copyWith(
        type: type,
        clientName: _produtorController.text,
        product: _produtoController.text,
        areaName: _localController.text,
        sellerName: _vendedorNomeController.text,
        sellerPhone: _vendedorTelController.text,
        description: _descricaoController.text,
        investmentLevel: _selectedInvestmentLevel,
        // Persistir campos extras em Notes ou Campos adequados se o backend permitir
        // Como o backend pode não ter todos, usamos os campos padrões.
        title: _talhaoNameController.text.isNotEmpty
            ? _talhaoNameController.text
            : null,
      );

      final repository = ref.read(marketingPublicationRepositoryProvider);
      await repository.save(_publication!);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Salvo com sucesso!')));
        context.pop(_publication);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
