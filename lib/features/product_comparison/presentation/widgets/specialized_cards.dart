import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../domain/comparison_models.dart';
import 'comparison_widgets.dart';

class ProducerHeaderCard extends StatelessWidget {
  final Meta meta;
  final Function() onChanged;

  const ProducerHeaderCard({super.key, required this.meta, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DADOS DO PRODUTOR', style: AppTypography.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          _buildField('Nome do Produtor', meta.produtor, (v) { meta.produtor = v; onChanged(); }),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: _buildField('Cidade/UF', meta.cidade, (v) { meta.cidade = v; onChanged(); })),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildField('Fazenda', meta.fazenda, (v) { meta.fazenda = v; onChanged(); })),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: _buildField('Talhão', meta.talhao, (v) { meta.talhao = v; onChanged(); })),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildField('Hectares', meta.tamanhoHa.toString(), (v) { 
                meta.tamanhoHa = double.tryParse(v) ?? 0; 
                onChanged(); 
              }, keyboardType: TextInputType.number)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String initialValue, Function(String) onChanged, {TextInputType? keyboardType}) {
    return TextFormField(
      initialValue: initialValue == '0' && keyboardType == TextInputType.number ? '' : initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        isDense: true,
        border: const UnderlineInputBorder(),
      ),
      style: AppTypography.bodyText,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}

class ComparisonCard extends StatefulWidget {
  final Avaliacao avaliacao;
  final Function() onChanged;
  final Function() onRemove;

  const ComparisonCard({
    super.key,
    required this.avaliacao,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<ComparisonCard> createState() => _ComparisonCardState();
}

class _ComparisonCardState extends State<ComparisonCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _buildHeader(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: widget.avaliacao.colapsado ? 0 : null,
              child: widget.avaliacao.colapsado 
                ? const SizedBox.shrink() 
                : Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: widget.avaliacao.layout == 1 ? _buildLayout1() : _buildLayout2(),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Text('Avaliação ${widget.avaliacao.id}', style: AppTypography.bodyText.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          DropdownButton<int>(
            value: widget.avaliacao.layout,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 1, child: Text('1 foto', style: TextStyle(fontSize: 12))),
              DropdownMenuItem(value: 2, child: Text('2 fotos', style: TextStyle(fontSize: 12))),
            ],
            onChanged: (v) {
              if (v != null) {
                setState(() => widget.avaliacao.layout = v);
                widget.onChanged();
              }
            },
          ),
          IconButton(
            icon: Icon(widget.avaliacao.colapsado ? Icons.add : Icons.remove, size: 20),
            onPressed: () {
              setState(() => widget.avaliacao.colapsado = !widget.avaliacao.colapsado);
              widget.onChanged();
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: AppColors.error),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }

  Widget _buildLayout1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSideEditor(widget.avaliacao.ladoEsquerdo, isFullWidth: true),
      ],
    );
  }

  Widget _buildLayout2() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSideEditor(widget.avaliacao.ladoEsquerdo)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildSideEditor(widget.avaliacao.ladoDireito)),
      ],
    );
  }

  Widget _buildSideEditor(LadoAvaliacao lado, {bool isFullWidth = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: lado.titulo,
          decoration: const InputDecoration(hintText: 'Título (ex: Tratamento A)', isDense: true),
          style: AppTypography.bodyText.copyWith(fontWeight: FontWeight.w500),
          onChanged: (v) { lado.titulo = v; widget.onChanged(); },
        ),
        const SizedBox(height: AppSpacing.sm),
        PhotoUploadWidget(
          initialImageBase64: lado.fotoBase64,
          height: isFullWidth ? 200 : 150,
          onImageSelected: (base64) {
            lado.fotoBase64 = base64;
            widget.onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        EstadioDropdown(
          value: lado.estadio,
          onChanged: (v) {
            setState(() => lado.estadio = v ?? '');
            widget.onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: lado.anotacao,
          decoration: const InputDecoration(
            hintText: 'Anotações...',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          maxLines: 3,
          style: const TextStyle(fontSize: 13),
          onChanged: (v) { lado.anotacao = v; widget.onChanged(); },
        ),
      ],
    );
  }
}
