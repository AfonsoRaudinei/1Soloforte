import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'widgets/comparison_model.dart';
import 'widgets/comparison_editor_widget.dart';
import 'widgets/roi_editor_widget.dart';
import 'widgets/conclusion_editor_widget.dart';
import 'package:uuid/uuid.dart';

/// Tela de criação/edição de Case de Marketing
/// Conversão fiel do HTML fornecido + Funcionalidades Implementadas
class MarketingPublicationEditorScreen extends StatefulWidget {
  const MarketingPublicationEditorScreen({super.key});

  @override
  State<MarketingPublicationEditorScreen> createState() =>
      _MarketingPublicationEditorScreenState();
}

class _MarketingPublicationEditorScreenState
    extends State<MarketingPublicationEditorScreen> {
  // Configs
  final ImagePicker _picker = ImagePicker();
  final _uuid = const Uuid();

  // Controllers Básicos
  final _produtorController = TextEditingController();
  final _produtoController = TextEditingController();
  final _localController = TextEditingController();
  final _valorController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _ganhoController = TextEditingController();
  final _economiaADController = TextEditingController();
  final _economiaRController = TextEditingController();
  final _vendedorController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _talhaoController = TextEditingController();
  final _tamanhoHaController = TextEditingController();
  final _conclusaoController = TextEditingController();

  // Estado da UI
  String _selectedType = 'resultado';
  String _selectedSize = 'silver';
  String _selectedUnit = 'sc/ha';

  // Imagens Principais
  String? _photoAntes;
  String? _photoDepois;
  String? _photoResultado;

  // Listas Dinâmicas (Avaliação/Campo)
  final List<ComparisonModel> _comparisons = [];
  bool _showRoi = false;
  bool _showConclusion = false;

  // Cores
  static const _primary = Color(0xFF0057FF);
  static const _gray100 = Color(0xFFF5F5F7);
  static const _gray200 = Color(0xFFE5E5EA);
  static const _gray400 = Color(0xFFAEAEB2);
  static const _gray600 = Color(0xFF8E8E93);
  static const _gray900 = Color(0xFF1C1C1E);
  static const _bronze = Color(0xFFCD7F32);
  static const _silver = Color(0xFFC0C0C0);
  static const _gold = Color(0xFFFFD700);

  @override
  void dispose() {
    _produtorController.dispose();
    _produtoController.dispose();
    _localController.dispose();
    _valorController.dispose();
    _quantidadeController.dispose();
    _ganhoController.dispose();
    _economiaADController.dispose();
    _economiaRController.dispose();
    _vendedorController.dispose();
    _telefoneController.dispose();
    _descricaoController.dispose();
    _talhaoController.dispose();
    _tamanhoHaController.dispose();
    _conclusaoController.dispose();
    super.dispose();
  }

  // --- Lógica de Imagem ---

  Future<void> _pickMainImage(String type) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200, // Compressão leve (resize)
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (type == 'antes')
            _photoAntes = image.path;
          else if (type == 'depois')
            _photoDepois = image.path;
          else if (type == 'resultado')
            _photoResultado = image.path;
        });
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao selecionar imagem')),
      );
    }
  }

  void _removeMainImage(String type) {
    setState(() {
      if (type == 'antes')
        _photoAntes = null;
      else if (type == 'depois')
        _photoDepois = null;
      else if (type == 'resultado')
        _photoResultado = null;
    });
  }

  // --- Lógica de Adição Dinâmica ---

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem('Avaliação', () {
              setState(() {
                _comparisons.add(ComparisonModel(id: _uuid.v4()));
              });
              Navigator.pop(ctx);
            }),
            if (!_showConclusion)
              _buildMenuItem('Conclusão', () {
                setState(() => _showConclusion = true);
                Navigator.pop(ctx);
              }),
            if (!_showRoi)
              _buildMenuItem('ROI', () {
                setState(() => _showRoi = true);
                Navigator.pop(ctx);
              }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _gray200, width: 0.5)),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 17, color: _gray900),
        ),
      ),
    );
  }

  // --- BUILD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content Scrollable
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), // Espaço para o footer
            child: Column(
              children: [
                _buildHeader(),
                _buildTypeSection(),
                _buildVisibilitySection(),

                // Seções Condicionais por Tipo
                if (_selectedType == 'antes-depois') _buildAntesDepoisPhotos(),
                if (_selectedType == 'resultado') _buildResultadoPhoto(),
                if (_selectedType == 'avaliacao') ...[
                  _buildTalhaoSection(),
                  _buildComparisonsList(),
                  if (_showConclusion || _showRoi) const SizedBox(height: 12),
                  // Renderiza ROI e Conclusão APÓS lista de avaliações, se ativos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        if (_showRoi)
                          RoiEditorWidget(
                            onDelete: () => setState(() => _showRoi = false),
                          ),
                        if (_showConclusion)
                          ConclusionEditorWidget(
                            controller: _conclusaoController,
                            onDelete: () =>
                                setState(() => _showConclusion = false),
                          ),
                      ],
                    ),
                  ),
                  _buildAddButton(),
                ],

                // Seções Comuns
                _buildInformacoesSection(),
                if (_selectedType != 'avaliacao') _buildProdutividadeSection(),
                if (_selectedType == 'antes-depois') _buildGanhosSection(),
                if (_selectedType == 'resultado') _buildResultadoSection(),
                _buildVendedorSection(),
                _buildDescricaoSection(),
              ],
            ),
          ),
          // Footer fixo
          _buildFooter(),
        ],
      ),
    );
  }

  // --- Widgets de Seção ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(bottom: BorderSide(color: _gray200, width: 0.5)),
      ),
      child: SafeArea(
        bottom: false,
        child: const Text(
          'Novo Case',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
            color: _gray900,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSection() {
    return _buildSection(
      title: 'TIPO',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _gray100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedType,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: _gray400),
            style: const TextStyle(fontSize: 17, color: _gray900),
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
            onChanged: (value) {
              if (value != null) setState(() => _selectedType = value);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return _buildSection(
      title: 'VISIBILIDADE',
      child: Row(
        children: [
          Expanded(child: _buildSizeButton('Bronze', 'bronze', _bronze)),
          const SizedBox(width: 10),
          Expanded(child: _buildSizeButton('Prata', 'silver', _silver)),
          const SizedBox(width: 10),
          Expanded(child: _buildSizeButton('Ouro', 'gold', _gold)),
        ],
      ),
    );
  }

  Widget _buildSizeButton(String label, String value, Color color) {
    final isActive = _selectedSize == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: value == 'bronze'
                      ? [const Color(0xFFCD7F32), const Color(0xFFA0522D)]
                      : value == 'silver'
                      ? [const Color(0xFFE8E8E8), const Color(0xFFA9A9A9)]
                      : [const Color(0xFFFFD700), const Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : _gray100,
          borderRadius: BorderRadius.circular(14),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
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
                  : _gray600,
            ),
          ),
        ),
      ),
    );
  }

  // --- Fotos Principais ---

  Widget _buildAntesDepoisPhotos() {
    return _buildSection(
      title: 'FOTOS',
      child: Row(
        children: [
          Expanded(
            child: _buildPhotoBox(
              label: 'Antes',
              photo: _photoAntes,
              onTap: () => _pickMainImage('antes'),
              onRemove: () => _removeMainImage('antes'),
              showTag: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPhotoBox(
              label: 'Depois',
              photo: _photoDepois,
              onTap: () => _pickMainImage('depois'),
              onRemove: () => _removeMainImage('depois'),
              showTag: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultadoPhoto() {
    return _buildSection(
      title: 'FOTO',
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: _buildPhotoBox(
            label: 'Adicionar foto',
            photo: _photoResultado,
            onTap: () => _pickMainImage('resultado'),
            onRemove: () => _removeMainImage('resultado'),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoBox({
    required String label,
    required String? photo,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    bool showTag = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _gray100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: photo == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    size: 48,
                    color: _gray400.withOpacity(0.3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(photo), fit: BoxFit.cover),
                  ),
                  // Remove Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                  if (showTag)
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
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            label.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  // --- Seção Avaliação/Talhão ---

  Widget _buildTalhaoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _gray200, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TALHÃO',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _gray600,
              letterSpacing: -0.08,
            ),
          ),
          const SizedBox(height: 12),
          _buildFieldVisual(
            label: 'Nome do Talhão',
            controller: _talhaoController,
            placeholder: 'Ex: Talhão Norte',
          ),
          const SizedBox(height: 16),
          _buildFieldVisual(
            label: 'Tamanho (ha)',
            controller: _tamanhoHaController,
            placeholder: '0.00',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonsList() {
    if (_comparisons.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(_comparisons.length, (index) {
          final item = _comparisons[index];
          return ComparisonEditorWidget(
            key: ValueKey(item.id),
            model: item,
            index: index,
            onUpdate: () => setState(() {}), // Rebuild pai se necessário
            onDelete: () => setState(() => _comparisons.removeAt(index)),
          );
        }),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: _showAddMenu,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: _gray200,
              width: 2,
            ), // dashed simulation logic: actually solid but light
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              '+ Adicionar',
              style: TextStyle(
                fontSize: 17,
                color: _primary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Seções Comuns Reutilizadas ---

  Widget _buildInformacoesSection() {
    return _buildSection(
      title: 'INFORMAÇÕES',
      child: Column(
        children: [
          _buildFieldVisual(
            label: 'Produtor / Fazenda',
            controller: _produtorController,
            placeholder: 'Ex: Fazenda Santa Rita',
          ),
          const SizedBox(height: 16),
          _buildFieldVisual(
            label: 'Produto Utilizado',
            controller: _produtoController,
            placeholder: 'Ex: Soja Olimpo',
          ),
          const SizedBox(height: 16),
          _buildFieldVisual(
            label: 'Localização',
            controller: _localController,
            placeholder: 'Jataizinho - PR',
          ),
        ],
      ),
    );
  }

  Widget _buildProdutividadeSection() {
    return _buildSection(
      title: 'PRODUTIVIDADE',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildFieldVisual(
              label: 'Valor',
              controller: _valorController,
              placeholder: '80',
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unidade',
                  style: TextStyle(fontSize: 13, color: _gray600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _gray100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedUnit,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: _gray400),
                      style: const TextStyle(fontSize: 17, color: _gray900),
                      items: const [
                        DropdownMenuItem(value: 'sc/ha', child: Text('sc/ha')),
                        DropdownMenuItem(
                          value: 'ton/ha',
                          child: Text('ton/ha'),
                        ),
                        DropdownMenuItem(value: 'kg/ha', child: Text('kg/ha')),
                      ],
                      onChanged: (val) => setState(() => _selectedUnit = val!),
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

  Widget _buildGanhosSection() {
    return _buildSection(
      title: 'GANHOS',
      child: Column(
        children: [
          _buildFieldVisual(
            label: 'Ganho de Produtividade',
            controller: _ganhoController,
            placeholder: '+38%',
          ),
          const SizedBox(height: 16),
          _buildFieldVisual(
            label: 'Economia Gerada',
            controller: _economiaADController,
            placeholder: 'R\$ 22.000',
          ),
        ],
      ),
    );
  }

  Widget _buildResultadoSection() {
    return _buildSection(
      title: 'RESULTADO',
      child: Column(
        children: [
          _buildFieldVisual(
            label: 'Quantidade Produzida',
            controller: _quantidadeController,
            placeholder: '120',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildFieldVisual(
            label: 'Economia (opcional)',
            controller: _economiaRController,
            placeholder: 'R\$ 22.000',
          ),
        ],
      ),
    );
  }

  Widget _buildVendedorSection() {
    return _buildSection(
      title: 'VENDEDOR',
      child: Column(
        children: [
          _buildFieldVisual(
            label: 'Nome',
            controller: _vendedorController,
            placeholder: 'Carlos Silva',
          ),
          const SizedBox(height: 16),
          _buildFieldVisual(
            label: 'Telefone',
            controller: _telefoneController,
            placeholder: '(43) 99876-5432',
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildDescricaoSection() {
    return _buildSection(
      title: 'DESCRIÇÃO (OPCIONAL)',
      child: _buildFieldVisual(
        controller: _descricaoController,
        placeholder: 'Descreva o case...',
        maxLines: 4,
      ),
    );
  }

  // --- Helpers ---

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _gray200, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _gray600,
              letterSpacing: -0.08,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildFieldVisual({
    String? label,
    required TextEditingController controller,
    String? placeholder,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label, style: const TextStyle(fontSize: 13, color: _gray600)),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 17, color: _gray900),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: _gray400),
            filled: true,
            fillColor: _gray100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: const Border(top: BorderSide(color: _gray200, width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gray100,
                  foregroundColor: _gray900,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _handlePublish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Publicar',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('💾 Rascunho salvo!')));
  }

  void _handlePublish() {
    // Validação básica
    if (_produtorController.text.isEmpty || _produtoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos obrigatórios (Produtor/Produto)'),
        ),
      );
      return;
    }

    // Validação de fotos
    if (_selectedType == 'resultado' && _photoResultado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione a foto do resultado')),
      );
      return;
    }
    if (_selectedType == 'antes-depois' &&
        (_photoAntes == null || _photoDepois == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione fotos de antes e depois')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Case publicado com sucesso!')),
    );
  }
}
