import 'dart:async';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'domain/comparison_models.dart';
import 'application/comparison_services.dart';
import 'application/pdf_service.dart';
import 'widgets/comparison_widgets.dart';
import 'widgets/specialized_cards.dart';
import 'widgets/additional_cards.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  Relatorio _relatorio = Relatorio.empty();
  bool _isSaving = false;
  bool _isLoading = true;
  Timer? _debounceTimer;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loaded = await _storageService.loadRelatorio();
    if (mounted) {
      setState(() {
        if (loaded != null) _relatorio = loaded;
        _isLoading = false;
      });
    }
  }

  void _triggerAutoSave() {
    setState(() => _isSaving = true);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () async {
      await _storageService.saveRelatorio(_relatorio);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    });
  }

  void _addAvaliacao() {
    setState(() {
      final id = _relatorio.avaliacoes.isEmpty ? 1 : _relatorio.avaliacoes.last.id + 1;
      _relatorio.avaliacoes.add(Avaliacao(
        id: id,
        layout: 2,
        colapsado: false,
        ladoEsquerdo: LadoAvaliacao(titulo: 'Tratamento A', estadio: '', anotacao: ''),
        ladoDireito: LadoAvaliacao(titulo: 'Tratamento B', estadio: '', anotacao: ''),
      ));
    });
    _triggerAutoSave();
  }

  void _addConclusao() {
    if (_relatorio.conclusao == null) {
      setState(() => _relatorio.conclusao = Conclusao(texto: ''));
      _triggerAutoSave();
    }
  }

  void _addROI() {
    if (_relatorio.roi == null) {
      setState(() => _relatorio.roi = ROI(investimento: 0, retorno: 0));
      _triggerAutoSave();
    }
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_a_photo_outlined),
              title: const Text('Adicionar Avaliação'),
              onTap: () { Navigator.pop(context); _addAvaliacao(); },
            ),
            ListTile(
              leading: const Icon(Icons.comment_outlined),
              title: const Text('Adicionar Conclusão'),
              onTap: () { Navigator.pop(context); _addConclusao(); },
            ),
            ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('Adicionar ROI'),
              onTap: () { Navigator.pop(context); _addROI(); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Comparativo Soja', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _buildSaveIndicator(),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                ProducerHeaderCard(meta: _relatorio.meta, onChanged: _triggerAutoSave),
                const SizedBox(height: AppSpacing.md),
                ..._relatorio.avaliacoes.map((av) => ComparisonCard(
                  avaliacao: av, 
                  onChanged: _triggerAutoSave,
                  onRemove: () {
                    setState(() => _relatorio.avaliacoes.remove(av));
                    _triggerAutoSave();
                  },
                )),
                if (_relatorio.conclusao != null)
                  ConclusaoCard(
                    conclusao: _relatorio.conclusao!, 
                    onChanged: _triggerAutoSave,
                    onRemove: () {
                      setState(() => _relatorio.conclusao = null);
                      _triggerAutoSave();
                    },
                  ),
                if (_relatorio.roi != null)
                  ROICard(
                    roi: _relatorio.roi!, 
                    area: _relatorio.meta.tamanhoHa, 
                    onChanged: _triggerAutoSave,
                    onRemove: () {
                      setState(() => _relatorio.roi = null);
                      _triggerAutoSave();
                    },
                  ),
                const SizedBox(height: AppSpacing.md),
                _buildFooterCard(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _showAddMenu,
            backgroundColor: AppColors.iosBlue,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'pdf',
            backgroundColor: AppColors.success,
            onPressed: () {
              PdfService.exportToPDF(_relatorio);
            },
            child: const Icon(Icons.picture_as_pdf, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveIndicator() {
    return AnimatedOpacity(
      opacity: _isSaving ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 300),
      child: Row(
        children: [
          if (_isSaving)
            const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.iosBlue))
          else
            const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
          const SizedBox(width: 4),
          Text(_isSaving ? 'Salvando...' : 'Salvo', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildFooterCard() {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          PhotoUploadWidget(
            initialImageBase64: _relatorio.consultor.fotoBase64,
            height: 60,
            label: 'Foto',
            onImageSelected: (base64) {
              _relatorio.consultor.fotoBase64 = base64;
              _triggerAutoSave();
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _relatorio.consultor.nome,
                  decoration: const InputDecoration(hintText: 'Nome do Consultor', isDense: true),
                  onChanged: (v) { _relatorio.consultor.nome = v; _triggerAutoSave(); },
                ),
                const Text('SoloForte • Consultoria Agrícola', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
