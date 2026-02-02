import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_theme.dart';
import '../../application/comparison_services.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const GlassCard({super.key, required this.child, this.padding, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            const Color(0xFFF5F5F7).withOpacity(0.98),
          ],
        ),
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.card,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.large,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

class PhotoUploadWidget extends StatefulWidget {
  final String? initialImageBase64;
  final Function(String) onImageSelected;
  final double height;
  final String label;

  const PhotoUploadWidget({
    super.key,
    this.initialImageBase64,
    required this.onImageSelected,
    this.height = 150,
    this.label = 'Adicionar Foto',
  });

  @override
  State<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
  String? _imageBase64;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageBase64 = widget.initialImageBase64;
  }

  @override
  void didUpdateWidget(PhotoUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImageBase64 != oldWidget.initialImageBase64) {
      _imageBase64 = widget.initialImageBase64;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
      imageQuality: 92,
    );
    
    if (photo != null) {
      setState(() => _isLoading = true);
      try {
        final compressed = await ImageService.compressImage(File(photo.path));
        setState(() {
          _imageBase64 = compressed;
          _isLoading = false;
        });
        widget.onImageSelected(compressed);
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao processar imagem: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: AppRadius.medium,
          border: _imageBase64 == null 
              ? Border.all(color: AppColors.border, style: BorderStyle.solid) 
              : null,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _imageBase64 != null
                ? ClipRRect(
                    borderRadius: AppRadius.medium,
                    child: Image.memory(
                      base64Decode(_imageBase64!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_outlined, color: AppColors.textSecondary),
                      const SizedBox(height: AppSpacing.sm),
                      Text(widget.label, style: AppTypography.sectionTitle),
                    ],
                  ),
      ),
    );
  }
}

class EstadioDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const EstadioDropdown({super.key, required this.value, required this.onChanged});

  static const estadios = [
    {'value': '', 'label': 'Estádio Fenológico'},
    {'value': 'VE', 'label': 'VE - Emergência'},
    {'value': 'VC', 'label': 'VC - Cotilédones'},
    {'value': 'V1', 'label': 'V1 - Primeiro nó'},
    {'value': 'V2', 'label': 'V2 - Segundo nó'},
    {'value': 'V3', 'label': 'V3 - Terceiro nó'},
    {'value': 'V4', 'label': 'V4 - Quarto nó'},
    {'value': 'V5', 'label': 'V5 - Quinto nó'},
    {'value': 'V6', 'label': 'V6 - Sexto nó'},
    {'value': 'R1', 'label': 'R1 - Floração'},
    {'value': 'R2', 'label': 'R2 - Floração Plena'},
    {'value': 'R3', 'label': 'R3 - Início Formação Vagem'},
    {'value': 'R4', 'label': 'R4 - Vagem Formada'},
    {'value': 'R5', 'label': 'R5 - Início Enchimento Grão'},
    {'value': 'R6', 'label': 'R6 - Grão Cheio'},
    {'value': 'R7', 'label': 'R7 - Início Maturação'},
    {'value': 'R8', 'label': 'R8 - Maturação Plena'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? '' : value,
          isExpanded: true,
          items: estadios.map((e) {
            return DropdownMenuItem<String>(
              value: e['value'],
              child: Text(e['label']!, style: AppTypography.bodyText),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
